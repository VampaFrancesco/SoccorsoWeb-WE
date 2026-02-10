document.addEventListener('DOMContentLoaded', async () => {
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token_convalida');

    if (!token) {
        mostraErrore('Link Non Valido',
            'Il token di convalida è mancante dall\'URL. Verifica di aver copiato correttamente l\'intero link dalla email.');
        return;
    }

    try {
        const result = await convalidaRichiesta(token);

        nascondiLoading();

        // Verifica successo (la risposta contiene "success" come chiave)
        if (result && result.success) {
            document.getElementById('success').classList.remove('hidden');
        } else {
            mostraErrore(
                result?.error || 'Errore nella Convalida',
                'Si è verificato un problema durante la convalida.'
            );
        }
    } catch (error) {
        const msg = (error.message || '').toLowerCase();

        if (msg.includes('già') && msg.includes('convalidata')) {
            mostraErrore('Già Convalidata',
                'Questa richiesta è già stata convalidata in precedenza. Il link è utilizzabile una sola volta.');
        } else if (msg.includes('token') && (msg.includes('non valido') || msg.includes('utilizzato'))) {
            mostraErrore('Link Non Valido o Già Usato',
                'Il link di convalida non è valido oppure è già stato utilizzato. Ogni link può essere usato una sola volta.');
        } else {
            mostraErrore('Errore di Connessione',
                error.message || 'Impossibile completare la validazione. Verifica la tua connessione e riprova.');
        }
    }
});

/** Nasconde lo spinner e mostra un messaggio di errore */
function mostraErrore(titolo, messaggio) {
    nascondiLoading();
    document.getElementById('error-title').textContent = titolo;
    document.getElementById('error-message').textContent = messaggio;
    document.getElementById('error').classList.remove('hidden');
}

/** Nasconde lo spinner di caricamento */
function nascondiLoading() {
    const el = document.getElementById('loading');
    el.classList.remove('loading-visible');
    el.classList.add('hidden');
}
