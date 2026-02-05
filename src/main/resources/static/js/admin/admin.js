document.addEventListener('DOMContentLoaded', async function() {
    console.log("Admin Interface Initialized");

    // 1. Gestione data corrente
    const dateEl = document.getElementById('current-date');
    if (dateEl) {
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        dateEl.textContent = new Date().toLocaleDateString('it-IT', options);
    }

    // 2. Evidenzia automaticamente il link attivo nella sidebar
    const currentPath = window.location.pathname;
    document.querySelectorAll('.nav-links a').forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            link.parentElement.classList.add('active');
        } else {
            link.parentElement.classList.remove('active');
        }
    });

    // 3. Caricamento dati dinamici
    // Se siamo nella dashboard, carica i widget completi
    if (currentPath === '/admin' || currentPath === '/admin/') {
        await refreshDashboard();
    } else {
        // In altre pagine aggiorna solo i badge globali
        updateGlobalBadges();
    }
});

async function refreshDashboard() {
    try {
        // Chiamate API in parallelo definite in api.js
        const [missioni, operatori, mezzi, richieste] = await Promise.all([
            visualizzaTutteLeMissioni(),
            operatoriDisponibili('true'),
            getTuttiMezzi(),
            visualizzaRichiesteFiltrate('ATTIVA', 0, 5)
        ]);

        // Aggiornamento contatori widget
        if (document.getElementById('stat-missioni'))
            document.getElementById('stat-missioni').innerText = missioni ? missioni.filter(m => m.stato === 'IN_CORSO').length : 0;

        if (document.getElementById('stat-operatori'))
            document.getElementById('stat-operatori').innerText = operatori ? operatori.length : 0;

        if (document.getElementById('stat-mezzi')) {
            const mezziDisp = mezzi ? mezzi.filter(m => m.stato === 'DISPONIBILE').length : 0;
            document.getElementById('stat-mezzi').innerText = `${mezziDisp}/${mezzi ? mezzi.length : 0}`;
        }

        // Renderizza feed richieste (massimo 3)
        renderRichiesteFeed(richieste ? richieste.content : []);

        // Aggiorna badge sidebar
        updateSidebarBadge(richieste ? richieste.totalElements : 0);

    } catch (error) {
        console.error("Errore nel caricamento dati dashboard:", error);
    }
}

function updateSidebarBadge(count) {
    const badge = document.getElementById('sidebar-badge');
    if (badge) {
        badge.innerText = count > 99 ? '99+' : count;
        badge.style.display = count > 0 ? 'inline-block' : 'none';
    }
}

function renderRichiesteFeed(listaRichieste) {
    const container = document.getElementById('requests-feed');
    if (!container) return;
    container.innerHTML = '';

    if (!listaRichieste || listaRichieste.length === 0) {
        container.innerHTML = '<div style="padding:10px; color:#888;">Nessuna richiesta in attesa</div>';
        return;
    }

    listaRichieste.slice(0, 3).forEach(r => {
        const div = document.createElement('div');
        div.className = "feed-item";
        div.style.cssText = "display:flex; gap:10px; padding:10px; border-bottom:1px solid #eee; align-items:center;";

        let colorClass = r.codiceGravita === 'ROSSO' ? 'text-danger' : (r.codiceGravita === 'GIALLO' ? 'text-warning' : 'text-gray');

        div.innerHTML = `
            <div class="${colorClass}" style="font-size:1.2rem;"><i class="fas fa-heart-pulse"></i></div>
            <div style="flex:1;">
                <div style="font-weight:600; font-size:0.95rem;">${r.nomeRichiedente || 'Anonimo'}</div>
                <div style="font-size:0.85rem; color:#666;">${r.descrizione || 'Nessun dettaglio'}</div>
            </div>
            <a href="/admin/richieste/${r.id}" class="btn-small">Vedi</a>
        `;
        container.appendChild(div);
    });
}