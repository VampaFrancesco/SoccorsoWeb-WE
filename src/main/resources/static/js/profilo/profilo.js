document.addEventListener('DOMContentLoaded', async function () {
    console.log("Profilo JS inizializzato");

    // Carica dati
    await loadUserProfile();
    const form = document.getElementById('profileForm');
    if (form) {
        form.addEventListener('submit', handleProfileUpdate);
    }
});

// Variabili globali per la gestione delle abilità
let tutteAbilita = [];
let abilitaSelezionate = [];

// Dati utente
async function loadUserProfile() {
    try {
        const user = await getMyProfile();

        if (!user) {
            throw new Error("Nessun dato utente ricevuto");
        }

        console.log("Utente caricato:", user);

        // --- Aggiorna UI ---
        setText('display-fullname', `${user.nome} ${user.cognome}`);
        setText('display-email', user.email);
        setText('display-phone', user.telefono || "N/D");

        // --- Aggiorna UI ---
        setValue('nome', user.nome);
        setValue('cognome', user.cognome);
        setValue('indirizzo', user.indirizzo || "");
        setValue('telefono', user.telefono || "");

        // Gestione Data
        if (user.dataNascita) {
            setValue('data_nascita', user.dataNascita.split('T')[0]);
        }

        // Gestione Abilità
        if (user.abilita && Array.isArray(user.abilita)) {
            abilitaSelezionate = user.abilita.map(a => ({
                id: a.id,
                nome: a.nome,
                descrizione: a.descrizione || ''
            }));
            aggiornaTagsAbilita();
            aggiornaInputNascosto();
        }

    } catch (error) {
        console.error("Errore loadUserProfile:", error);
        Swal.fire({
            icon: 'error',
            title: 'Errore',
            text: 'Impossibile caricare i dati del profilo'
        });
    }
}

// Tag abilità
function aggiornaTagsAbilita() {
    const container = document.getElementById('abilita-tags');
    if (!container) return;

    if (abilitaSelezionate.length === 0) {
        container.innerHTML = '<span class="text-muted">Nessuna abilità selezionata</span>';
        return;
    }

    container.innerHTML = abilitaSelezionate.map(ab => `
        <span class="abilita-tag">
            <i class="fas fa-check-circle"></i>
            ${escapeHtml(ab.nome)}
        </span>
    `).join('');
}

function aggiornaInputNascosto() {
    const input = document.getElementById('abilita');
    if (input) {
        input.value = abilitaSelezionate.map(a => a.nome).join(', ');
    }
}

async function apriModaleAbilita() {
    const modal = document.getElementById('modal-abilita');
    if (!modal) return;

    modal.classList.add('active');

    // Carica tutte le abilità disponibili
    try {
        tutteAbilita = await getTutteAbilita() || [];
        renderAbilitaDisponibili();
        renderAbilitaSelezionate();
    } catch (error) {
        console.error("Errore caricamento abilità:", error);
        document.getElementById('abilita-disponibili').innerHTML =
            '<p class="text-error">Errore nel caricamento delle abilità</p>';
    }
}

// Chiusura modale delle abilità
function chiudiModaleAbilita() {
    const modal = document.getElementById('modal-abilita');
    if (modal) {
        modal.classList.remove('active');
    }
}

function renderAbilitaDisponibili() {
    const container = document.getElementById('abilita-disponibili');
    if (!container) return;

    const searchTerm = (document.getElementById('search-abilita')?.value || '').toLowerCase();

    // Filtra le abilità non già selezionate
    const disponibili = tutteAbilita.filter(ab => {
        const giaSelezionata = abilitaSelezionate.some(sel => sel.id === ab.id);
        const matchesSearch = ab.nome.toLowerCase().includes(searchTerm);
        return !giaSelezionata && matchesSearch;
    });

    if (disponibili.length === 0) {
        container.innerHTML = '<p class="text-muted">Nessuna abilità disponibile</p>';
        return;
    }

    container.innerHTML = disponibili.map(ab => `
        <div class="abilita-item" onclick="aggiungiAbilita(${ab.id})">
            <span class="abilita-nome">${escapeHtml(ab.nome)}</span>
            ${ab.descrizione ? `<span class="abilita-desc">${escapeHtml(ab.descrizione)}</span>` : ''}
            <i class="fas fa-plus-circle abilita-add-icon"></i>
        </div>
    `).join('');
}

