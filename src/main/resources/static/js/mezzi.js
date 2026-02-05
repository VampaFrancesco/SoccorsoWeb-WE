document.addEventListener('DOMContentLoaded', async function() {
    console.log("Gestione Mezzi Init...");

    // Carica lista iniziale
    await loadMezzi();

    // aggiunta mezzo
    const form = document.getElementById('formAddMezzo');
    if (form) {
        form.addEventListener('submit', handleAddMezzo);
    }
});

// Caricamento Mezzi
async function loadMezzi() {
    try {
        const mezzi = await getTuttiMezzi(); // da api.js

        const containerAvail = document.getElementById('list-available');
        const containerUnavail = document.getElementById('list-unavailable');

        // Reset
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
        Swal.fire('Errore', 'Impossibile recuperare la flotta.', 'error');
    }
}

function createCardHTML(mezzo) {
    const div = document.createElement('div');
    // Classe CSS dinamica in base alla disponibilità
    div.className = `vehicle-card ${mezzo.disponibile ? 'available' : 'unavailable'}`;

    // Tooltip dinamico
    const swapTitle = mezzo.disponibile ? "Sposta in Manutenzione" : "Rendi Disponibile";

    div.innerHTML = `
        <div class="vehicle-info">
            <h4>${mezzo.nome} <span class="targa-badge">${mezzo.targa || 'N/D'}</span></h4>
            <p>${mezzo.tipo} &bull; ${mezzo.descrizione || 'Nessuna nota'}</p>
        </div>
        <div class="vehicle-actions">
            <!-- PULSANTE SWAP AGGIUNTO QUI -->
            <button class="btn-action swap" onclick="toggleStato(${mezzo.id}, ${mezzo.disponibile})" title="${swapTitle}">
                <i class="fas fa-exchange-alt"></i>
            </button>
            <button class="btn-action details" onclick="showHistory(${mezzo.id}, '${mezzo.nome}')" title="Storico Missioni">
                <i class="fas fa-list-ul"></i>
            </button>
            <button class="btn-action delete" onclick="handleDelete(${mezzo.id})" title="Elimina Mezzo">
                <i class="fas fa-trash-alt"></i>
            </button>
        </div>
    `;
    return div;
}

// CAMBIO STATO
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

            // Feedback
            const toast = Swal.mixin({
                toast: true, position: 'top-end', showConfirmButton: false, timer: 2000
            });
            toast.fire({ icon: 'success', title: 'Stato aggiornato' });

            await loadMezzi(); // Ricarica la griglia per vedere il cambiamento

        } catch (error) {
            console.error(error);
            Swal.fire('Errore', 'Impossibile aggiornare lo stato.', 'error');
        }
    }
}


// Aggiungi Mezzo
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

        await loadMezzi(); // Refresh lista

    } catch (error) {
        Swal.fire('Errore', error.message || 'Creazione fallita', 'error');
    }
}

// Elimina Mezzo
async function handleDelete(id) {
    const result = await Swal.fire({
        title: 'Sei sicuro?',
        text: "Il mezzo verrà rimosso permanentemente dal database.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sì, elimina'
    });

    if (result.isConfirmed) {
        try {
            await eliminaMezzo(id); // api.js
            Swal.fire('Eliminato!', 'Mezzo rimosso con successo.', 'success');
            await loadMezzi();
        } catch (error) {
            Swal.fire('Errore', 'Impossibile eliminare (potrebbe avere missioni collegate).', 'error');
        }
    }
}

// Storico
async function showHistory(id, nome) {
    document.getElementById('history-title').innerText = `Storico: ${nome}`;
    const tbody = document.getElementById('history-body');
    tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;">Caricamento...</td></tr>';

    openModal('modal-history');

    try {
        const missioni = await getMissioniMezzo(id);

        tbody.innerHTML = '';
        if (!missioni || missioni.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; color:#888;">Nessuna missione trovata</td></tr>';
            return;
        }

        missioni.forEach(m => {
            // Formattazione data
            let dataStr = 'N/D';
            if (m.inizioAt) {
                const d = new Date(m.inizioAt);
                dataStr = d.toLocaleDateString() + ' ' + d.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
            }

            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>#${m.id}</td>
                <td>${dataStr}</td>
                <td><span class="badge-status ${m.stato}">${m.stato}</span></td>
                <td><a href="/missioni/dettaglio/${m.id}" class="btn-link">Vai <i class="fas fa-external-link-alt"></i></a></td>
            `;
            tbody.appendChild(tr);
        });

    } catch (error) {
        tbody.innerHTML = '<tr><td colspan="4" class="text-danger">Errore recupero storico.</td></tr>';
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

// Chiude
window.onclick = function(e) {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.style.display = 'none';
    }
}
