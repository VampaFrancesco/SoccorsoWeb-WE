
document.addEventListener('DOMContentLoaded', async () => {
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token_convalida');

    // Nascondi il form no-JS (il JS gestirà tutto)
    const nojsForm = document.getElementById('nojs-form');
    if (nojsForm) nojsForm.style.display = 'none';

    if (!token) {
        // Se non c'è token, non fare nulla (il template FreeMarker gestisce già questo caso)
        return;
    }

    // Mostra lo spinner
    const loadingEl = document.getElementById('loading');
    if (loadingEl) {
        loadingEl.classList.remove('hidden');
        loadingEl.style.display = 'block';
    }

    try {
        const result = await convalidaRichiesta(token);

        nascondiLoading();

        if (result && result.success) {
            document.getElementById('success').classList.remove('hidden');
            document.getElementById('success').style.display = 'block';
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

// Nasconde lo spinner e mostra un messaggio di errore
function mostraErrore(titolo, messaggio) {
    nascondiLoading();
    document.getElementById('error-title').textContent = titolo;
    document.getElementById('error-message').textContent = messaggio;
    const errorEl = document.getElementById('error');
    errorEl.classList.remove('hidden');
    errorEl.style.display = 'block';
}

// Nasconde lo spinner di caricamento
function nascondiLoading() {
    const el = document.getElementById('loading');
    if (el) {
        el.classList.remove('loading-visible');
        el.classList.add('hidden');
        el.style.display = 'none';
    }
}
