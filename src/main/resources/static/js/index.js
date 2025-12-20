document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('richiestaForm');
    const locationStatus = document.getElementById('location-status');

    // Funzione per ottenere la posizione
    function getLocation() {
        if (navigator.geolocation) {
            locationStatus.textContent = 'Rilevamento posizione...';

            navigator.geolocation.getCurrentPosition(
                // Successo
                function(position) {
                    document.getElementById('latitudine').value = position.coords.latitude;
                    document.getElementById('longitudine').value = position.coords.longitude;
                    locationStatus.textContent = '✓ Posizione rilevata';
                    locationStatus.style.color = 'green';
                },
                // Errore
                function(error) {
                    let errorMsg = '';
                    switch(error.code) {
                        case error.PERMISSION_DENIED:
                            errorMsg = 'Permesso negato per la geolocalizzazione';
                            break;
                        case error.POSITION_UNAVAILABLE:
                            errorMsg = 'Posizione non disponibile';
                            break;
                        case error.TIMEOUT:
                            errorMsg = 'Timeout nella richiesta di posizione';
                            break;
                        default:
                            errorMsg = 'Errore sconosciuto';
                    }
                    locationStatus.textContent = '⚠ ' + errorMsg;
                    locationStatus.style.color = 'orange';
                    console.error('Errore geolocalizzazione:', error);
                },
                // Opzioni
                {
                    enableHighAccuracy: true,
                    timeout: 10000,
                    maximumAge: 0
                }
            );
        } else {
            locationStatus.textContent = '⚠ Geolocalizzazione non supportata';
            locationStatus.style.color = 'red';
        }
    }

    // Ottieni posizione al caricamento della pagina
    getLocation();

    // Previeni submit se la posizione non è stata ottenuta (opzionale)
    form.addEventListener('submit', function(e) {
        const lat = document.getElementById('latitudine').value;
        const lng = document.getElementById('longitudine').value;

        if (!lat || !lng) {
            e.preventDefault();
            alert('Attendere il rilevamento della posizione o consentire l\'accesso alla geolocalizzazione');
        }
    });
});
