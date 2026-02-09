document.addEventListener('DOMContentLoaded', () => {
    setTimeout(() => {
        // 1. Recupera i dati salvati nel browser
        const token = localStorage.getItem('authToken');
        const role = localStorage.getItem('userRole');
        if (token && role) {
            // 2. Decide dove mandarti in base al ruolo
            if (role === 'ADMIN') {
                window.location.href = '/admin';
            } else if (role === 'OPERATORE') {
                window.location.href = '/operatore';
            } else {
                window.location.href = '/home'; // Ruolo sconosciuto
            }
        } else {
            // 3. Se non sei loggato
            window.location.href = '/home';
        }
    }, 5000); // Aspetta 5 secondi prima di farlo
});