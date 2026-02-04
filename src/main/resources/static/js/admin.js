document.addEventListener('DOMContentLoaded', async function() {
    console.log("Admin Dashboard Init...");

    // 1. Data corrente header
    const dateEl = document.getElementById('current-date');
    if (dateEl) {
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        dateEl.textContent = new Date().toLocaleDateString('it-IT', options);
    }

    // 2. Caricamento dati
    await refreshDashboard();
});

async function refreshDashboard() {
    try {
        // Esegue le chiamate API in parallelo
        const [missioni, operatori, mezzi, richieste] = await Promise.all([
            visualizzaTutteLeMissioni(),
            operatoriDisponibili('true'),
            getTuttiMezzi(),
            visualizzaRichiesteFiltrate('IN_ATTESA', 0, 5)
        ]);

        // Missioni In Corso
        const missioniAttive = missioni ? missioni.filter(m => m.stato === 'IN_CORSO' || m.stato === 'IN_ATTESA').length : 0;
        document.getElementById('stat-missioni').innerText = missioniAttive;

        // Operatori Disponibili
        const operatoriLiberi = operatori ? operatori.length : 0;
        document.getElementById('stat-operatori').innerText = operatoriLiberi;

        // Mezzi
        if (mezzi) {
            const mezziTotali = mezzi.length;
            const mezziDisp = mezzi.filter(m => m.stato === 'DISPONIBILE').length;
            document.getElementById('stat-mezzi').innerText = `${mezziDisp}/${mezziTotali}`;
        } else {
            document.getElementById('stat-mezzi').innerText = "0/0";
        }

        // AGGIORNAMENTO LISTA RICHIESTE
        renderRichiesteFeed(richieste ? richieste.content : []);

        // Badge Sidebar
        const numRichieste = richieste && richieste.totalElements ? richieste.totalElements : 0;
        const badge = document.getElementById('sidebar-badge');
        if (badge) badge.innerText = numRichieste > 99 ? '99+' : numRichieste;

    } catch (error) {
        console.error("Errore Dashboard:", error);
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
        div.style.cssText = "display:flex; gap:10px; padding:10px; border-bottom:1px solid #eee; align-items:center;";

        // Colore icona in base a gravità
        let colorClass = 'text-gray';
        if (r.codiceGravita === 'ROSSO') colorClass = 'text-danger';
        else if (r.codiceGravita === 'GIALLO') colorClass = 'text-warning';

        div.innerHTML = `
            <div class="${colorClass}" style="font-size:1.2rem;"><i class="fas fa-heart-pulse"></i></div>
            <div style="flex:1;">
                <div style="font-weight:600; font-size:0.95rem;">${r.nomeRichiedente || 'Anonimo'}</div>
                <div style="font-size:0.85rem; color:#666;">${r.descrizione || 'Nessun dettaglio'}</div>
            </div>
            <a href="/richieste/dettaglio/${r.id}" style="padding:4px 8px; background:#f0f0f0; border-radius:4px; text-decoration:none; color:#333; font-size:0.8rem;">Vedi</a>
        `;
        container.appendChild(div);
    });
}
