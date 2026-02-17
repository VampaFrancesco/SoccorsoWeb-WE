
document.addEventListener('DOMContentLoaded', async () => {
    await loadOperatori('tutti');

    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', async () => {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            await loadOperatori(btn.getAttribute('data-filter'));
        });
    });
});

// CARICAMENTO OPERATORI

async function loadOperatori(filter) {
    try {
        const operatori = await apiCall('/swa/api/operatori?disponibile=false', 'GET');

        if (!operatori || !Array.isArray(operatori)) {
            throw new Error('Risposta non valida');
        }

        const operatoriConMissioni = await Promise.all(operatori.map(async (op) => {
            let missioneAttuale = null;
            try {
                if (op.id) {
                    const missioni = await apiCall(`/swa/api/operatori/${op.id}/missioni`, 'GET');
                    if (Array.isArray(missioni)) {
                        missioneAttuale = missioni.find(m => m.stato === 'IN_CORSO') || null;
                    }
                }
            } catch (e) { /* silenzioso */ }
            return { ...op, occupato: !!missioneAttuale, missioneAttuale };
        }));

        // Filtra
        let risultato = operatoriConMissioni;
        if (filter === 'disponibili') {
            risultato = risultato.filter(op => op.attivo && !op.occupato);
        } else if (filter === 'occupati') {
            risultato = risultato.filter(op => op.occupato);
        }

        renderOperatori(risultato);
    } catch (err) {
        Swal.fire('Errore', 'Impossibile caricare gli operatori', 'error');
    }
}

// RENDER

function renderOperatori(operatori) {
    const tbody = document.querySelector('.modern-table tbody');
    if (!tbody) return;

    tbody.innerHTML = '';

    if (operatori.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="4" style="text-align: center; padding: 40px;">
                    <div class="empty-state">
                        <i class="fas fa-inbox" style="font-size: 2rem; color: var(--text-secondary); margin-bottom: 10px;"></i>
                        <p style="color: var(--text-secondary); margin: 0;">Nessun operatore trovato</p>
                    </div>
                </td>
            </tr>
        `;
        return;
    }

    operatori.forEach(op => tbody.appendChild(buildOperatorRow(op)));
}

function buildOperatorRow(op) {
    const tr = document.createElement('tr');

    // Stato badge
    let statusClass, statusText;
    if (!op.attivo) {
        statusClass = 'status-non-attivo';
        statusText = 'Non Attivo';
    } else if (op.occupato) {
        statusClass = 'status-occupato';
        statusText = 'Occupato';
    } else {
        statusClass = 'status-disponibile';
        statusText = 'Disponibile';
    }

    // Missione attuale
    let missioneHtml = '<span style="color: var(--text-secondary);">—</span>';
    if (op.missioneAttuale) {
        const m = op.missioneAttuale;
        missioneHtml = `
            <div class="mission-info">
                <div class="mission-title">${m.obiettivo || 'Missione #' + m.id}</div>
                <div class="mission-details">${m.posizione || 'Posizione non specificata'}</div>
                <div class="mission-time"><i class="far fa-clock"></i> Inizio: ${formatDate(m.inizioat)}</div>
            </div>
        `;
    }

    // Iniziali
    const n = (op.nome || '').charAt(0).toUpperCase();
    const c = (op.cognome || '').charAt(0).toUpperCase();
    const initials = (n + c) || '?';

    tr.innerHTML = `
        <td>
            <div class="operator-info">
                <div class="operator-avatar">${initials}</div>
                <div class="operator-details">
                    <div class="operator-name">${op.nome} ${op.cognome}</div>
                    <div class="operator-email">${op.email}</div>
                </div>
            </div>
        </td>
        <td><span class="status-badge ${statusClass}">${statusText}</span></td>
        <td>${missioneHtml}</td>
        <td>
            <div class="action-group">
                <button class="btn-action" onclick="visualizzaDettagli(${op.id})" title="Dettagli">
                    <i class="fas fa-eye"></i> Dettagli
                </button>
            </div>
        </td>
    `;
    return tr;
}

// DETTAGLI OPERATORE

async function visualizzaDettagli(id) {
    try {
        const operatore = await apiCall(`/swa/api/operatori/${id}`, 'GET');
        const missioni = await apiCall(`/swa/api/operatori/${id}/missioni`, 'GET');

        const missioniInCorso = Array.isArray(missioni) ? missioni.filter(m => m.stato === 'IN_CORSO') : [];

        let htmlMissioni = '<p style="text-align: center; color: var(--text-secondary);">Nessuna missione in corso</p>';
        if (missioniInCorso.length > 0) {
            htmlMissioni = missioniInCorso.map(m => `
                <div style="background: rgba(59,130,246,0.1); padding: 12px; border-radius: 8px; margin-bottom: 10px; border-left: 4px solid var(--accent-primary);">
                    <strong>${m.obiettivo || 'Missione #' + m.id}</strong><br>
                    <small>📍 ${m.posizione || 'Posizione non disponibile'}</small><br>
                    <small>⏰ Inizio: ${formatDate(m.inizioat || m.inizio_at)}</small>
                </div>
            `).join('');
        }

        await Swal.fire({
            title: `${operatore.nome} ${operatore.cognome}`,
            html: `
                <div style="text-align: left;">
                    <h4 style="margin-top: 0; color: var(--accent-primary);">Informazioni Personali</h4>
                    <p><strong>Email:</strong> ${operatore.email}</p>
                    <p><strong>Telefono:</strong> ${operatore.telefono || 'Non disponibile'}</p>
                    <p><strong>Indirizzo:</strong> ${operatore.indirizzo || 'Non disponibile'}</p>
                    <p><strong>Data Nascita:</strong> ${operatore.datanascita || operatore.data_nascita || 'Non disponibile'}</p>
                    
                    <h4 style="color: var(--accent-primary); margin-top: 20px;">Stato</h4>
                    <p><strong>Attivo:</strong> <span style="color: ${operatore.attivo ? 'var(--accent-success)' : 'var(--accent-danger)'};">${operatore.attivo ? '✓ Sì' : '✗ No'}</span></p>
                    
                    <h4 style="color: var(--accent-primary); margin-top: 20px;">Missioni in Corso</h4>
                    ${htmlMissioni}
                </div>
            `,
            icon: 'info',
            confirmButtonText: 'Chiudi',
            confirmButtonColor: '#3b82f6',
            width: '600px'
        });
    } catch (err) {
        Swal.fire('Errore', 'Impossibile caricare i dettagli dell\'operatore', 'error');
    }
}
