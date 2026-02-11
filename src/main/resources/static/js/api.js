const API_BASE_URL = 'http://localhost:8080';

// ── CORE API CALL ──

async function apiCall(endpoint, method = 'GET', body = null, needsAuth = false) {
    const headers = {};

    if (!(body instanceof FormData)) {
        headers['Content-Type'] = 'application/json';
    }

    if (needsAuth) {
        const token = localStorage.getItem('authToken');
        if (token) {
            headers['Authorization'] = `Bearer ${token}`;
        }
    }

    const options = { method, headers };

    if (body) {
        options.body = (body instanceof FormData) ? body : JSON.stringify(body);
    }

    const response = await fetch(`${API_BASE_URL}${endpoint}`, options);

    if (response.status === 401) {
        localStorage.clear();
        window.location.href = '/auth/login';
        return null;
    }

    if (!response.ok) {
        const errorText = await response.text();
        let errorMsg = 'Errore nella richiesta';

        try {
            const error = JSON.parse(errorText);
            errorMsg = error.detail || error.message || error.messaggio || error.error || errorMsg;
        } catch (e) {
            if (errorText && errorText.trim() !== '') errorMsg = errorText;
        }

        if (response.status === 500) errorMsg = `Errore del server: ${errorMsg}`;
        else if (response.status === 404) errorMsg = errorMsg !== 'Errore nella richiesta' ? errorMsg : 'Risorsa non trovata';
        else if (response.status === 400) errorMsg = errorMsg || 'Richiesta non valida';

        const err = new Error(errorMsg);
        err.statusCode = response.status;
        throw err;
    }

    const responseText = await response.text();
    if (!responseText || responseText.trim() === '') return null;
    return JSON.parse(responseText);
}

// ── AUTENTICAZIONE ──

async function login(credenziali) {
    try {
        const response = await fetch(`${API_BASE_URL}/swa/open/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(credenziali)
        });

        let data = null;
        const contentType = response.headers.get('content-type');
        if (contentType && contentType.includes('application/json')) {
            data = await response.json();
        }

        return { status: response.status, ok: response.ok, ...data };
    } catch (error) {
        throw error;
    }
}

async function cambiaPassword(oldPassword, newPassword) {
    return await apiCall('/swa/api/auth/change-password', 'PUT', {
        old_password: oldPassword,
        new_password: newPassword
    }, true);
}

async function registraNuovoUtente(datiUtente) {
    return await apiCall('/swa/api/auth/registrazione', 'POST', datiUtente, true);
}

// ── RICHIESTE ──

async function dettagliRichiestaSoccorso(id) {
    return await apiCall(`/swa/api/richieste/${id}`, 'GET', null, true);
}

async function visualizzaRichiesteFiltrate(stato, page = 0, size = 10) {
    return await apiCall(`/swa/api/richieste?stato=${stato}&page=${page}&size=${size}`, 'GET', null, true);
}

// ── OPERATORI ──

async function operatoriDisponibili(valore) {
    return await apiCall(`/swa/api/operatori?disponibile=${valore}`, 'GET', null, true);
}

async function eliminaUtente(id) {
    return await apiCall(`/swa/api/operatori/${id}`, 'DELETE', null, true);
}

// ── MISSIONI ──

async function inserimentoMissione(payload) {
    return await apiCall('/swa/api/missioni', 'POST', payload, true);
}

async function visualizzaTutteLeMissioni() {
    return await apiCall('/swa/api/missioni', 'GET', null, true);
}

async function dettagliMissione(id) {
    return await apiCall(`/swa/api/missioni/${id}`, 'GET', null, true);
}

async function aggiornaMissione(id, data) {
    return await apiCall(`/swa/api/missioni/${id}`, 'POST', data, true);
}

async function operatoInMissioni(operatorId) {
    return await apiCall(`/swa/api/operatori/${operatorId}/missioni`, 'GET', null, true);
}

// ── MEZZI ──

async function getTuttiMezzi() {
    return await apiCall('/swa/api/mezzi', 'GET', null, true);
}

async function getMezziDisponibili() {
    return await apiCall('/swa/api/mezzi?disponibile=true', 'GET', null, true);
}

async function creaMezzo(payload) {
    return await apiCall('/swa/api/mezzi', 'POST', payload, true);
}

async function aggiornaMezzo(id, datiAggiornati) {
    return await apiCall(`/swa/api/mezzi/${id}`, 'PUT', datiAggiornati, true);
}

async function eliminaMezzo(id) {
    return await apiCall(`/swa/api/mezzi/${id}`, 'DELETE', null, true);
}

async function toggleAvailability(id) {
    return await apiCall(`/swa/api/mezzi/${id}/disponibilita`, 'PATCH', null, true);
}

async function getMissioniMezzo(id) {
    return await apiCall(`/swa/api/mezzi/${id}/missioni`, 'GET', null, true);
}

// ── MATERIALI ──

async function getTuttiMateriali() {
    return await apiCall('/swa/api/materiali', 'GET', null, true);
}

async function getMaterialiDisponibili() {
    return await apiCall('/swa/api/materiali?disponibile=true', 'GET', null, true);
}

async function creaMateriale(payload) {
    return await apiCall('/swa/api/materiali', 'POST', payload, true);
}

// ── PROFILO ──

async function getMyProfile() {
    return await apiCall('/swa/api/operatori/me', 'GET', null, true);
}

async function updateMyProfile(datiAggiornati) {
    return await apiCall('/swa/api/operatori/me', 'PATCH', datiAggiornati, true);
}

async function myMissioni() {
    return await apiCall('/swa/api/operatori/me/missioni', 'GET', null, true);
}

// ── ABILITÀ ──

async function getTutteAbilita() {
    return await apiCall('/swa/api/abilita', 'GET', null, true);
}

async function getAbilita() {
    return await apiCall('/swa/api/abilita', 'GET', null, true);
}

async function creaAbilita(nome, descrizione = '') {
    return await apiCall('/swa/api/abilita', 'POST', { nome, descrizione }, true);
}

// ── PATENTI ──

async function getTuttePatenti() {
    return await apiCall('/swa/api/patenti', 'GET', null, true);
}

async function creaPatente(tipo, descrizione = '') {
    return await apiCall('/swa/api/patenti', 'POST', { tipo, descrizione }, true);
}

// ── UTILS ──

function formatDate(dateInput) {
    if (!dateInput) return 'N/D';
    let date;
    if (Array.isArray(dateInput)) {
        date = new Date(dateInput[0], dateInput[1] - 1, dateInput[2], dateInput[3] || 0, dateInput[4] || 0, dateInput[5] || 0);
    } else {
        date = new Date(dateInput);
    }
    return isNaN(date.getTime()) ? 'N/D' : date.toLocaleString('it-IT', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' });
}
