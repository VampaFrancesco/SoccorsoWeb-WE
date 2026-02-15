let currentMissionId = null;
let currentFilter = 'IN_CORSO';
let detailMap = null;

// ── INIT ──

document.addEventListener('DOMContentLoaded', function () {
    initFilterButtons();
    loadMissioni('IN_CORSO');
    initForms();
});

// ── FILTRI ──

function initFilterButtons() {
    document.querySelectorAll('.missioni-container .filter-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.missioni-container .filter-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            loadMissioni(this.dataset.stato);
        });
    });
}

// ── CARICAMENTO MISSIONI ──

async function loadMissioni(stato) {
    currentFilter = stato;
    const tbody = document.getElementById('missioni-body');
    const noData = document.getElementById('no-data');

    tbody.innerHTML = '<tr class="loading-row"><td colspan="8"><i class="fas fa-spinner fa-spin"></i> Caricamento missioni...</td></tr>';
    noData.style.display = 'none';

    try {
        const missioni = await visualizzaTutteLeMissioni();

        if (!missioni || missioni.length === 0) {
            tbody.innerHTML = '';
            noData.style.display = 'flex';
            return;
        }

        let filtered = stato === 'ALL' ? missioni : missioni.filter(m => m.stato === stato);

        if (filtered.length === 0) {
            tbody.innerHTML = '';
            noData.style.display = 'flex';
            return;
        }

        filtered.sort((a, b) => {
            const dA = parseDate(a.inizio_at) || new Date(0);
            const dB = parseDate(b.inizio_at) || new Date(0);
            return dB - dA;
        });

        tbody.innerHTML = filtered.map(m => buildRow(m)).join('');
    } catch (error) {
        tbody.innerHTML = '<tr><td colspan="8" style="color: var(--accent-danger); text-align: center; padding: 40px;"><i class="fas fa-exclamation-triangle"></i> Errore nel caricamento</td></tr>';
    }
}

// ── RIGA TABELLA ──

function buildRow(m) {
    const dataInizio = formatDate(m.inizio_at);
    const capo = m.caposquadra;
    const numOp = m.operatori?.length || 0;
    const numMezzi = m.mezzi?.length || 0;
    const isAttiva = m.stato === 'IN_CORSO';

    const statoLabel = m.stato === 'IN_CORSO' ? 'In Corso'
        : m.stato === 'CHIUSA' ? 'Conclusa'
            : m.stato === 'FALLITA' ? 'Fallita' : m.stato;

    return `
        <tr>
            <td><span class="targa-badge">#${m.id}</span></td>
            <td><strong>#${m.richiesta_id || 'N/D'}</strong></td>
            <td>${capo ? `${capo.nome} ${capo.cognome}` : 'N/D'}</td>
            <td>
                ${numOp > 0
            ? `<span class="team-badge">${numOp} operatori</span>`
            : '<span style="color: var(--text-secondary);">—</span>'}
            </td>
            <td>
                ${numMezzi > 0
            ? m.mezzi.map(mz => `<span class="mezzo-badge">${mz.targa || mz.nome}</span>`).join(' ')
            : '<span style="color: var(--text-secondary);">—</span>'}
            </td>
            <td>${dataInizio}</td>
            <td><span class="status-pill status-${m.stato}">${statoLabel}</span></td>
            <td>
                <div class="action-group">
                    <button class="btn-view" onclick="viewDettaglio(${m.id})">
                        <i class="fas fa-eye"></i> Dettagli
                    </button>
                    <button class="btn-update" onclick="openAggiorna(${m.id})" ${!isAttiva ? 'disabled' : ''}>
                        <i class="fas fa-edit"></i> Aggiorna
                    </button>
                    <button class="btn-close-mission" onclick="openChiudi(${m.id})" ${!isAttiva ? 'disabled' : ''}>
                        <i class="fas fa-check"></i> Chiudi
                    </button>
                </div>
            </td>
        </tr>
    `;
}

// ── DETTAGLIO MISSIONE ──

async function viewDettaglio(id) {
    try {
        const missione = await dettagliMissione(id);
        if (!missione) {
            Swal.fire('Errore', 'Impossibile caricare i dettagli', 'error');
            return;
        }

        let richiesta = null;
        if (missione.richiesta_id) {
            try {
                richiesta = await dettagliRichiestaSoccorso(missione.richiesta_id);
            } catch (e) { /* richiesta non trovata */ }
        }

        document.getElementById('dettagli-content').innerHTML = buildDettaglioHTML(missione, richiesta);
        openModal('modal-dettagli');

        // Inizializza mappa dopo apertura modal
        setTimeout(() => initDetailMap(missione, richiesta), 200);
    } catch (error) {
        Swal.fire('Errore', 'Impossibile caricare i dettagli', 'error');
    }
}

