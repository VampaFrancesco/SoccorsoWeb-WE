let mezziGlobali = []; // Cache locale per popolare il form di modifica

document.addEventListener('DOMContentLoaded', async function() {
    console.log("Gestione Mezzi Init...");

    // Carica lista iniziale
    await loadMezzi();

    // Listener Aggiunta
    const formAdd = document.getElementById('formAddMezzo');
    if (formAdd) {
        formAdd.addEventListener('submit', handleAddMezzo);
    }

    // Listener Modifica
    const formEdit = document.getElementById('formEditMezzo');
    if (formEdit) {
        formEdit.addEventListener('submit', handleEditMezzo);
    }
});

// Caricamento Mezzi
async function loadMezzi() {
    try {
        const mezzi = await getTuttiMezzi(); // da api.js
        mezziGlobali = mezzi; // Aggiorna cache

        const containerAvail = document.getElementById('list-available');
        const containerUnavail = document.getElementById('list-unavailable');

        containerAvail.innerHTML = '';
        containerUnavail.innerHTML = '';

        let countOk = 0;
        let countKo = 0;

        if (!mezzi || mezzi.length === 0) {
            containerAvail.innerHTML = '<p style="color:#999; padding:10px;">Nessun mezzo registrato</p>';
            return;
        }

        mezzi.forEach(m => {
            const card = createCardHTML(m);
            if (m.disponibile) {
                containerAvail.appendChild(card);
                countOk++;
            } else {
                containerUnavail.appendChild(card);
                countKo++;
            }
        });

        // Aggiorna badge contatori
        document.getElementById('count-available').innerText = countOk;
        document.getElementById('count-unavailable').innerText = countKo;

    } catch (error) {
        console.error("Errore loadMezzi:", error);
        Swal.fire('Errore', 'Impossibile recuperare i mezzi', 'error');
    }
}

function createCardHTML(mezzo) {
    const div = document.createElement('div');
    div.className = `vehicle-card ${mezzo.disponibile ? 'available' : 'unavailable'}`;
    const swapTitle = mezzo.disponibile ? "Sposta in Manutenzione" : "Rendi Disponibile";

    div.innerHTML = `
        <div class="vehicle-info">
            <h4>${mezzo.nome} <span class="targa-badge">${mezzo.targa || 'N/D'}</span></h4>
            <p>${mezzo.tipo} &bull; ${mezzo.descrizione || 'Nessuna nota'}</p>
        </div>
        <div class="vehicle-actions">
            <!-- SWAP STATO -->
            <button class="btn-action swap" onclick="toggleStato(${mezzo.id}, ${mezzo.disponibile})" title="${swapTitle}">
                <i class="fas fa-exchange-alt"></i>
            </button>

            <!-- EDIT -->
            <button class="btn-action edit" onclick="openEditModal(${mezzo.id})" title="Modifica Dati">
                <i class="fas fa-pencil-alt"></i>
            </button>

            <!-- STORICO -->
            <button class="btn-action details" onclick="showHistory(${mezzo.id}, '${mezzo.nome}')" title="Storico Missioni">
                <i class="fas fa-list-ul"></i>
            </button>

            <!-- DELETE -->
            <button class="btn-action delete" onclick="handleDelete(${mezzo.id})" title="Elimina Mezzo">
                <i class="fas fa-trash-alt"></i>
            </button>
        </div>
    `;
    return div;
}

// LOGICA DI MODIFICA
function openEditModal(id) {
    const mezzo = mezziGlobali.find(m => m.id === id);
    if (!mezzo) return;

    // Popola i campi
    document.getElementById('edit_m_id').value = mezzo.id;
    document.getElementById('edit_m_nome').value = mezzo.nome;
    document.getElementById('edit_m_targa').value = mezzo.targa;
    document.getElementById('edit_m_tipo').value = mezzo.tipo;
    document.getElementById('edit_m_descrizione').value = mezzo.descrizione || '';

    openModal('modal-edit');
}

async function handleEditMezzo(e) {
    e.preventDefault();
    const id = document.getElementById('edit_m_id').value;

    const payload = {
        nome: document.getElementById('edit_m_nome').value,
        targa: document.getElementById('edit_m_targa').value,
        tipo: document.getElementById('edit_m_tipo').value,
        descrizione: document.getElementById('edit_m_descrizione').value
    };

    try {
        Swal.showLoading();
        await aggiornaMezzo(id, payload);

        closeModal('modal-edit');
        Swal.fire({
            icon: 'success',
            title: 'Dati aggiornati!',
            timer: 1500,
            showConfirmButton: false
        });

        await loadMezzi(); // Refresh UI

    } catch (error) {
        Swal.fire('Errore', error.message || 'Aggiornamento fallito', 'error');
    }
}

