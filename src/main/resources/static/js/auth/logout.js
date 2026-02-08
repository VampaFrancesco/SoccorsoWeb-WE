document.addEventListener('DOMContentLoaded', () => {
    const progressBar = document.getElementById('progress-bar');
    const statusText = document.getElementById('status-text');
    let width = 0;

    // Pulizia immediata dei dati sensibili
    localStorage.removeItem('authToken');
    localStorage.removeItem('userRole');
    localStorage.removeItem('userRoles');
    localStorage.removeItem('user');
    sessionStorage.clear();
    document.cookie = "jwt=; path=/; max-age=0; SameSite=Strict";

    // Animazione della barra di progresso
    const interval = setInterval(() => {
        if (width >= 100) {
            clearInterval(interval);
            statusText.innerText = "Sessione chiusa. A presto!";

            // Reindirizzamento finale
            setTimeout(() => {
                window.location.href = '/auth/login';
            }, 500);
        } else {
            width += 2;
            progressBar.style.width = width + '%';

            if (width === 40) statusText.innerText = "Pulizia cache locale...";
            if (width === 80) statusText.innerText = "Finalizzazione...";
        }
    }, 30);
});