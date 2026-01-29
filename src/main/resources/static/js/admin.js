document.addEventListener('DOMContentLoaded', () => {

    // ===== 1. USER INFO FALLBACK (Opzionale) =====
    // Se Freemarker non ha caricato il nome (es. backend stateless), prova dal LocalStorage
    const nameDisplay = document.getElementById('user-name-display');
    const storedToken = localStorage.getItem('jwt_token'); // o authToken

    // Se c'è un token ma il nome visualizzato è quello di default ("Amministratore")
    if (storedToken && nameDisplay && nameDisplay.textContent.trim() === 'Amministratore') {
        // Esempio: se hai salvato anche il nome nel localStorage
        const storedName = localStorage.getItem('user_name');
        if (storedName) {
            nameDisplay.textContent = storedName;
        }
    }

    // ===== 2. POLLING TICKER RICHIESTE =====
    const POLLING_INTERVAL = 10000; // 10 secondi
    const tickerContent = document.getElementById('ticker-content');
    const reqBadge = document.getElementById('req-count');

    async function updateTicker() {
        try {
            // Sostituisci con la chiamata reale quando il backend è pronto:
            // const response = await visualizzaRichiesteFiltrate('APERTA', 0, 5);

            // --- INIZIO SIMULAZIONE DATI ---
            const mockData = [
                { id: 204, descrizione: "Richiesta Soccorso Alpino", data: new Date().toLocaleTimeString().slice(0,5) },
                { id: 205, descrizione: "Incidente A24 km 30", data: new Date().toLocaleTimeString().slice(0,5) }
            ];
            const response = mockData; // Usa 'response = []' per testare nessun dato
            // --- FINE SIMULAZIONE ---

            if (response && response.length > 0) {
                let html = '';
                response.forEach(req => {
                    html += `
                        <span>
                            <span class="ticker-new">NUOVA [${req.data}]</span> 
                            #${req.id}: ${req.descrizione}
                        </span>
                    `;
                });

                tickerContent.innerHTML = html;

                // Aggiorna badge notifiche
                if(reqBadge) {
                    reqBadge.textContent = response.length;
                    reqBadge.style.opacity = '1';
                }
            } else {
                tickerContent.innerHTML = '<span class="placeholder-text"><i class="fas fa-check-circle"></i> Nessuna nuova richiesta da gestire.</span>';
                if(reqBadge) reqBadge.style.opacity = '0';
            }

        } catch (error) {
            console.error('Errore aggiornamento ticker:', error);
            // Non mostrare errore all'utente, lascia l'ultimo stato valido o placeholder
        }
    }

    // Avvio immediato e poi ciclico
    updateTicker();
    setInterval(updateTicker, POLLING_INTERVAL);
});
