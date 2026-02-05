document.addEventListener("DOMContentLoaded", function () {
    const container = document.getElementById("missioniContainer");

    // 1. Funzione per leggere un cookie per nome
    function getCookie(name) {
        const value = `; ${document.cookie}`;
        const parts = value.split(`; ${name}=`);
        if (parts.length === 2) return parts.pop().split(';').shift();
        return null;
    }

    // 2. Funzione per salvare un cookie
    function setCookie(name, value) {
        document.cookie = `${name}=${value}; path=/; max-age=86400; SameSite=Lax`;
    }

    async function inizializzaMissioni() {
        const container = document.getElementById("missioniContainer");

        try {
            // 1. Prova a prendere l'ID dalla variabile scritta da Freemarker nel template
            let operatoreId = typeof INITIAL_OPERATORE_ID !== 'undefined' ? INITIAL_OPERATORE_ID : null;

            // 2. Se non c'è nel template, prova a cercarlo nei cookie del browser
            if (!operatoreId || operatoreId === "") {
                operatoreId = getCookie('operatore_id');
            }

            // 3. Se manca ancora, interroga l'API di autenticazione
            if (!operatoreId || operatoreId === "") {
                console.log("ID non trovato, recupero tramite API di sessione...");
                const resAuth = await fetch('/api/auth/me');
                if (!resAuth.ok) throw new Error("Utente non autenticato");
                const dataAuth = await resAuth.json();
                operatoreId = dataAuth.id;

                // Salva nei cookie per velocizzare il prossimo caricamento
                setCookie('operatore_id', operatoreId);
            }

            // 4. Carichiamo le missioni effettive usando l'ID ottenuto
            console.log("Caricamento missioni per Operatore ID:", operatoreId);
            const resMissioni = await fetch(`/api/operatore/missioni?id=${operatoreId}`);

            if (!resMissioni.ok) {
                throw new Error("Impossibile recuperare le missioni dal server");
            }

            const missioni = await resMissioni.json();

            // 5. Passa i dati alla funzione che genera l'HTML
            renderMissioni(missioni);

        } catch (error) {
            console.error("Errore inizializzazione:", error);
            if (container) {
                container.innerHTML = `
                <div class="error-msg" style="color: #d9534f; padding: 20px; text-align: center;">
                    <i class="fas fa-exclamation-circle"></i>
                    <p>Errore nel caricamento: ${error.message}</p>
                    <button onclick="location.reload()" style="margin-top:10px;">Riprova</button>
                </div>`;
            }
        }
    }

// Chiamata automatica al caricamento del DOM
    document.addEventListener("DOMContentLoaded", inizializzaMissioni);

    function renderMissioni(lista) {
        if (!lista || lista.length === 0) {
            container.innerHTML = '<div class="empty-state"><i class="fas fa-clipboard-check"></i><p>Nessuna missione attiva.</p></div>';
            return;
        }

        container.innerHTML = lista.map(m => `
            <div class="menu-card mission-item" style="height: auto; flex-direction: column; align-items: flex-start; padding: 20px; cursor: default;">
                <div style="display: flex; justify-content: space-between; width: 100%; align-items: center;">
                    <span class="badge ${m.codiceColore}">${m.codiceColore}</span>
                    <span style="font-size: 0.8rem; font-weight: 700;">#${m.id}</span>
                </div>
                <h3 style="margin: 15px 0 5px 0; font-size: 1.2rem;">${m.indirizzo || 'Indirizzo non specificato'}</h3>
                <p style="font-size: 0.9rem; opacity: 0.8; margin-bottom: 15px;">${m.descrizione || 'Nessun dettaglio aggiuntivo'}</p>
                <div style="width: 100%; border-top: 1px solid #eee; padding-top: 15px; display: flex; gap: 10px;">
                    <button onclick="gestisciMissione(${m.id})" class="btn-logout" style="background: var(--accent); margin:0; flex:1;">
                        DETTAGLI
                    </button>
                </div>
            </div>
        `).join('');
    }

    inizializzaMissioni();
});