document.addEventListener("DOMContentLoaded", async function () {
    const container = document.getElementById("missioniContainer");

    try {
        let missioni = [];
        // Try getting ID from template variable
        const operatoreId = (typeof INITIAL_OPERATORE_ID !== 'undefined' && INITIAL_OPERATORE_ID) ? INITIAL_OPERATORE_ID : null;

        if (operatoreId) {
            console.log("Caricamento missioni per ID:", operatoreId);
            missioni = await operatoInMissioni(operatoreId);
        } else {
            console.log("Caricamento missioni per utente corrente...");
            missioni = await myMissioni();
        }

        renderMissioni(missioni);

    } catch (error) {
        console.error("Errore caricamento missioni:", error);
        container.innerHTML = `
            <div class="error-msg" style="color: #d9534f; padding: 20px; text-align: center;">
                <i class="fas fa-exclamation-circle"></i>
                <p>Errore nel caricamento: ${error.message}</p>
                <button onclick="location.reload()" style="margin-top:10px; cursor:pointer; padding:5px 10px;">Riprova</button>
            </div>`;
    }

    function renderMissioni(lista) {
        if (!lista || lista.length === 0) {
            container.innerHTML = `
                <div class="empty-state" style="text-align: center; padding: 40px; color: #64748b;">
                    <i class="fas fa-clipboard-check" style="font-size: 48px; margin-bottom: 20px; opacity: 0.5;"></i>
                    <p>Nessuna missione assegnata.</p>
                </div>`;
            return;
        }

        // Sort by date desc
        lista.sort((a, b) => {
            const dateA = new Date(a.inizio_at || 0); // use raw or parse if needed, but sort is best effort
            const dateB = new Date(b.inizio_at || 0);
            return dateB - dateA;
        });

        container.innerHTML = lista.map(m => {
            const dataInizio = formatDate(m.inizio_at);
            const statoClass = m.stato === 'IN_CORSO' ? 'status-in-corso' : 'status-chiusa';
            const statoLabel = m.stato === 'IN_CORSO' ? 'In Corso' : 'Conclusa';
            const indirizzo = m.richiesta ? m.richiesta.indirizzo : 'Indirizzo non disponibile';
            const descrizione = m.richiesta ? m.richiesta.descrizione : 'Nessuna descrizione';

            return `
            <div class="mission-card status-${m.stato.toLowerCase()}">
                <div class="mission-header">
                    <span class="status-pill status-${m.stato.toLowerCase()}">${statoLabel}</span>
                    <span class="mission-id">#${m.id}</span>
                </div>
                
                <div class="mission-address">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>${indirizzo}</span>
                </div>
                
                <div class="mission-desc">
                    ${descrizione}
                </div>

                <div class="mission-meta">
                    <div class="meta-item">
                        <i class="far fa-calendar"></i> 
                        <span>${dataInizio}</span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-users"></i> 
                        <span>${m.operatori ? m.operatori.length : 0} operatori</span>
                    </div>
                </div>

                <div class="mission-actions">
                    <button onclick="uploadFoto(${m.id})" class="btn-mission primary">
                        <i class="fas fa-camera"></i> Carica Foto / Report
                    </button>
                </div>
            </div>
        `}).join('');
    }
});

function uploadFoto(id) {
    // Placeholder function for future implementation
    Swal.fire({
        title: 'Coming Soon',
        text: 'Funzionalità di upload foto in arrivo.',
        icon: 'info'
    });
}