document.addEventListener('DOMContentLoaded', () => {
    const statusMsg = document.getElementById('status-msg');

    // 1. Piccola pausa per dare feedback visivo all'utente
    setTimeout(() => {
        statusMsg.innerText = "Rimozione token di sicurezza...";

        // 2. Pulizia totale delle memorie del browser
        // Questo rimuove 'authToken' e 'user' impostati nel tuo login.js
        localStorage.clear();
        sessionStorage.clear();

        statusMsg.innerText = "Reindirizzamento...";

        // 3. Opzionale: Chiamata al backend se hai una sessione server-side da invalidare
        // fetch('/logout-server-endpoint', { method: 'POST' });

        // 4. Torna alla login dopo che la barra di progresso è terminata (circa 2s)
        setTimeout(() => {
            window.location.href = '/login';
        }, 1200);

    }, 500);
});