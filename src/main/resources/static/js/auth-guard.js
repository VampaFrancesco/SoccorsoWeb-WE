// Auth Guard

(function () {
    'use strict';

    // Funzione per verificare se l'utente è autenticato e il token è valido
    function isAuthenticated() {
        const token = localStorage.getItem('authToken');

        if (!token) return false;

        try {
            // Decodifica il payload del JWT
            const payloadBase64 = token.split('.')[1];
            if (!payloadBase64) return false;

            const payloadJson = atob(payloadBase64);
            const payload = JSON.parse(payloadJson);

            // Controlla la scadenza (exp è in secondi, Date.now() in millisecondi)
            if (payload.exp && (payload.exp * 1000 < Date.now())) {
                console.warn('Token scaduto.');
                localStorage.removeItem('authToken');
                localStorage.removeItem('userRole'); // Pulisce anche il ruolo
                return false;
            }

            return true;
        } catch (e) {
            console.error('Errore durante la verifica del token:', e);
            return false;
        }
    }

    // Funzione per ottenere il ruolo dell'utente
    function getUserRole() {
        const userRole = localStorage.getItem('userRole');
        return userRole || null;
    }

    // Funzione per verificare se l'utente ha il ruolo richiesto
    function hasRole(requiredRole) {
        const userRole = getUserRole();
        return userRole === requiredRole;
    }

    // Determina quale ruolo è richiesto in base all'URL corrente
    function getRequiredRole() {
        const path = window.location.pathname;

        if (path.startsWith('/admin')) {
            return 'ADMIN';
        } else if (path.startsWith('/operatore')) {
            return 'OPERATORE';
        }

        return null;
    }

    // Verifica l'autorizzazione
    function checkAuthorization() {
        const requiredRole = getRequiredRole();

        // Se non c'è un ruolo richiesto, permetti l'accesso
        if (!requiredRole) {
            return true;
        }

        // Verifica autenticazione
        if (!isAuthenticated()) {
            console.warn('⚠️ Utente non autenticato o token scaduto. Reindirizzamento al login...');
            window.location.href = '/auth/login?error=session';
            return false;
        }

        // Verifica ruolo
        if (!hasRole(requiredRole)) {
            console.warn('⚠️ Utente non autorizzato per questo ruolo. Richiesto:', requiredRole);
            window.location.href = '/error?message=unauthorized';
            return false;
        }

        console.log('Autenticazione verificata. Ruolo:', getUserRole());
        return true;
    }

    // Esegui il controllo al caricamento della pagina
    document.addEventListener('DOMContentLoaded', function () {
        checkAuthorization();
    });

    // Esporta le funzioni per uso esterno se necessario
    window.authGuard = {
        isAuthenticated: isAuthenticated,
        getUserRole: getUserRole,
        hasRole: hasRole,
        checkAuthorization: checkAuthorization
    };

})();
