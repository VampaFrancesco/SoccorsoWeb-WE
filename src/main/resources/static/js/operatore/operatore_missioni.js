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
            <div class="menu-card mission-item" style="height: auto; flex-direction: column; align-items: flex-start; padding: 20px; cursor: default; margin-bottom: 15px;">
                <div style="display: flex; justify-content: space-between; width: 100%; align-items: center; margin-bottom: 10px;">
                    <span class="status-pill status-${m.stato}" style="font-size: 0.8rem;">${statoLabel}</span>
                    <span style="font-size: 0.8rem; font-weight: 700; color: #94a3b8;">#${m.id}</span>
                </div>
                
                <h3 style="margin: 0 0 5px 0; font-size: 1.1rem; color: #e2e8f0;">
                    <i class="fas fa-map-marker-alt" style="color: #ef4444; margin-right: 8px;"></i>${indirizzo}
                </h3>
                
                <p style="font-size: 0.9rem; color: #94a3b8; margin-bottom: 15px; line-height: 1.5;">
                    ${descrizione}
                </p>

                <div style="display: flex; gap: 15px; margin-bottom: 15px; font-size: 0.85rem; color: #cbd5e1;">
                    <span><i class="far fa-calendar"></i> ${dataInizio}</span>
                    <span><i class="fas fa-users"></i> ${m.operatori ? m.operatori.length : 0} operatori</span>
                </div>

                <div style="width: 100%; border-top: 1px solid #334155; padding-top: 15px;">
                    <button onclick="uploadFoto(${m.id})" class="btn-primary" style="width: 100%; justify-content: center;">
                        <i class="fas fa-camera"></i> Carica Foto / Report
                    </button>
                    <!-- Future implementation: Dettagli button -->
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