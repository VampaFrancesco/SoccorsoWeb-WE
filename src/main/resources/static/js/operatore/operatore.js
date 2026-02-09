// operatore.js - Dashboard operatore con modali

console.log('Script operatore.js caricato');

let missioniData = [];
let filtroAttivo = 'tutte';

document.addEventListener('DOMContentLoaded', function () {
    console.log('DOM caricato');

    caricaMissioniDashboard();
    inizializzaModali();
});

// Carica missioni per il pannello dashboard
async function caricaMissioniDashboard() {
    const missioniFeed = document.getElementById('missioni-feed');

    if (!missioniFeed) return;

    try {
        const token = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');

        if (!token) {
            throw new Error('Token non trovato');
        }

        const response = await fetch('/swa/api/operatori/me/missioni', {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            throw new Error('Errore HTTP: ' + response.status);
        }

        missioniData = await response.json();
        console.log('Missioni ricevute:', missioniData);

        // Mostra solo le prime 5 nel pannello
        const missioniRecenti = missioniData.slice(0, 5);

        if (missioniRecenti.length === 0) {
            missioniFeed.innerHTML = '<div class="empty-state"><i class="fas fa-clipboard-check"></i><p>Nessuna missione attiva</p></div>';
            return;
        }

        const html = missioniRecenti.map(function (m) {
            const stato = m.stato ? m.stato.toLowerCase().replace(/\s+/g, '_') : 'sconosciuto';

            // Estrai informazioni dalla richiesta
            const tipo = m.obiettivo || (m.richiesta ? m.richiesta.descrizione : 'Missione');
            const luogo = m.posizione || (m.richiesta ? m.richiesta.indirizzo : 'Non specificato');
            const dataOra = formatTime(m.inizioAt || m.createdAt);

            return '<div class="missione-row" data-id="' + m.id + '" onclick="apriDettaglioMissione(' + m.id + ')">' +
                '<div class="missione-status status-' + stato + '">' +
                '<i class="fas fa-circle"></i>' +
                '</div>' +
                '<div class="missione-info">' +
                '<span class="missione-title">Missione #' + m.id + '</span>' +
                '<span class="missione-loc"><i class="fas fa-location-dot"></i> ' + escapeHtml(luogo) + '</span>' +
                '</div>' +
                '<div class="missione-time">' +
                '<span>' + dataOra + '</span>' +
                '</div>' +
                '</div>';
        }).join('');

        missioniFeed.innerHTML = html;

    } catch (error) {
        console.error('Errore:', error);
        missioniFeed.innerHTML = '<div class="error-state"><i class="fas fa-exclamation-triangle"></i><p>Errore caricamento</p></div>';
    }
}

// Inizializza modali
function inizializzaModali() {
    // Apri modale missioni
    const btnApriMissioni = document.getElementById('btn-apri-missioni');
    const btnVediTutte = document.getElementById('btn-vedi-tutte');

    if (btnApriMissioni) {
        btnApriMissioni.addEventListener('click', function (e) {
            e.preventDefault();
            apriModaleMissioni();
        });
    }

    if (btnVediTutte) {
        btnVediTutte.addEventListener('click', function (e) {
            e.preventDefault();
            apriModaleMissioni();
        });
    }

    // Chiudi modali
    const closeModalMissioni = document.getElementById('close-modal-missioni');
    const closeModalDettaglio = document.getElementById('close-modal-dettaglio');
    const modalMissioni = document.getElementById('modal-missioni');
    const modalDettaglio = document.getElementById('modal-dettaglio');

    if (closeModalMissioni) {
        closeModalMissioni.addEventListener('click', function () {
            chiudiModale('modal-missioni');
        });
    }

    if (closeModalDettaglio) {
        closeModalDettaglio.addEventListener('click', function () {
            chiudiModale('modal-dettaglio');
        });
    }

    // Chiudi cliccando fuori
    if (modalMissioni) {
        modalMissioni.addEventListener('click', function (e) {
            if (e.target === this) {
                chiudiModale('modal-missioni');
            }
        });
    }

    if (modalDettaglio) {
        modalDettaglio.addEventListener('click', function (e) {
            if (e.target === this) {
                chiudiModale('modal-dettaglio');
            }
        });
    }

    // Filtri
    inizializzaFiltri();

    // Search
    const searchInput = document.getElementById('search-missioni');
    if (searchInput) {
        searchInput.addEventListener('input', function () {
            applicaFiltri();
        });
    }
}

function apriModaleMissioni() {
    const modal = document.getElementById('modal-missioni');
    modal.classList.add('active');
    applicaFiltri();
}

function chiudiModale(idModale) {
    const modal = document.getElementById(idModale);
    modal.classList.remove('active');
}

function inizializzaFiltri() {
    const filtroBtns = document.querySelectorAll('.filtro-btn');

    filtroBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            filtroBtns.forEach(function (b) {
                b.classList.remove('active');
            });

            this.classList.add('active');
            filtroAttivo = this.getAttribute('data-stato');
            applicaFiltri();
        });
    });
}

