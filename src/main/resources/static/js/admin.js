document.addEventListener('DOMContentLoaded', () => {

    // data corrente
    const dateElement = document.getElementById('current-date');
    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    dateElement.textContent = new Date().toLocaleDateString('it-IT', options);

    // aggiornamento Richieste
    const feedContainer = document.getElementById('requests-feed');
    const sidebarBadge = document.getElementById('sidebar-badge');

    async function fetchDashboardData() {
        try {
            const response = await visualizzaRichiesteFiltrate('APERTA', 0, 5);
            const data = Array.isArray(response) ? response : (response.content || []);

            if (!data || data.length === 0) {
                renderRequests([]);
                updateBadges(0);
                return;
            }

            const formattedData = data.map(req => {
                let timeStr = "--:--";
                if (req.data_ora) {
                    const dateObj = new Date(req.data_ora);
                    timeStr = dateObj.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                }

                // Gestisci la località
                let location = "Posizione sconosciuta";
                if (req.latitudine && req.longitudine) {
                    location = `${req.latitudine.toFixed(4)}, ${req.longitudine.toFixed(4)}`;
                }

                return {
                    id: req.id,
                    time: timeStr,
                    desc: req.descrizione || "Nessuna descrizione",
                    loc: location
                };
            });

            renderRequests(formattedData);
            updateBadges(formattedData.length);

        } catch (e) {
            console.error("Errore fetch dashboard", e);
            feedContainer.innerHTML = '<div style="text-align:center; padding:20px; color:#ef4444"><i class="fas fa-exclamation-triangle"></i> Errore caricamento dati</div>';
        }
    }


    function renderRequests(data) {
        if (!data || data.length === 0) {
            feedContainer.innerHTML = '<div style="color:#9495a0; text-align:center; padding:20px;">Nessuna nuova richiesta</div>';
            return;
        }

        const html = data.map(req => `
            <div class="req-row status-new">
                <span class="req-time">${req.time}</span>
                <div class="req-info">
                    <span class="req-desc">${req.desc}</span>
                    <span class="req-loc"><i class="fas fa-map-pin"></i> ${req.loc}</span>
                </div>
                <div class="req-action"><i class="fas fa-chevron-right"></i></div>
            </div>
        `).join('');

        feedContainer.innerHTML = html;
    }

    function updateBadges(count) {
        if(sidebarBadge) {
            sidebarBadge.textContent = count;
            sidebarBadge.style.display = count > 0 ? 'inline-block' : 'none';
        }
    }

    // Avvia
    fetchDashboardData();
});
