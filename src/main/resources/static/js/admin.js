document.addEventListener('DOMContentLoaded', () => {

    // Configurazione Polling
    const POLLING_INTERVAL = 10000; // Controlla ogni 10 secondi
    const tickerContent = document.getElementById('ticker-content');
    const reqBadge = document.getElementById('req-count');

    // Funzione per aggiornare il Ticker
    async function updateTicker() {
        try {
            // chiamata API, es: visualizzaRichiesteFiltrate('APERTA', 0, 5)
            // const response = await visualizzaRichiesteFiltrate('APERTA', 0, 5);

            // SIMULAZIONE DATI (la chiamata sopra quando pronta)
            const mockData = [
                { id: 101, descrizione: "Incidente stradale Via Roma", data: "10:45" },
                { id: 102, descrizione: "Malore in piazza", data: "10:50" }
            ];
            const response = mockData; // Fine simulazione

            if (response && response.length > 0) {
                let html = '';
                response.forEach(req => {
                    html += `
                        <span>
                            <span class="ticker-new">NUOVA [${req.data}]</span> 
                            Richiesta #${req.id}: ${req.descrizione}
                        </span>
                    `;
                });

                // Aggiorna il testo scorrevole
                tickerContent.innerHTML = html;

                // Aggiorna il badge notifiche sulla card
                if(reqBadge) {
                    reqBadge.textContent = response.length;
                    reqBadge.style.opacity = '1'; // Rendilo visibile se ci sono richieste
                }
            } else {
                tickerContent.innerHTML = '<span>Nessuna nuova richiesta al momento.</span>';
                if(reqBadge) reqBadge.style.opacity = '0';
            }

        } catch (error) {
            console.error('Errore aggiornamento ticker:', error);
            tickerContent.innerHTML = '<span style="color:#ff6b6b">Errore connessione server...</span>';
        }
    }

    // Avvia il polling
    updateTicker(); // Prima chiamata immediata
    setInterval(updateTicker, POLLING_INTERVAL); // Ripeti
});
