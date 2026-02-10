// ========================================
// GESTIONE MISSIONI
// ========================================

let currentMissionId = null;
let currentFilter = 'IN_CORSO';

// Inizializzazione
document.addEventListener('DOMContentLoaded', function () {
    initFilterButtons();
    loadMissioni('IN_CORSO');
    initForms();
});

// ========================================
// FILTRI
// ========================================

function initFilterButtons() {
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            const stato = this.dataset.stato;

            // Aggiorna UI
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            // Carica missioni
            loadMissioni(stato);
        });
    });
}

// ========================================
// CARICAMENTO MISSIONI
// ========================================

async function loadMissioni(stato) {
    currentFilter = stato;
    const tbody = document.getElementById('missioni-body');
    const noData = document.getElementById('no-data');

    // Loading
    tbody.innerHTML = `
        <tr class="loading-row">
            <td colspan="8">
                <i class="fas fa-spinner fa-spin"></i> Caricamento missioni...
            </td>
        </tr>
    `;
    noData.style.display = 'none';

    try {
        const missioni = await visualizzaTutteLeMissioni();

        if (!missioni || missioni.length === 0) {
            tbody.innerHTML = '';
            noData.style.display = 'flex';
            return;
        }

        // Filtra
        let filtered = missioni;
        if (stato !== 'ALL') {
            filtered = missioni.filter(m => m.stato === stato);
        }

        if (filtered.length === 0) {
            tbody.innerHTML = '';
            noData.style.display = 'flex';
            return;
        }

        // Ordina per data (inizio_at)
        filtered.sort((a, b) => new Date(b.inizio_at) - new Date(a.inizio_at));

        // Genera righe
        tbody.innerHTML = filtered.map(m => generateRow(m)).join('');

    } catch (error) {
        console.error('Errore caricamento missioni:', error);
        tbody.innerHTML = `
            <tr>
                <td colspan="8" style="color: #ef4444; text-align: center; padding: 40px;">
                    <i class="fas fa-exclamation-triangle"></i> 
                    Errore nel caricamento
                </td>
            </tr>
        `;
    }
}

function generateRow(missione) {
    const dataInizio = missione.inizio_at ? new Date(missione.inizio_at).toLocaleString('it-IT', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    }) : 'N/D';

    const caposquadra = missione.caposquadra;
    const altriOp = (missione.operatori?.length || 0);
    const numMezzi = missione.mezzi?.length || 0;
    const isInCorso = missione.stato === 'IN_CORSO';

    return `
        <tr>
            <td><strong>#${missione.id}</strong></td>
            <td><strong>#${missione.richiesta_id || 'N/D'}</strong></td>
            <td>${caposquadra ? `${caposquadra.nome} ${caposquadra.cognome}` : 'N/D'}</td>
            <td>
                ${altriOp > 0
            ? `<span class="team-badge">${altriOp} operatori</span>`
            : '<span style="color: #94a3b8;">Nessuno</span>'}
            </td>
            <td>
                ${numMezzi > 0
            ? missione.mezzi.map(m => `<span class="mezzo-badge">${m.targa || m.nome}</span>`).join('')
            : '<span style="color: #94a3b8;">Nessuno</span>'}
            </td>
            <td>${dataInizio}</td>
            <td>
                <span class="status-pill status-${missione.stato}">
                    ${missione.stato === 'IN_CORSO' ? 'In Corso' : 'Conclusa'}
                </span>
            </td>
            <td>
                <div class="action-group">
                    <button class="btn-view" onclick="viewDettaglio(${missione.id})">
                        <i class="fas fa-eye"></i> Dettagli
                    </button>
                    <button class="btn-update" onclick="openAggiorna(${missione.id})" ${!isInCorso ? 'disabled' : ''}>
                        <i class="fas fa-edit"></i> Aggiorna
                    </button>
                    <button class="btn-close-mission" onclick="openChiudi(${missione.id})" ${!isInCorso ? 'disabled' : ''}>
                        <i class="fas fa-check"></i> Chiudi
                    </button>
                </div>
            </td>
        </tr>
    `;
}

// ========================================
// DETTAGLIO MISSIONE
// ========================================

async function viewDettaglio(id) {
    try {
        const missione = await dettagliMissione(id);

        if (!missione) {
            Swal.fire('Errore', 'Impossibile caricare i dettagli', 'error');
            return;
        }

        // Carica richiesta
        let richiesta = null;
        if (missione.richiesta_id) {
            try {
                richiesta = await dettagliRichiestaSoccorso(missione.richiesta_id);
            } catch (e) {
                console.warn('Richiesta non disponibile');
            }
        }

        document.getElementById('dettagli-content').innerHTML = generateDettaglioHTML(missione, richiesta);
        openModal('modal-dettagli');

    } catch (error) {
        console.error('Errore:', error);
        Swal.fire('Errore', 'Impossibile caricare i dettagli', 'error');
    }
}

