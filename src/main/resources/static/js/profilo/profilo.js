document.addEventListener('DOMContentLoaded', async function () {
    console.log("Profilo JS inizializzato");

    // Carica dati
    await loadUserProfile();

    // Listener salvataggio
    const form = document.getElementById('profileForm');
    if (form) {
        form.addEventListener('submit', handleProfileUpdate);
    }
});

/**
 * Carica i dati dell'utente loggato
 */
async function loadUserProfile() {
    try {
        // Usa la funzione che abbiamo aggiunto in api.js
        const user = await getMyProfile();

        if (!user) {
            throw new Error("Nessun dato utente ricevuto");
        }

        console.log("Utente caricato:", user);

        // --- Aggiorna UI (Visualizzazione) ---
        setText('display-fullname', `${user.nome} ${user.cognome}`);
        setText('display-email', user.email);
        setText('display-phone', user.telefono || "N/D");

        // --- Aggiorna UI (Campi Form) ---
        setValue('nome', user.nome);
        setValue('cognome', user.cognome);
        setValue('indirizzo', user.indirizzo || "");
        setValue('telefono', user.telefono || "");

        // Gestione Data: spesso arriva come 2023-10-05T00:00:00. Prendiamo solo la prima parte
        if (user.dataNascita) {
            setValue('data_nascita', user.dataNascita.split('T')[0]);
        }

        if (user.abilita && Array.isArray(user.abilita)) {
            const abilitaNames = user.abilita.map(a => a.nome).join(', ');
            setValue('abilita', abilitaNames);
        }

    } catch (error) {
        console.error("Errore loadUserProfile:", error);
        Swal.fire({
            icon: 'error',
            title: 'Errore',
            text: 'Impossibile caricare i dati del profilo.'
        });
    }
}

/**
 * Gestisce il salvataggio
 */
async function handleProfileUpdate(event) {
    event.preventDefault();

    // Oggetto con i campi da inviare (solo quelli modificabili)
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

        // Chiama la nuova funzione in api.js
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

// Utility
function setText(id, text) {
    const el = document.getElementById(id);
    if (el) el.innerText = text;
}

function setValue(id, value) {
    const el = document.getElementById(id);
    if (el) el.value = value;
}