// LOGICA CAMBIO STATO
async function toggleStato(id, isDisponibile) {
    const nuovoStatoAtteso = !isDisponibile;
    const azione = nuovoStatoAtteso ? "rendere DISPONIBILE" : "spostare in MANUTENZIONE";
    const coloreBtn = nuovoStatoAtteso ? "#2ecc71" : "#f59e0b"; // Verde o Arancio

    const result = await Swal.fire({
        title: 'Cambio Stato',
        text: `Vuoi davvero ${azione} questo mezzo?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: coloreBtn,
        cancelButtonColor: '#aaa',
        confirmButtonText: 'Sì, procedi'
    });

    if (result.isConfirmed) {
        try {
            Swal.showLoading();
            await apiCall(`/swa/api/mezzi/${id}/disponibilita`, 'PATCH', null, true);

            const toast = Swal.mixin({
                toast: true, position: 'top-end', showConfirmButton: false, timer: 2000
            });
            toast.fire({ icon: 'success', title: 'Stato aggiornato' });

            await loadMezzi();
        } catch (error) {
            Swal.fire('Errore', 'Impossibile aggiornare lo stato.', 'error');
        }
    }
}

async function handleAddMezzo(e) {
    e.preventDefault();

    const payload = {
        nome: document.getElementById('m_nome').value,
        tipo: document.getElementById('m_tipo').value,
        targa: document.getElementById('m_targa').value,
        descrizione: document.getElementById('m_descrizione').value,
        disponibile: true
    };

    try {
        Swal.showLoading();
        await creaMezzo(payload); // api.js

        closeModal('modal-add');
        document.getElementById('formAddMezzo').reset();

        Swal.fire({
            icon: 'success',
            title: 'Mezzo creato!',
            timer: 1500,
            showConfirmButton: false
        });

        await loadMezzi();

    } catch (error) {
        Swal.fire('Errore', error.message || 'Creazione fallita', 'error');
    }
}

// LOGICA ELIMINAZIONE
async function handleDelete(id) {
    const result = await Swal.fire({
        title: 'Sei sicuro?',
        text: "Il mezzo verrà rimosso permanentemente dal database",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sì, elimina'
    });

    if (result.isConfirmed) {
        try {
            await eliminaMezzo(id); // api.js
            Swal.fire('Eliminato!', 'Mezzo rimosso con successo', 'success');
            await loadMezzi();
        } catch (error) {
            Swal.fire('Errore', 'Impossibile eliminare (potrebbe avere missioni collegate)', 'error');
        }
    }
}

//LOGICA STORICO
async function showHistory(id, nome) {
    document.getElementById('history-title').innerText = `Storico Mezzo: ${nome}`;
    const tbody = document.getElementById('history-body');
    tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;">Caricamento...</td></tr>';

    openModal('modal-history');

    try {
        const missioni = await getMissioniMezzo(id);

        if (!missioni || missioni.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; color:#888;">Nessuna missione trovata</td></tr>';
            return;
        }

        // ORDINAMENTO: Prima IN_CORSO, poi le più recenti
        missioni.sort((a, b) => {
            const aActive = (a.stato === 'IN_CORSO');
            const bActive = (b.stato === 'IN_CORSO');

            if (aActive && !bActive) return -1;
            if (!aActive && bActive) return 1;
            return new Date(b.inizioAt) - new Date(a.inizioAt);
        });

        tbody.innerHTML = '';
        missioni.forEach(m => {
            const formatD = (dateStr) => {
                if(!dateStr) return '<span style="color:#ccc">-</span>';
                const d = new Date(dateStr);
                return d.toLocaleDateString() + ' <small class="text-muted">' + d.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'}) + '</small>';
            };

            const inizio = formatD(m.inizioAt);
            const fine = m.stato === 'IN_CORSO' ? '<span class="text-success pulse">Attiva...</span>' : formatD(m.fineAt);
            const squadraNome = m.squadra ? (m.squadra.nome || `Squadra #${m.squadra.id}`) : 'N/D';
            const capoNome = m.caposquadra ? (m.caposquadra.nome || m.caposquadra.username || `Utente #${m.caposquadra.id}`) : 'N/D';

            const indirizzo = m.indirizzo || m.posizione || 'N/D';

            const tr = document.createElement('tr');
            if(m.stato === 'IN_CORSO') tr.classList.add('row-active');

            tr.innerHTML = `
                <td><span class="badge-status ${m.stato}">${m.stato}</span></td>
                <td>${inizio}</td>
                <td>${fine}</td>
                <td style="max-width: 200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;" title="${indirizzo}">
                    <i class="fas fa-map-marker-alt text-danger"></i> ${indirizzo}
                </td>
                <td><strong>${squadraNome}</strong></td>
                <td><i class="fas fa-user-shield"></i> ${capoNome}</td>
                <td><a href="/missioni/dettaglio/${m.id}" class="btn-link"><i class="fas fa-external-link-alt"></i></a></td>
            `;
            tbody.appendChild(tr);
        });

    } catch (error) {
        console.error("Errore storico:", error);
        tbody.innerHTML = '<tr><td colspan="7" class="text-danger">Errore recupero storico.</td></tr>';
    }
}

// Modali
function openModal(id) {
    const el = document.getElementById(id);
    if(el) el.style.display = 'flex';
}

function closeModal(id) {
    const el = document.getElementById(id);
    if(el) el.style.display = 'none';
}

// Chiudi cliccando fuori
window.onclick = function(e) {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.style.display = 'none';
    }
}
