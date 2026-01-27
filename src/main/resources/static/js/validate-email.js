document.addEventListener('DOMContentLoaded', async () => {
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');

    if (!token) {
        showError('Link non valido', 'Token mancante dall\'URL');
        return;
    }

    try {
        const result = await convalidaRichiesta(token);

        document.getElementById('loading').classList.remove('loading-visible');
        document.getElementById('loading').classList.add('hidden');

        if (result.esito === 'successo') {
            document.getElementById('success').classList.remove('hidden');
        } else {
            document.getElementById('error-title').textContent = result.messaggio || 'Errore sconosciuto';
            document.getElementById('error').classList.remove('hidden');
        }
    } catch (error) {
        console.error('Errore validazione:', error);
        document.getElementById('loading').classList.remove('loading-visible');
        document.getElementById('loading').classList.add('hidden');
        document.getElementById('error-title').textContent = 'Errore di Connessione';
        document.getElementById('error-message').textContent = 'Impossibile completare la validazione. Riprova più tardi.';
        document.getElementById('error').classList.remove('hidden');
    }
});