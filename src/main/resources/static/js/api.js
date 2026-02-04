const API_BASE_URL = 'https://soccorsoweb-swa-production.up.railway.app';

async function apiCall(endpoint, method = 'GET', body = null, needsAuth = false) {
    const headers = {};

    // Aggiungi header JSON solo se NON è FormData
    if (!(body instanceof FormData)) {
        headers['Content-Type'] = 'application/json';
    }

    // Aggiungi token_autenticazione se richiesto
    if (needsAuth) {
        const token_autenticazione = localStorage.getItem('authToken');
        if (token_autenticazione) {
            headers['Authorization'] = `Bearer ${token_autenticazione}`;
        }
    }

    const options = {
        method,
        headers
    };

    if (body) {
        console.log('🚀 REQUEST DEBUG:');
        console.log('  URL:', `${API_BASE_URL}${endpoint}`);
        console.log('  Method:', method);
        console.log('  Headers:', headers);
        console.log('  Body Object:', body);
        console.log('  Body JSON:', JSON.stringify(body, null, 2));
        options.body = (body instanceof FormData) ? body : JSON.stringify(body);
    }

    try {
        const response = await fetch(`${API_BASE_URL}${endpoint}`, options);

        // Gestisci errori HTTP
        if (response.status === 401) {
            // token_autenticazione scaduto o non valido
            localStorage.clear();
            window.location.href = '/login';
            return null;
        }

        if (!response.ok) {
            const errorText = await response.text();
            let errorMsg = 'Errore nella richiesta';
            let errorDetails = null;

            console.error('HTTP Error:', response.status, errorText);

            try {
                const error = JSON.parse(errorText);
                errorMsg = error.detail || error.message || error.messaggio || error.error || errorMsg;
                errorDetails = error;
            } catch (e) {
                // Se non è JSON, usa il testo direttamente
                if (errorText && errorText.trim() !== '') {
                    errorMsg = errorText;
                }
            }

            // Aggiungi informazioni specifiche in base allo status code
            if (response.status === 500) {
                errorMsg = `Errore del server: ${errorMsg}`;
            } else if (response.status === 404) {
                errorMsg = 'Risorsa non trovata';
            } else if (response.status === 400) {
                errorMsg = errorMsg || 'Richiesta non valida';
            }

            const error = new Error(errorMsg);
            error.statusCode = response.status;
            error.details = errorDetails;
            throw error;
        }

        // Leggi il testo della risposta
        const responseText = await response.text();

        // Se la risposta è vuota, ritorna null
        if (!responseText || responseText.trim() === '') {
            console.warn('Risposta vuota dal server per:', endpoint);
            return null;
        }

        // Prova a parsare il JSON
        return JSON.parse(responseText);
    } catch (error) {
        console.error('API Error:', error);
        throw error;
    }
}

//API 1a
async function login(credenziali) {
    try {
        const response = await fetch(`${API_BASE_URL}/swa/open/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(credenziali)
        });

        // Leggi il body della risposta
        let data = null;
        const contentType = response.headers.get('content-type');

        if (contentType && contentType.includes('application/json')) {
            data = await response.json();
        }

        // Ritorna un oggetto che include lo status code
        return {
            status: response.status,
            ok: response.ok,
            ...data
        };

    } catch (error) {
        console.error('Errore nella chiamata login:', error);
        throw error;
    }
}
//API 2a
async function logout() {
    return await apiCall('/swa/open/auth/logout', 'POST', null, false);
}

//API 2
async function inserisciRichiestaSoccorso(richiesta) {
    return await apiCall('/swa/open/richieste', 'POST', richiesta, false);
}

//API 3 - Conferma Convalida (SPOSTATA PRIMA per logica)
async function convalidaRichiesta(token) {
    return await apiCall('/swa/open/richieste/conferma-convalida', 'POST',
        { token_convalida: token },  // ✅ CORRETTO
        false
    );
}

//API 4
async function visualizzaRichiesteFiltrate(stato, page = 0, size = 20) {
    return await apiCall(`/swa/api/richieste?stato=${stato}&page=${page}&size=${size}`, 'GET', null, true);
}

//API 4b - Tutte le Missioni
async function visualizzaTutteLeMissioni() {
    return await apiCall('/swa/api/missioni', 'GET', null, true);
}

//API 5 - Richieste Non Positive
async function visualizzaRichiesteNonPositive() {
    return await apiCall('/swa/api/richieste/non-positive', 'GET', null, true);
}

//API 6
async function operatoriDisponibili(valore) {
    return await apiCall(`/swa/api/operatori?disponibile=${valore}`, 'GET', null, true);
}

//API 7
async function inserimentoMissione(missione) {
    return await apiCall('/swa/api/missioni', 'POST', missione, true);
}

//API 8
async function chiudiMissione(id) {
    return await apiCall(`/swa/api/missioni/${id}/modifica-stato?nuovoStato=CHIUSA`, 'PATCH', null, true);
}

//API 9
async function annullaRichiestaSoccorso(id) {
    return await apiCall(`/swa/api/richieste/${id}/annullamento`, 'PATCH', null, true);
}

//API 10
async function dettagliMissione(id) {
    return await apiCall(`/swa/api/missioni/${id}`, 'GET', null, true);
}

//API 11
async function dettagliRichiestaSoccorso(id) {
    return await apiCall(`/swa/api/richieste/${id}`, 'GET', null, true);
}

//API 12
async function infoOperatore(id) {
    return await apiCall(`/swa/api/operatori/${id}`, 'GET', null, true);
}

//API 13
async function operatoInMissioni(id) {
    return await apiCall(`/swa/api/operatori/${id}/missioni`, 'GET', null, true);
}

//API 14 - Aggiorna Richiesta
async function aggiornaRichiesta(id, data) {
    return await apiCall(`/swa/api/richieste/${id}`, 'PATCH', data, true);
}

//API 15 - Aggiorna Missione
async function aggiornaMissione(id, data) {
    return await apiCall(`/swa/api/missioni/${id}`, 'PATCH', data, true);
}

//API 17 - Valuta Richiesta
async function valutaRichiesta(id, valutazione) {
    return await apiCall(`/swa/api/richieste/${id}/valutazione?valutazione=${valutazione}`, 'PATCH', null, true);
}

// PROFILO
// API 18 - Info Utente Corrente
async function getMyProfile() {
    return await apiCall('/swa/api/operatori/me', 'GET', null, true);
}
// API 19 - Aggiorna Profilo
async function updateMyProfile(datiAggiornati) {
    return await apiCall('/swa/api/operatori/me', 'PATCH', datiAggiornati, true);
}

// ADMIN
// API 20 - Mezzi
async function getTuttiMezzi() {
    return await apiCall('/swa/api/mezzi', 'GET', null, true);
}

async function creaMezzo(mezzo) {
    return await apiCall('/swa/api/mezzi', 'POST', mezzo, true);
}

async function eliminaMezzo(id) {
    return await apiCall(`/swa/api/mezzi/${id}`, 'DELETE', null, true);
}

// API 21 - Materiali
async function getTuttiMateriali() {
    return await apiCall('/swa/api/materiali', 'GET', null, true);
}

// API 22 - Gestione Utenti
async function registraNuovoUtente(datiUtente) {
    return await apiCall('/swa/api/auth/registrazione', 'POST', datiUtente, true);
}

// API 23
async function eliminaUtente(id) {
    return await apiCall(`/swa/api/operatori/${id}`, 'DELETE', null, true);
}