function applicaFiltri() {
    const searchInput = document.getElementById('search-missioni');
    const searchTerm = searchInput ? searchInput.value.toLowerCase() : '';

    let missioniFiltrate = missioniData;

    // Filtra per stato
    if (filtroAttivo !== 'tutte') {
        missioniFiltrate = missioniData.filter(function (m) {
            const stato = m.stato ? m.stato.toLowerCase().replace(/\s+/g, '_') : '';
            return stato === filtroAttivo;
        });
    }

    // Filtra per search
    if (searchTerm) {
        missioniFiltrate = missioniFiltrate.filter(function (m) {
            const luogo = m.posizione || (m.richiesta ? m.richiesta.indirizzo : '');
            const tipo = m.obiettivo || (m.richiesta ? m.richiesta.descrizione : '');
            return luogo.toLowerCase().includes(searchTerm) || tipo.toLowerCase().includes(searchTerm);
        });
    }

    renderMissioniModale(missioniFiltrate);
}

function renderMissioniModale(missioni) {
    const missioniList = document.getElementById('missioni-modal-list');

    if (!missioni || missioni.length === 0) {
        missioniList.innerHTML = '<div class="empty-modal"><i class="fas fa-clipboard-list"></i><p>Nessuna missione trovata</p></div>';
        return;
    }

    const html = missioni.map(function (m) {
        const stato = m.stato ? m.stato.toLowerCase().replace(/\s+/g, '_') : 'assegnata';
        const tipo = m.obiettivo || (m.richiesta ? m.richiesta.descrizione : 'Missione');
        const luogo = m.posizione || (m.richiesta ? m.richiesta.indirizzo : 'Non specificato');
        const dataOra = formatTimeCompact(m.inizioAt || m.createdAt);

        return '<div class="missione-card-compact" onclick="apriDettaglioMissione(' + m.id + ')">' +
            '<div class="missione-card-header">' +
            '<div class="missione-card-title">' +
            '<div class="missione-card-id">Missione #' + m.id + '</div>' +
            '<div class="missione-card-tipo">' + escapeHtml(tipo) + '</div>' +
            '</div>' +
            '<span class="missione-card-badge badge-' + stato + '">' +
            '<i class="fas fa-circle"></i> ' + formatStato(stato) +
            '</span>' +
            '</div>' +
            '<div class="missione-card-info">' +
            '<div class="info-item"><i class="fas fa-location-dot"></i> ' + escapeHtml(luogo) + '</div>' +
            '<div class="info-item"><i class="fas fa-clock"></i> ' + dataOra + '</div>' +
            '</div>' +
            '</div>';
    }).join('');

    missioniList.innerHTML = html;
}