function buildDettaglioHTML(missione, richiesta) {
    const dataInizio = formatDate(missione.inizio_at);
    const dataFine = missione.fine_at ? formatDate(missione.fine_at) : 'In corso';
    const allOperatori = missione.operatori || [];
    const capiSquadra = allOperatori.filter(op => op.ruolo_missione === 'CAPOSQUADRA');
    const altriOp = allOperatori.filter(op => op.ruolo_missione !== 'CAPOSQUADRA');
    // Fallback: se nessuno ha ruolo_missione, usa il vecchio campo caposquadra
    const capoFallback = missione.caposquadra;

    const lat = missione.latitudine || richiesta?.latitudine;
    const lon = missione.longitudine || richiesta?.longitudine;

    let html = `
        <div class="detail-section">
            <h2><i class="fas fa-info-circle"></i> Informazioni Generali</h2>
            <div class="detail-grid">
                <div class="detail-item">
                    <label>ID Missione</label>
                    <span><strong>#${missione.id}</strong></span>
                </div>
                <div class="detail-item">
                    <label>Stato</label>
                    <span><span class="status-pill status-${missione.stato}">${missione.stato === 'IN_CORSO' ? 'In Corso' : missione.stato === 'CHIUSA' ? 'Conclusa' : missione.stato}</span></span>
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
                    <span><i class="fas fa-map-marker-alt" style="color: var(--accent-danger);"></i> ${missione.posizione || 'N/D'}</span>
                </div>
            </div>
        </div>
    `;

    // Mappa
    if (lat && lon) {
        html += `
            <div class="detail-section">
                <h2><i class="fas fa-map-location-dot"></i> Mappa</h2>
                <div class="map-container" id="detail-map"></div>
            </div>
        `;
    }

    // Richiesta associata
    if (richiesta) {
        html += `
            <div class="detail-section">
                <h2><i class="fas fa-bell"></i> Richiesta Associata</h2>
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

        // Foto Richiesta
        const fotoSrc = richiesta.foto ? `data:image/jpeg;base64,${richiesta.foto}` : null;

        html += `
            <div class="detail-section">
                <h2><i class="fas fa-camera"></i> Foto Segnalazione</h2>
                <div style="text-align: center; padding: 10px;">
                    ${fotoSrc
                ? `<img src="${fotoSrc}" alt="Foto segnalazione" style="max-width: 100%; max-height: 250px; object-fit: contain; border-radius: 8px; border: 1px solid var(--border-color);">`
                : `<div style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 20px; background: rgba(255,255,255,0.02); border-radius: 8px; border: 1px dashed var(--border-color);">
                               <i class="fas fa-image" style="font-size: 2rem; color: var(--text-secondary); opacity: 0.5; margin-bottom: 8px;"></i>
                               <p style="color: var(--text-secondary); font-size: 0.85rem; margin:0;">Nessuna foto disponibile</p>
                           </div>`
            }
                </div>
            </div>
        `;
    }

    // Squadra - con supporto multipli caposquadra
    const capiHtml = capiSquadra.length > 0
        ? capiSquadra.map(c => `<span class="team-badge" style="background: rgba(245,158,11,0.2); color: #fbbf24; border: 1px solid rgba(245,158,11,0.3);"><i class="fas fa-crown" style="margin-right:4px;"></i>${c.nome} ${c.cognome}</span>`).join('')
        : (capoFallback ? `<span class="team-badge" style="background: rgba(245,158,11,0.2); color: #fbbf24; border: 1px solid rgba(245,158,11,0.3);"><i class="fas fa-crown" style="margin-right:4px;"></i>${capoFallback.nome} ${capoFallback.cognome}</span>` : '<span style="color: var(--text-secondary);">N/D</span>');

    html += `
        <div class="detail-section">
            <h2><i class="fas fa-users"></i> Squadra</h2>
            <div class="detail-item">
                <label>Caposquadra</label>
                <div class="operatori-list">${capiHtml}</div>
            </div>
            <div class="detail-item" style="margin-top: 10px;">
                <label>Operatori</label>
                ${altriOp.length > 0
            ? `<div class="operatori-list">${altriOp.map(op => `<span class="team-badge">${op.nome} ${op.cognome}</span>`).join('')}</div>`
            : '<span style="color: var(--text-secondary);">Nessuno assegnato</span>'}
            </div>
        </div>
    `;

    // Mezzi
    html += `
        <div class="detail-section">
            <h2><i class="fas fa-ambulance"></i> Mezzi</h2>
            ${missione.mezzi?.length > 0
            ? `<div class="mezzi-list">${missione.mezzi.map(m => `<span class="mezzo-badge">${m.targa || m.nome}</span>`).join('')}</div>`
            : '<p style="color: var(--text-secondary);">Nessun mezzo assegnato</p>'}
        </div>
    `;

    // Materiali (con quantità assegnata)
    html += `
        <div class="detail-section">
            <h2><i class="fas fa-box-open"></i> Materiali</h2>
            ${missione.materiali?.length > 0
            ? `<div class="materiali-list">${missione.materiali.map(m => `<span class="materiale-badge">${m.nome} <span style="background:rgba(59,130,246,0.3); padding:2px 6px; border-radius:4px; font-size:0.75rem; margin-left:4px;">×${m.quantita}</span></span>`).join('')}</div>`
            : '<p style="color: var(--text-secondary);">Nessun materiale assegnato</p>'}
        </div>
    `;

    // Aggiornamenti
    if (missione.aggiornamenti?.length > 0) {
        const sortedAgg = [...missione.aggiornamenti].sort((a, b) => {
            const da = parseDate(a.created_at) || new Date(0);
            const db = parseDate(b.created_at) || new Date(0);
            return db - da;
        });

        html += `
            <div class="detail-section">
                <h2><i class="fas fa-history"></i> Aggiornamenti</h2>
                <div class="aggiornamenti-timeline">
                    ${sortedAgg.map(agg => `
                        <div class="aggiornamento-item">
                            <div class="aggiornamento-time">
                                <i class="fas fa-clock"></i> ${formatDate(agg.created_at)}
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
                <h2><i class="fas fa-flag-checkered"></i> Chiusura</h2>
                <div class="detail-grid">
                    <div class="detail-item">
                        <label>Livello Successo</label>
                        <span>${missione.livello_successo !== null && missione.livello_successo !== undefined ? missione.livello_successo + '/5' : 'N/D'}</span>
                    </div>
                    <div class="detail-item" style="grid-column: 1 / -1;">
                        <label>Commenti Finali</label>
                        <span>${missione.commenti_finali || 'Nessun commento'}</span>
                    </div>
                </div>
            </div>
        `;
    }

    return html;
}

// ── MAPPA DETTAGLI ──

function initDetailMap(missione, richiesta) {
    const mapEl = document.getElementById('detail-map');
    if (!mapEl) return;

    if (detailMap) {
        detailMap.remove();
        detailMap = null;
    }

    const lat = parseFloat(missione.latitudine || richiesta?.latitudine);
    const lon = parseFloat(missione.longitudine || richiesta?.longitudine);

    if (isNaN(lat) || isNaN(lon)) return;

    detailMap = L.map('detail-map').setView([lat, lon], 15);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap',
        maxZoom: 19
    }).addTo(detailMap);

    L.marker([lat, lon]).addTo(detailMap)
        .bindPopup(`<strong>${missione.posizione || 'Posizione intervento'}</strong>`)
        .openPopup();
}

