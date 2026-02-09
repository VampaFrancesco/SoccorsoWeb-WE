document.addEventListener('DOMContentLoaded', async () => {
    console.log("Gestione Operatori caricata.");
    await loadOperatori('tutti');

    // Event listeners per filtri
    const filterBtns = document.querySelectorAll('.filter-btn');
    filterBtns.forEach(btn => {
        btn.addEventListener('click', async () => {
            filterBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            const filter = btn.getAttribute('data-filter');
            await loadOperatori(filter);
        });
    });
});

async function loadOperatori(filter) {
    try {
        // Carica lista operatori
        const operatori = await apiCall('/swa/api/operatori', 'GET');

        // Carica missioni per ogni operatore per determinare se è occupato
        const operatoriConMissioni = await Promise.all(operatori.map(async (op) => {
            try {
                const missioni = await apiCall(`/swa/api/operatori/${op.id}/missioni`, 'GET');

                // Trova la missione IN_CORSO (se esiste)
                const missioneAttuale = missioni.find(m => m.stato === 'IN_CORSO');

                return {
                    ...op,
                    occupato: !!missioneAttuale,
                    missioneAttuale: missioneAttuale || null
                };
            } catch (err) {
                console.error(`Errore caricamento missioni operatore ${op.id}:`, err);
                return {
                    ...op,
                    occupato: false,
                    missioneAttuale: null
                };
            }
        }));

        // Filtra operatori in base al criterio selezionato
        let operatoriFiltrati = operatoriConMissioni;
        if (filter === 'disponibili') {
            operatoriFiltrati = operatoriFiltrati.filter(op => op.disponibile && !op.occupato);
        } else if (filter === 'occupati') {
            operatoriFiltrati = operatoriFiltrati.filter(op => op.occupato);
        }

        // Popola la tabella
        const tbody = document.querySelector('.modern-table tbody');

        if (!tbody) {
            console.error("Errore: elemento tbody non trovato nel DOM");
            Swal.fire('Errore', 'Errore di caricamento della pagina', 'error');
            return;
        }

        tbody.innerHTML = '';

        if (operatoriFiltrati.length === 0) {
            const tableContainer = document.querySelector('.table-container');
            if (tableContainer) {
                tableContainer.innerHTML = `
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <p>Nessun operatore trovato</p>
                    </div>
                `;
            }
            return;
        }

        operatoriFiltrati.forEach(op => {
            const row = createOperatorRow(op);
            tbody.appendChild(row);
        });

    } catch (err) {
        console.error("Errore caricamento operatori:", err);
        Swal.fire('Errore', 'Impossibile caricare gli operatori', 'error');
    }
}

function createOperatorRow(operatore) {
    const tr = document.createElement('tr');

    // Determina lo stato
    let statusClass = 'status-non-attivo';
    let statusText = 'Non Attivo';

    if (!operatore.attivo) {
        statusClass = 'status-non-attivo';
        statusText = 'Non Attivo';
    } else if (operatore.occupato) {
        statusClass = 'status-occupato';
        statusText = 'Occupato';
    } else if (operatore.disponibile) {
        statusClass = 'status-disponibile';
        statusText = 'Disponibile';
    }

    // Crea contenuto della riga
    let missioneHtml = '<span class="mission-details">-</span>';
    if (operatore.missioneAttuale) {
        const missioneData = operatore.missioneAttuale;
        const inizioData = new Date(missioneData.inizioat).toLocaleString('it-IT');

        missioneHtml = `
            <div class="mission-info">
                <div class="mission-title">${missioneData.obiettivo || 'Missione #' + missioneData.id}</div>
                <div class="mission-details">${missioneData.posizione || 'Posizione non specificata'}</div>
                <div class="mission-time">
                    <i class="far fa-clock"></i>
                    Inizio: ${inizioData}
                </div>
            </div>
        `;
    }

    tr.innerHTML = `
        <td>
            <div class="operator-info">
                <div class="operator-avatar">${getInitials(operatore.nome, operatore.cognome)}</div>
                <div class="operator-details">
                    <div class="operator-name">${operatore.nome} ${operatore.cognome}</div>
                    <div class="operator-email">${operatore.email}</div>
                </div>
            </div>
        </td>
        <td>
            <span class="status-badge ${statusClass}">${statusText}</span>
        </td>
        <td>
            ${missioneHtml}
        </td>
        <td>
            <div class="action-group">
                <button class="btn-action" onclick="visualizzaDettagli(${operatore.id})" title="Dettagli">
                    <i class="fas fa-eye"></i> Dettagli
                </button>
            </div>
        </td>
    `;

    return tr;
}

function getInitials(nome, cognome) {
    const n = (nome || '').charAt(0).toUpperCase();
    const c = (cognome || '').charAt(0).toUpperCase();
    return (n + c) || '?';
}

async function visualizzaDettagli(id) {
    try {
        const operatore = await apiCall(`/swa/api/operatori/${id}`, 'GET');
        const missioni = await apiCall(`/swa/api/operatori/${id}/missioni`, 'GET');

        // Filtra missioni IN_CORSO
        const missioniInCorso = missioni.filter(m => m.stato === 'IN_CORSO');

        let htmlMissioni = '<p style="text-align: center; color: #94a3b8;">Nessuna missione in corso</p>';
        if (missioniInCorso.length > 0) {
            htmlMissioni = missioniInCorso.map(m => {
                const inizio = new Date(m.inizioat).toLocaleString('it-IT');
                return `
                    <div style="background: #f8fafc; padding: 12px; border-radius: 8px; margin-bottom: 10px; border-left: 4px solid #0ea5e9;">
                        <strong>${m.obiettivo || 'Missione #' + m.id}</strong><br>
                        <small>📍 ${m.posizione || 'Posizione non disponibile'}</small><br>
                        <small>⏰ Inizio: ${inizio}</small>
                    </div>
                `;
            }).join('');
        }

        const htmlContent = `
            <div style="text-align: left;">
                <h4 style="margin-top: 0; color: #0f4c81;">Informazioni Personali</h4>
                <p><strong>Nome:</strong> ${operatore.nome}</p>
                <p><strong>Cognome:</strong> ${operatore.cognome}</p>
                <p><strong>Email:</strong> ${operatore.email}</p>
                <p><strong>Telefono:</strong> ${operatore.telefono || 'Non disponibile'}</p>
                <p><strong>Indirizzo:</strong> ${operatore.indirizzo || 'Non disponibile'}</p>
                <p><strong>Data Nascita:</strong> ${operatore.datanascita || 'Non disponibile'}</p>
                
                <h4 style="color: #0f4c81; margin-top: 20px;">Stato Attuale</h4>
                <p><strong>Attivo:</strong> <span style="color: ${operatore.attivo ? '#166534' : '#991b1b'};">${operatore.attivo ? '✓ Sì' : '✗ No'}</span></p>
                <p><strong>Disponibile:</strong> <span style="color: ${operatore.disponibile ? '#166534' : '#992c3c'};">${operatore.disponibile ? '✓ Sì' : '✗ No'}</span></p>
                
                <h4 style="color: #0f4c81; margin-top: 20px;">Missioni in Corso</h4>
                ${htmlMissioni}
            </div>
        `;

        await Swal.fire({
            title: `${operatore.nome} ${operatore.cognome}`,
            html: htmlContent,
            icon: 'info',
            confirmButtonText: 'Chiudi',
            confirmButtonColor: '#0f4c81',
            width: '600px'
        });

    } catch (err) {
        console.error("Errore caricamento dettagli:", err);
        Swal.fire('Errore', 'Impossibile caricare i dettagli dell\'operatore', 'error');
    }
}