async function apriDettaglioMissione(id) {
    const modal = document.getElementById('modal-dettaglio');
    const content = document.getElementById('dettaglio-content');

    // Mostra modale con loading
    modal.classList.add('active');
    content.innerHTML = '<div class="loading-spinner"><i class="fas fa-spinner fa-spin"></i><p>Caricamento dettagli...</p></div>';

    try {
        const token = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');

        const response = await fetch('/swa/api/missioni/' + id, {
            headers: {
                'Authorization': 'Bearer ' + token,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) throw new Error('Errore caricamento');

        const missione = await response.json();
        console.log('Dettaglio missione:', missione);
        renderDettaglioMissione(missione);

    } catch (error) {
        console.error('Errore:', error);
        content.innerHTML = '<div class="error-state"><i class="fas fa-exclamation-triangle"></i><p>Errore caricamento dettagli</p></div>';
    }
}

function renderDettaglioMissione(m) {
    const content = document.getElementById('dettaglio-content');

    const stato = m.stato ? m.stato.toLowerCase().replace(/\s+/g, '_') : 'assegnata';
    const operatori = m.operatori || [];
    const mezzi = m.mezzi || [];
    const materiali = m.materiali || [];

    // Informazioni dalla richiesta
    const tipo = m.obiettivo || (m.richiesta ? m.richiesta.descrizione : 'N/D');
    const luogo = m.posizione || (m.richiesta ? m.richiesta.indirizzo : 'N/D');
    const latitudine = m.latitudine || (m.richiesta ? m.richiesta.latitudine : 'N/D');
    const longitudine = m.longitudine || (m.richiesta ? m.richiesta.longitudine : 'N/D');

    const html = '<div class="dettaglio-grid">' +
        '<div class="dettaglio-section">' +
        '<h3><i class="fas fa-info-circle"></i> Informazioni Generali</h3>' +
        '<div class="dettaglio-row"><span class="dettaglio-label">ID Missione</span><span class="dettaglio-value">#' + m.id + '</span></div>' +
        '<div class="dettaglio-row"><span class="dettaglio-label">Obiettivo</span><span class="dettaglio-value">' + escapeHtml(m.obiettivo || 'N/D') + '</span></div>' +
        '<div class="dettaglio-row"><span class="dettaglio-label">Stato</span><span class="dettaglio-value"><span class="missione-card-badge badge-' + stato + '"><i class="fas fa-circle"></i> ' + formatStato(stato) + '</span></span></div>' +
        '<div class="dettaglio-row"><span class="dettaglio-label">Luogo</span><span class="dettaglio-value">' + escapeHtml(luogo) + '</span></div>' +
        '<div class="dettaglio-row"><span class="dettaglio-label">Coordinate</span><span class="dettaglio-value">' + latitudine + ', ' + longitudine + '</span></div>' +
        '</div>' +
        '<div class="dettaglio-section">' +
        '<h3><i class="fas fa-clock"></i> Tempistiche</h3>' +
        '<div class="dettaglio-row"><span class="dettaglio-label">Inizio</span><span class="dettaglio-value">' + formatDataOra(m.inizioAt) + '</span></div>' +
        '<div class="dettaglio-row"><span class="dettaglio-label">Fine</span><span class="dettaglio-value">' + (m.fineAt ? formatDataOra(m.fineAt) : 'In corso') + '</span></div>' +
        '<div class="dettaglio-row"><span class="dettaglio-label">Creazione</span><span class="dettaglio-value">' + formatDataOra(m.createdAt) + '</span></div>' +
        '</div>' +
        '</div>' +
        '<div class="dettaglio-section">' +
        '<h3><i class="fas fa-users"></i> Team Operatori (' + operatori.length + ')</h3>' +
        '<div class="operatori-list">' +
        generaListaOperatori(operatori) +
        '</div>' +
        '</div>' +
        (mezzi.length > 0 ? '<div class="dettaglio-section"><h3><i class="fas fa-truck-medical"></i> Mezzi (' + mezzi.length + ')</h3>' + generaListaMezzi(mezzi) + '</div>' : '') +
        (materiali.length > 0 ? '<div class="dettaglio-section"><h3><i class="fas fa-kit-medical"></i> Materiali (' + materiali.length + ')</h3>' + generaListaMateriali(materiali) + '</div>' : '');

    content.innerHTML = html;
}

function generaListaOperatori(operatori) {
    if (!operatori || operatori.length === 0) {
        return '<p class="dettaglio-value" style="text-align:center;color:var(--text-secondary)">Nessun operatore assegnato</p>';
    }

    return operatori.map(function (op) {
        const iniziali = (op.nome ? op.nome.charAt(0) : '') + (op.cognome ? op.cognome.charAt(0) : '');
        const nomeCompleto = (op.nome || '') + ' ' + (op.cognome || '');

        return '<div class="operatore-item">' +
            '<div class="operatore-avatar">' + iniziali + '</div>' +
            '<div class="operatore-info">' +
            '<div class="operatore-nome">' + escapeHtml(nomeCompleto) + '</div>' +
            '<div class="operatore-ruolo">' + (op.email || 'Operatore') + '</div>' +
            '</div>' +
            '</div>';
    }).join('');
}

function generaListaMezzi(mezzi) {
    return '<div style="display:flex;flex-direction:column;gap:8px">' +
        mezzi.map(function (m) {
            return '<div style="padding:10px;background:var(--bg-body);border-radius:6px">' +
                '<strong>' + escapeHtml(m.targa || 'N/D') + '</strong> - ' + escapeHtml(m.tipo || 'N/D') +
                '</div>';
        }).join('') +
        '</div>';
}

function generaListaMateriali(materiali) {
    return '<div style="display:flex;flex-direction:column;gap:8px">' +
        materiali.map(function (mat) {
            return '<div style="padding:10px;background:var(--bg-body);border-radius:6px">' +
                escapeHtml(mat.nome || 'Materiale') + ' (x' + (mat.quantita || 1) + ')' +
                '</div>';
        }).join('') +
        '</div>';
}

function formatStato(stato) {
    const stati = {
        'in_corso': 'In Corso',
        'completata': 'Completata',
        'annullata': 'Annullata',
        'assegnata': 'Assegnata'
    };
    return stati[stato] || stato;
}

function formatTime(dateString) {
    if (!dateString) return '--:--';

    try {
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return '--:--';

        const ore = date.toLocaleTimeString('it-IT', {
            hour: '2-digit',
            minute: '2-digit'
        });

        const oggi = new Date();

        if (date.toDateString() === oggi.toDateString()) {
            return ore;
        }

        return date.toLocaleDateString('it-IT', {
            day: '2-digit',
            month: '2-digit'
        }) + ' ' + ore;

    } catch (e) {
        return '--:--';
    }
}

function formatTimeCompact(dateString) {
    if (!dateString) return '--';

    try {
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return '--';

        return date.toLocaleDateString('it-IT', {
            day: '2-digit',
            month: 'short'
        }) + ' ' + date.toLocaleTimeString('it-IT', {
            hour: '2-digit',
            minute: '2-digit'
        });
    } catch (e) {
        return '--';
    }
}

function formatDataOra(dateString) {
    if (!dateString) return '--';

    try {
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return '--';

        return date.toLocaleDateString('it-IT', {
            day: '2-digit',
            month: 'long',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    } catch (e) {
        return '--';
    }
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = String(text);
    return div.innerHTML;
}
