document.addEventListener('DOMContentLoaded', async () => {
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token_convalida'); // ✅ Parametro corretto dall'URL

    if (!token) {
        document.getElementById('loading').classList.remove('loading-visible');
        document.getElementById('loading').classList.add('hidden');
        document.getElementById('error-title').textContent = 'Link Non Valido';
        document.getElementById('error-message').textContent = 'Il token di convalida è mancante dall\'URL. Verifica di aver copiato correttamente l\'intero link dalla email.';
        document.getElementById('error').classList.remove('hidden');
        return;
    }

    try {
        console.log('🔍 Tentativo convalida con token:', token);
        const result = await convalidaRichiesta(token);

        console.log('📥 Risposta API:', result);
        console.log('📥 Tipo di risposta:', typeof result);
        console.log('📥 Contenuto JSON:', JSON.stringify(result, null, 2));

        document.getElementById('loading').classList.remove('loading-visible');
        document.getElementById('loading').classList.add('hidden');

        // Gestisci la risposta in base al formato dell'API
        // Controlla vari formati possibili di successo
        const isSuccess = result && (
            result.esito === 'successo' ||
            result.status === 'success' ||
            result.success === true ||
            result.messaggio?.toLowerCase().includes('successo') ||
            result.message?.toLowerCase().includes('success') ||
            result.message?.toLowerCase().includes('convalidata') ||
            // Se non ci sono errori espliciti e la risposta esiste, considera successo
            (result.error === undefined && result.errore === undefined && Object.keys(result).length > 0) ||
            // Se la risposta è null o vuota dopo una 200, è successo
            result === null
        );

        if (isSuccess) {
            console.log('✅ Convalida riuscita!');
            document.getElementById('success').classList.remove('hidden');
        } else {
            console.log('❌ Convalida fallita, mostro errore');
            // Estrai il messaggio di errore dalla risposta
            const errorTitle = result?.messaggio || result?.message || result?.error || 'Errore nella Convalida';
            const errorDetail = result?.dettaglio || result?.detail || result?.description || 'Il link potrebbe essere scaduto o non valido.';

            document.getElementById('error-title').textContent = errorTitle;
            document.getElementById('error-message').textContent = errorDetail;
            document.getElementById('error').classList.remove('hidden');
        }
    } catch (error) {
        console.error('❌ Errore validazione:', error);

        document.getElementById('loading').classList.remove('loading-visible');
        document.getElementById('loading').classList.add('hidden');

        // Estrai il messaggio di errore più specifico possibile
        let errorTitle = 'Errore di Connessione';
        let errorMessage = 'Impossibile completare la validazione. Verifica la tua connessione e riprova più tardi.';

        if (error.message) {
            const msg = error.message.toLowerCase();

            // Gestisci errori specifici
            if (msg.includes('token di convalida non valido') || msg.includes('token non valido')) {
                errorTitle = 'Token Non Valido';
                errorMessage = 'Il link di convalida è scaduto, non è valido o è già stato utilizzato. Potrebbe essere necessario richiedere un nuovo link di convalida.';
            } else if (msg.includes('scaduto')) {
                errorTitle = 'Token Scaduto';
                errorMessage = 'Il link di convalida è scaduto. Richiedi un nuovo link dalla home page.';
            } else if (msg.includes('già convalidata')) {
                errorTitle = 'Già Convalidata';
                errorMessage = 'Questa richiesta è già stata convalidata in precedenza.';
            } else if (!msg.includes('errore nella richiesta') && !msg.includes('errore del server')) {
                // Se c'è un messaggio specifico che non è generico, usalo
                errorMessage = error.message;
            } else if (msg.includes('errore del server:')) {
                // Estrai il messaggio dopo "Errore del server:"
                const specificMsg = error.message.split('Errore del server:')[1]?.trim();
                if (specificMsg) {
                    errorTitle = 'Errore di Validazione';
                    errorMessage = specificMsg;
                }
            }
        }

        document.getElementById('error-title').textContent = errorTitle;
        document.getElementById('error-message').textContent = errorMessage;
        document.getElementById('error').classList.remove('hidden');
    }
});





