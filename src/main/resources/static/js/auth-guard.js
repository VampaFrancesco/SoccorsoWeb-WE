/**
 * Auth Guard - Protegge le pagine riservate
 * Verifica che l'utente sia autenticato e abbia i permessi corretti
 */

(function() {
    'use strict';

    // Funzione per verificare se l'utente è autenticato
    function isAuthenticated() {
        const token = localStorage.getItem('authToken');
        return token !== null && token !== undefined && token !== '';
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
            console.warn('⚠️ Utente non autenticato. Reindirizzamento al login...');
            window.location.href = '/login?error=session';
            return false;
        }

        // Verifica ruolo
        if (!hasRole(requiredRole)) {
            console.warn('⚠️ Utente non autorizzato per questo ruolo. Richiesto:', requiredRole);
            window.location.href = '/error?message=unauthorized';
            return false;
        }

        console.log('✅ Autenticazione verificata. Ruolo:', getUserRole());
        return true;
    }

    // Esegui il controllo al caricamento della pagina
    document.addEventListener('DOMContentLoaded', function() {
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