function generateDettaglioHTML(missione, richiesta) {
    const dataInizio = missione.inizio_at ? new Date(missione.inizio_at).toLocaleString('it-IT') : 'N/D';
    const dataFine = missione.fine_at ? new Date(missione.fine_at).toLocaleString('it-IT') : 'In corso';

    const caposquadra = missione.caposquadra;
    const altriOp = missione.operatori?.filter(op => op.id !== caposquadra?.id) || [];

    let html = `
        <div class="detail-section">
            <h3><i class="fas fa-info-circle"></i> Informazioni Generali</h3>
            <div class="detail-grid">
                <div class="detail-item">
                    <label>ID Missione</label>
                    <span><strong>#${missione.id}</strong></span>
                </div>
                <div class="detail-item">
                    <label>Stato</label>
                    <span><span class="status-pill status-${missione.stato}">${missione.stato === 'IN_CORSO' ? 'In Corso' : 'Conclusa'}</span></span>
                </div>
                <div class="detail-item">
                    <label>Data Inizio</label>
                    <span>${dataInizio}</span>
                </div>
                <div class="detail-item">
                    <label>Data Fine</label>
                    <span>${dataFine}</span>
                </div>
                <div class="detail-item" style="grid-column: 1 / -1;">
                    <label>Obiettivo</label>
                    <span>${missione.obiettivo || 'N/D'}</span>
                </div>
                <div class="detail-item" style="grid-column: 1 / -1;">
                    <label>Posizione</label>
                    <span>${missione.posizione || 'N/D'}</span>
                </div>
            </div>
        </div>
    `;

    // Richiesta
    if (richiesta) {
        html += `
            <div class="detail-section">
                <h3><i class="fas fa-bell"></i> Richiesta Associata</h3>
                <div class="detail-grid">
                    <div class="detail-item">
                        <label>Segnalante</label>
                        <span>${richiesta.nome_segnalante || 'N/D'}</span>
                    </div>
                    <div class="detail-item">
                        <label>Email</label>
                        <span>${richiesta.email_segnalante || 'N/D'}</span>
                    </div>
                    <div class="detail-item" style="grid-column: 1 / -1;">
                        <label>Indirizzo</label>
                        <span>${richiesta.indirizzo || 'N/D'}</span>
                    </div>
                    <div class="detail-item" style="grid-column: 1 / -1;">
                        <label>Descrizione</label>
                        <span>${richiesta.descrizione || 'N/D'}</span>
                    </div>
                </div>
            </div>
        `;
    }

    // Squadra
    html += `
        <div class="detail-section">
            <h3><i class="fas fa-users"></i> Squadra</h3>
            <div class="detail-item">
                <label>Caposquadra</label>
                <span><strong>${caposquadra ? `${caposquadra.nome} ${caposquadra.cognome}` : 'N/D'}</strong></span>
            </div>
            <div class="detail-item">
                <label>Altri Operatori</label>
                ${altriOp.length > 0
            ? `<div class="operatori-list">${altriOp.map(op => `<span class="team-badge">${op.nome} ${op.cognome}</span>`).join('')}</div>`
            : '<span style="color: #94a3b8;">Nessuno</span>'}
            </div>
        </div>
    `;

    // Mezzi
    html += `
        <div class="detail-section">
            <h3><i class="fas fa-ambulance"></i> Mezzi</h3>
            ${missione.mezzi?.length > 0
            ? `<div class="mezzi-list">${missione.mezzi.map(m => `<span class="mezzo-badge">${m.targa || m.nome}</span>`).join('')}</div>`
            : '<p style="color: #94a3b8;">Nessun mezzo assegnato</p>'}
        </div>
    `;

    // Materiali
    html += `
        <div class="detail-section">
            <h3><i class="fas fa-box-open"></i> Materiali</h3>
            ${missione.materiali?.length > 0
            ? `<div class="materiali-list">${missione.materiali.map(m => `<span class="team-badge" style="background: #7c3aed;">${m.nome}</span>`).join('')}</div>`
            : '<p style="color: #94a3b8;">Nessun materiale assegnato</p>'}
        </div>
    `;

    // Aggiornamenti
    if (missione.aggiornamenti?.length > 0) {
        html += `
            <div class="detail-section">
                <h3><i class="fas fa-history"></i> Aggiornamenti</h3>
                <div class="aggiornamenti-timeline">
                    ${missione.aggiornamenti.map(agg => `
                        <div class="aggiornamento-item">
                            <div class="aggiornamento-time">
                                <i class="fas fa-clock"></i> ${new Date(agg.created_at).toLocaleString('it-IT')}
                            </div>
                            <div class="aggiornamento-text">${agg.descrizione}</div>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;
    }

    // Chiusura
    if (missione.stato === 'CHIUSA') {
        html += `
            <div class="detail-section">
                <h3><i class="fas fa-flag-checkered"></i> Chiusura</h3>
                <div class="detail-grid">
                    <div class="detail-item">
                        <label>Livello Successo</label>
                        <span>${missione.livello_successo !== null ? missione.livello_successo + '/5' : 'N/D'}</span>
                    </div>
                    <div class="detail-item" style="grid-column: 1 / -1;">
                        <label>Commenti</label>
                        <span>${missione.commenti_finali || 'Nessun commento'}</span>
                    </div>
                </div>
            </div>
        `;
    }

    return html;
}

