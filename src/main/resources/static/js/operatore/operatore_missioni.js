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
            const dateA = new Date(Array.isArray(a.inizio_at) ? new Date(a.inizio_at[0], a.inizio_at[1] - 1, a.inizio_at[2]) : a.inizio_at || 0);
            const dateB = new Date(Array.isArray(b.inizio_at) ? new Date(b.inizio_at[0], b.inizio_at[1] - 1, b.inizio_at[2]) : b.inizio_at || 0);
            return dateB - dateA;
        });

        container.innerHTML = lista.map(m => {
            const dataInizio = formatDate(m.inizio_at);
            const statoLabel = m.stato === 'IN_CORSO' ? 'In Corso' : (m.stato === 'CHIUSA' ? 'Conclusa' : m.stato);
            const indirizzo = m.posizione || (m.richiesta ? m.richiesta.indirizzo : 'Indirizzo non disponibile');
            const descrizioneSegnalazione = m.richiesta ? m.richiesta.descrizione : 'Nessuna descrizione';
            const obiettivo = m.obiettivo || 'Nessun obiettivo specificato';

            // Mezzi e Materiali
            const mezziHtml = m.mezzi && m.mezzi.length > 0
                ? m.mezzi.map(mez => `<span class="badge-item"><i class="fas fa-truck-medical"></i> ${mez.nome} (${mez.targa})</span>`).join('')
                : '<span class="text-muted">Nessun mezzo</span>';

            const materialiHtml = m.materiali && m.materiali.length > 0
                ? m.materiali.map(mat => `<span class="badge-item"><i class="fas fa-kit-medical"></i> ${mat.nome} (x${mat.quantita})</span>`).join('')
                : '<span class="text-muted">Nessun materiale</span>';

            // Aggiornamenti
            const aggiornamentiHtml = m.aggiornamenti && m.aggiornamenti.length > 0
                ? m.aggiornamenti.sort((a, b) => new Date(b.created_at) - new Date(a.created_at)).map(agg => `
                    <div class="update-item">
                        <small class="update-time">${formatDate(agg.created_at)}</small>
                        <p class="update-text">${agg.descrizione}</p>
                    </div>
                `).join('')
                : '<p class="text-muted">Nessun aggiornamento registrato</p>';

            return `
            <div class="mission-card status-${m.stato.toLowerCase()}">
                <div class="mission-header">
                    <span class="status-pill status-${m.stato.toLowerCase()}">${statoLabel}</span>
                    <span class="mission-id">#${m.id}</span>
                </div>
                
                <div class="mission-main-info">
                    <h3 class="mission-goal">${obiettivo}</h3>
                    <div class="mission-address">
                        <i class="fas fa-map-marker-alt"></i>
                        <span>${indirizzo}</span>
                    </div>
                </div>

                <div class="mission-details-toggle" onclick="this.parentElement.classList.toggle('expanded')">
                    <span>Vedi Dettagli</span>
                    <i class="fas fa-chevron-down"></i>
                </div>

                <div class="mission-expanded-content">
                    <div class="detail-section">
                        <h4><i class="fas fa-info-circle"></i> Descrizione Segnalazione</h4>
                        <p>${descrizioneSegnalazione}</p>
                    </div>

                    <div class="detail-section">
                        <h4><i class="fas fa-tools"></i> Risorse Assegnate</h4>
                        <div class="resources-grid">
                            <div class="resource-group">
                                <h5>Mezzi</h5>
                                <div class="badge-container">${mezziHtml}</div>
                            </div>
                            <div class="resource-group">
                                <h5>Materiali</h5>
                                <div class="badge-container">${materialiHtml}</div>
                            </div>
                        </div>
                    </div>

                    <div class="detail-section">
                        <h4><i class="fas fa-history"></i> Diario Missione</h4>
                        <div class="updates-timeline">
                            ${aggiornamentiHtml}
                        </div>
                    </div>

                    ${m.stato === 'CHIUSA' ? `
                    <div class="detail-section mission-outcome">
                        <h4><i class="fas fa-trophy"></i> Esito Missione</h4>
                        <div class="outcome-details">
                            <div class="outcome-item">
                                <strong>Livello Successo:</strong>
                                <span class="success-stars">${'★'.repeat(m.livello_successo || 0)}${'☆'.repeat(5 - (m.livello_successo || 0))}</span>
                                <small>(${m.livello_successo || 0}/5)</small>
                            </div>
                            ${m.commenti_finali ? `
                            <div class="outcome-item">
                                <strong>Commenti Finali:</strong>
                                <p class="final-comments">${m.commenti_finali}</p>
                            </div>
                            ` : ''}
                        </div>
                    </div>
                    ` : ''}
                </div>

                <div class="mission-meta">
                    <div class="meta-item">
                        <i class="far fa-calendar"></i> 
                        <span>${dataInizio}</span>
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-users"></i> 
                        <span>${m.operatori ? m.operatori.length : 0} membri team</span>
                    </div>
                </div>


            </div>
        `}).join('');
    }
});