// ── AGGIORNA MISSIONE ──

function openAggiorna(id) {
    currentMissionId = id;
    document.getElementById('testo-aggiornamento').value = '';
    openModal('modal-aggiorna');
}

function initForms() {
    // Form aggiornamento
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

            Swal.fire({ icon: 'success', title: 'Aggiornamento Inviato', text: 'Gli operatori riceveranno una email', timer: 2000, showConfirmButton: false });
            closeModal('modal-aggiorna');
            loadMissioni(currentFilter);
        } catch (error) {
            Swal.fire('Errore', error.message || 'Impossibile aggiornare', 'error');
        }
    });

    // Form chiusura
    document.getElementById('form-chiudi').addEventListener('submit', async function (e) {
        e.preventDefault();

        const dataFine = document.getElementById('data-fine').value;
        const livelloSuccesso = parseInt(document.getElementById('livello-successo').value);
        const commenti = document.getElementById('commenti').value.trim();

        if (!dataFine || isNaN(livelloSuccesso)) {
            Swal.fire('Attenzione', 'Compila tutti i campi obbligatori', 'warning');
            return;
        }

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

            Swal.fire({ icon: 'success', title: 'Missione Chiusa', text: 'Gli operatori riceveranno una notifica', timer: 2500, showConfirmButton: false });
            loadMissioni(currentFilter);
        } catch (error) {
            Swal.fire('Errore', error.message || 'Impossibile chiudere', 'error');
        }
    });
}

function openChiudi(id) {
    currentMissionId = id;

    const now = new Date();
    const offset = now.getTimezoneOffset() * 60000;
    const localISOTime = (new Date(now - offset)).toISOString().slice(0, 16);
    document.getElementById('data-fine').value = localISOTime;
    document.getElementById('livello-successo').value = '';
    document.getElementById('commenti').value = '';

    openModal('modal-chiudi');
}

// ── MODAL MANAGEMENT ──

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

    if (detailMap) {
        detailMap.remove();
        detailMap = null;
    }
    currentMissionId = null;
}

document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay')) {
        closeModal(e.target.id);
    }
});

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.active').forEach(modal => closeModal(modal.id));
    }
});

// ── UTILS (locali) ──

function parseDate(dateInput) {
    if (!dateInput) return null;
    let date;
    if (Array.isArray(dateInput)) {
        date = new Date(dateInput[0], dateInput[1] - 1, dateInput[2], dateInput[3] || 0, dateInput[4] || 0, dateInput[5] || 0);
    } else {
        date = new Date(dateInput);
    }
    return isNaN(date.getTime()) ? null : date;
}

function formatDate(dateInput) {
    const date = parseDate(dateInput);
    if (!date) return 'N/D';
    return date.toLocaleString('it-IT', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' });
}
