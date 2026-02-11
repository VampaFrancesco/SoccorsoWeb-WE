// ── INIT ──

document.addEventListener('DOMContentLoaded', async function () {
    setCurrentDate();
    highlightActiveNav();

    const currentPath = window.location.pathname;
    if (currentPath === '/admin' || currentPath === '/admin/') {
        await refreshDashboard();
    } else {
        await updateGlobalBadges();
    }
});

// ── UI HELPERS ──

function setCurrentDate() {
    const dateEl = document.getElementById('current-date');
    if (!dateEl) return;
    dateEl.textContent = new Date().toLocaleDateString('it-IT', {
        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
    });
}

function highlightActiveNav() {
    const currentPath = window.location.pathname;
    document.querySelectorAll('.nav-links a').forEach(link => {
        const isActive = link.getAttribute('href') === currentPath;
        link.parentElement.classList.toggle('active', isActive);
    });
}

// ── BADGE SIDEBAR ──

async function updateGlobalBadges() {
    try {
        const richieste = await visualizzaRichiesteFiltrate('ATTIVA', 0, 1);
        const count = richieste?.totalElements || 0;
        const badge = document.getElementById('sidebar-badge');
        if (badge) {
            badge.innerText = count > 99 ? '99+' : count;
            badge.style.display = count > 0 ? 'inline-block' : 'none';
        }
    } catch (error) {
        // Silenzioso
    }
}

// ── DASHBOARD ──

async function refreshDashboard() {
    try {
        const [missioni, operatori, mezzi, richieste] = await Promise.all([
            visualizzaTutteLeMissioni(),
            operatoriDisponibili('true'),
            getTuttiMezzi(),
            visualizzaRichiesteFiltrate('ATTIVA', 0, 5)
        ]);

        const setStatText = (id, value) => {
            const el = document.getElementById(id);
            if (el) el.innerText = value;
        };

        // Missioni attive
        const missioniAttive = missioni ? missioni.filter(m => m.stato === 'IN_CORSO').length : 0;
        setStatText('stat-missioni', missioniAttive);

        // Operatori disponibili
        setStatText('stat-operatori', operatori ? operatori.length : 0);

        // Mezzi disponibili
        if (document.getElementById('stat-mezzi')) {
            const mezziDisp = mezzi ? mezzi.filter(m =>
                m.disponibile === true || m.disponibile === 'true' || m.disponibile === 1 || m.stato === 'DISPONIBILE'
            ).length : 0;
            setStatText('stat-mezzi', `${mezziDisp}/${mezzi ? mezzi.length : 0}`);
        }

        renderRichiesteFeed(richieste?.content || []);
        await updateGlobalBadges();
    } catch (error) {
        // Silenzioso
    }
}

function renderRichiesteFeed(lista) {
    const container = document.getElementById('requests-feed');
    if (!container) return;

    container.innerHTML = '';

    if (!lista || lista.length === 0) {
        container.innerHTML = '<div style="padding: 20px; color: var(--text-secondary); text-align: center;">Nessuna richiesta in attesa</div>';
        return;
    }

    lista.slice(0, 3).forEach(r => {
        const div = document.createElement('div');
        div.className = 'req-row status-new';
        div.innerHTML = `
            <span class="req-time"><i class="fas fa-clock"></i></span>
            <div class="req-info">
                <span class="req-desc">${r.nome_segnalante || r.nomeRichiedente || 'Anonimo'}</span>
                <span class="req-loc">${r.descrizione || 'Nessun dettaglio'}</span>
            </div>
            <a href="/admin/richieste" class="req-action"><i class="fas fa-chevron-right"></i></a>
        `;
        container.appendChild(div);
    });
}