// ========================================
// AGGIORNA MISSIONE
// ========================================

function openAggiorna(id) {
    currentMissionId = id;
    document.getElementById('testo-aggiornamento').value = '';
    openModal('modal-aggiorna');
}

function initForms() {
    // Form aggiorna
    document.getElementById('form-aggiorna').addEventListener('submit', async function (e) {
        e.preventDefault();

        const testo = document.getElementById('testo-aggiornamento').value.trim();

        if (!testo) {
            Swal.fire('Attenzione', 'Inserisci un aggiornamento', 'warning');
            return;
        }

        try {
            await aggiornaMissione(currentMissionId, {
                aggiornamenti: [{
                    descrizione: testo,
                    created_at: new Date().toISOString()
                }]
            });

            Swal.fire({
                icon: 'success',
                title: 'Aggiornamento Inviato',
                text: 'Gli operatori riceveranno una email',
                timer: 2000,
                showConfirmButton: false
            });

            closeModal('modal-aggiorna');
            loadMissioni(currentFilter);

        } catch (error) {
            console.error('Errore:', error);
            Swal.fire('Errore', error.message || 'Impossibile aggiornare', 'error');
        }
    });

    // Form chiudi
    document.getElementById('form-chiudi').addEventListener('submit', async function (e) {
        e.preventDefault();

        const dataFine = document.getElementById('data-fine').value;
        const livelloSuccesso = parseInt(document.getElementById('livello-successo').value);
        const commenti = document.getElementById('commenti').value.trim();

        if (!dataFine || isNaN(livelloSuccesso)) {
            Swal.fire('Attenzione', 'Compila tutti i campi obbligatori', 'warning');
            return;
        }

        // Salva l'id localmente e chiudi il modal PRIMA della conferma SweetAlert
        const missioneIdDaChiudere = currentMissionId;
        closeModal('modal-chiudi');

        const conferma = await Swal.fire({
            title: 'Conferma Chiusura',
            text: 'Sei sicuro di voler chiudere questa missione?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#16a34a',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Sì, chiudi',
            cancelButtonText: 'Annulla'
        });

        if (!conferma.isConfirmed) return;

        try {
            await aggiornaMissione(missioneIdDaChiudere, {
                stato: 'CHIUSA',
                fine_at: new Date(dataFine).toISOString(),
                livello_successo: livelloSuccesso,
                commenti_finali: commenti || null
            });

            Swal.fire({
                icon: 'success',
                title: 'Missione Chiusa',
                text: 'Gli operatori riceveranno una notifica',
                timer: 2500,
                showConfirmButton: false
            });

            loadMissioni(currentFilter);

        } catch (error) {
            console.error('Errore:', error);
            Swal.fire('Errore', error.message || 'Impossibile chiudere', 'error');
        }
    });
}

function openChiudi(id) {
    currentMissionId = id;

    // Imposta data corrente
    const now = new Date();
    const offset = now.getTimezoneOffset() * 60000;
    const localISOTime = (new Date(now - offset)).toISOString().slice(0, 16);
    document.getElementById('data-fine').value = localISOTime;

    document.getElementById('livello-successo').value = '';
    document.getElementById('commenti').value = '';

    openModal('modal-chiudi');
}

// ========================================
// MODAL MANAGEMENT
// ========================================

function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
    currentMissionId = null;
}

// Click fuori dal modal
document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay')) {
        closeModal(e.target.id);
    }
});

// ESC per chiudere
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.active').forEach(modal => {
            closeModal(modal.id);
        });
    }
});