function renderAbilitaSelezionate() {
    const container = document.getElementById('abilita-selezionate');
    if (!container) return;

    if (abilitaSelezionate.length === 0) {
        container.innerHTML = '<p class="text-muted">Nessuna abilità selezionata</p>';
        return;
    }

    container.innerHTML = abilitaSelezionate.map(ab => `
        <span class="abilita-chip">
            ${escapeHtml(ab.nome)}
            <i class="fas fa-times chip-remove" onclick="rimuoviAbilita(${ab.id})"></i>
        </span>
    `).join('');
}

function aggiungiAbilita(id) {
    const abilita = tutteAbilita.find(ab => ab.id === id);
    if (abilita && !abilitaSelezionate.some(s => s.id === id)) {
        abilitaSelezionate.push(abilita);
        renderAbilitaDisponibili();
        renderAbilitaSelezionate();
    }
}

function rimuoviAbilita(id) {
    abilitaSelezionate = abilitaSelezionate.filter(ab => ab.id !== id);
    renderAbilitaDisponibili();
    renderAbilitaSelezionate();
}

function filtraAbilita() {
    renderAbilitaDisponibili();
}

// Creazione abil.
async function creaNuovaAbilita() {
    const nomeInput = document.getElementById('nuova-abilita-nome');
    const descInput = document.getElementById('nuova-abilita-desc');

    const nome = nomeInput?.value?.trim();
    const descrizione = descInput?.value?.trim() || '';

    if (!nome) {
        Swal.fire({
            icon: 'warning',
            title: 'Attenzione',
            text: 'Inserisci un nome per l\'abilità'
        });
        return;
    }

    // Controlla se esiste già
    if (tutteAbilita.some(ab => ab.nome.toLowerCase() === nome.toLowerCase())) {
        Swal.fire({
            icon: 'warning',
            title: 'Attenzione',
            text: 'Questa abilità esiste già'
        });
        return;
    }

    try {
        const nuovaAbilita = await creaAbilita(nome, descrizione);

        if (nuovaAbilita) {
            tutteAbilita.push(nuovaAbilita);
            abilitaSelezionate.push(nuovaAbilita);

            // Pulisce i campi
            nomeInput.value = '';
            descInput.value = '';

            renderAbilitaDisponibili();
            renderAbilitaSelezionate();

            Swal.fire({
                icon: 'success',
                title: 'Abilità creata!',
                text: `"${nome}" è stata aggiunta`,
                timer: 1500,
                showConfirmButton: false
            });
        }
    } catch (error) {
        console.error("Errore creazione abilità:", error);
        Swal.fire({
            icon: 'error',
            title: 'Errore',
            text: error.message || 'Impossibile creare l\'abilità'
        });
    }
}

function salvaAbilitaSelezionate() {
    aggiornaTagsAbilita();
    aggiornaInputNascosto();
    chiudiModaleAbilita();

    Swal.fire({
        icon: 'success',
        title: 'Abilità aggiornate',
        text: 'Ricorda di salvare il profilo',
        timer: 1500,
        showConfirmButton: false
    });
}

async function handleProfileUpdate(event) {
    event.preventDefault();

    const updatePayload = {
        indirizzo: document.getElementById('indirizzo').value,
        telefono: document.getElementById('telefono').value,
        abilita: document.getElementById('abilita').value
    };

    try {
        Swal.fire({
            title: 'Salvataggio...',
            didOpen: () => Swal.showLoading()
        });

        await updateMyProfile(updatePayload);

        Swal.fire({
            icon: 'success',
            title: 'Salvato!',
            text: 'Profilo aggiornato con successo',
            timer: 1500,
            showConfirmButton: false
        });

    } catch (error) {
        console.error("Errore salvataggio:", error);
        Swal.fire({
            icon: 'error',
            title: 'Errore',
            text: error.message || 'Errore durante il salvataggio'
        });
    }
}

function setText(id, text) {
    const el = document.getElementById(id);
    if (el) el.innerText = text;
}

function setValue(id, value) {
    const el = document.getElementById(id);
    if (el) el.value = value;
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = String(text);
    return div.innerHTML;
}
