// ===== GLOBAL VARIABLES =====
let captchaAnswer = 0;
let locationObtained = false;

// ===== CAPTCHA GENERATION =====
function generateCaptcha() {
    const num1 = Math.floor(Math.random() * 10) + 1;
    const num2 = Math.floor(Math.random() * 10) + 1;

    document.getElementById('num1').textContent = num1;
    document.getElementById('num2').textContent = num2;

    captchaAnswer = num1 + num2;

    // Reset captcha input
    document.getElementById('captcha').value = '';
}

// ===== GEOLOCATION =====
function getLocation() {
    const locationStatus = document.getElementById('location-status');
    const latInput = document.getElementById('latitudine');
    const lngInput = document.getElementById('longitudine');

    if (!navigator.geolocation) {
        locationStatus.className = 'location-status error';
        locationStatus.innerHTML = '<i class="fas fa-circle-xmark"></i><span>Geolocalizzazione non supportata dal browser</span>';
        return;
    }

    locationStatus.className = 'location-status loading';
    locationStatus.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Rilevamento posizione...</span>';

    navigator.geolocation.getCurrentPosition(
        // Success
        (position) => {
            latInput.value = position.coords.latitude;
            lngInput.value = position.coords.longitude;
            locationObtained = true;

            locationStatus.className = 'location-status success';
            locationStatus.innerHTML = '<i class="fas fa-circle-check"></i><span>Posizione rilevata correttamente</span>';
        },
        // Error
        (error) => {
            let errorMsg = '';
            switch (error.code) {
                case error.PERMISSION_DENIED:
                    errorMsg = 'Permesso negato - Abilita la geolocalizzazione';
                    break;
                case error.POSITION_UNAVAILABLE:
                    errorMsg = 'Posizione non disponibile';
                    break;
                case error.TIMEOUT:
                    errorMsg = 'Timeout - Riprova';
                    break;
                default:
                    errorMsg = 'Errore sconosciuto';
            }

            locationStatus.className = 'location-status error';
            locationStatus.innerHTML = `<i class="fas fa-triangle-exclamation"></i><span>${errorMsg}</span>`;

            console.error('Geolocation error:', error);
        },
        // Options
        {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 0
        }
    );
}

// ===== FILE INPUT FEEDBACK =====
function setupFileInput() {
    const fileInput = document.getElementById('foto');
    const fileName = document.getElementById('file-name');

    fileInput.addEventListener('change', function () {
        if (this.files && this.files[0]) {
            const file = this.files[0];
            const sizeMB = (file.size / (1024 * 1024)).toFixed(2);
            fileName.textContent = `${file.name} (${sizeMB} MB)`;
        } else {
            fileName.textContent = "Seleziona un'immagine";
        }
    });
}

// ===== FORM VALIDATION & SUBMIT =====
function setupFormSubmit() {
    const form = document.getElementById('richiestaForm');
    const submitBtn = document.querySelector('.btn-submit');

    form.addEventListener('submit', async function (e) {
        e.preventDefault();

        // Validate CAPTCHA
        const captchaInput = parseInt(document.getElementById('captcha').value);
        if (captchaInput !== captchaAnswer) {
            Swal.fire({
                icon: 'error',
                title: 'Verifica Fallita',
                text: 'La risposta al captcha non è corretta',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF4B2B'
            });
            generateCaptcha(); // Reset captcha
            return;
        }

        // Validate Location
        if (!locationObtained) {
            Swal.fire({
                icon: 'warning',
                title: 'Posizione Richiesta',
                text: 'Attendi il rilevamento della posizione o abilita la geolocalizzazione',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF4B2B'
            });
            return;
        }

        // Disable button and show loading
        const originalBtnHTML = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Invio in corso...';
        submitBtn.disabled = true;

        try {
            // Submit form
            const formData = new FormData(form);

            // Convert forcedly to JSON because backend requires application/json
            // and does not support multipart/form-data (so no file upload for now)
            const requestBody = {
                nome_segnalante: formData.get('nome_segnalante'),
                email_segnalante: formData.get('email_segnalante'),
                descrizione: formData.get('descrizione'),
                latitudine: parseFloat(formData.get('latitudine')),
                longitudine: parseFloat(formData.get('longitudine')),
                // Indirizzo è obbligatorio nel DTO ma non c'è nel form, usiamo le coordinate come placeholder
                indirizzo: `Posizione: ${formData.get('latitudine')}, ${formData.get('longitudine')}`,
                // Foto cannot be sent as backend expects JSON
                // foto_url: null 
            };

            // Chiamata all'API tramite la funzione dedicata
            await inserisciRichiestaSoccorso(requestBody);

            // Success
            await Swal.fire({
                icon: 'success',
                title: 'Richiesta Inviata!',
                html: `
                    <p>La tua richiesta di soccorso è stata ricevuta.</p>
                    <p><strong>Controlla la tua email</strong> per confermare la richiesta.</p>
                `,
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#4CAF50'
            });

            // Reset form
            form.reset();
            document.getElementById('file-name').textContent = "Seleziona un'immagine";
            generateCaptcha();
            locationObtained = false;
            getLocation(); // Re-get location

        } catch (error) {
            console.error('Submit error:', error);

            Swal.fire({
                icon: 'error',
                title: 'Errore',
                text: error.message || 'Si è verificato un errore durante l\'invio della richiesta.',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF4B2B'
            });
        } finally {
            // Re-enable button
            submitBtn.innerHTML = originalBtnHTML;
            submitBtn.disabled = false;
        }
    });
}

// ===== INIT ON DOM READY =====
document.addEventListener('DOMContentLoaded', function () {
    // Initialize CAPTCHA
    generateCaptcha();

    // Refresh CAPTCHA button
    document.getElementById('refresh-captcha').addEventListener('click', generateCaptcha);

    // Get user location
    getLocation();

    // Setup file input
    setupFileInput();

    // Setup form submission
    setupFormSubmit();
});
