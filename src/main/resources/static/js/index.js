// ===== GLOBAL VARIABLES =====
let locationObtained = false;
let isCaptchaVerified = false;

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
            switch(error.code) {
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

    if (!fileInput || !fileName) return;

    fileInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            const file = this.files[0];
            const sizeMB = (file.size / (1024 * 1024)).toFixed(2);
            fileName.textContent = `${file.name} (${sizeMB} MB)`;
        } else {
            fileName.textContent = "Seleziona un'immagine";
        }
    });
}

// ===== CUSTOM CAPTCHA LOGIC =====
function setupCustomCaptcha() {
    const captchaContainer = document.getElementById('custom-captcha');
    const checkbox = document.getElementById('captcha-checkbox');
    const spinner = document.getElementById('captcha-spinner');
    const tokenInput = document.getElementById('captcha-token');
    const errorMsg = document.getElementById('captcha-error-msg');

    if (!checkbox) return;

    checkbox.addEventListener('click', function() {
        if (isCaptchaVerified) return; // Già verificato

        // 1. Nascondi checkbox, mostra spinner
        checkbox.style.visibility = 'hidden';
        spinner.style.display = 'block';
        errorMsg.style.display = 'none'; // Nascondi eventuali errori precedenti

        // 2. Simula attesa di rete (tra 800ms e 1.5s)
        const randomDelay = Math.floor(Math.random() * 700) + 800;

        setTimeout(() => {
            // 3. Verifica completata
            spinner.style.display = 'none';
            checkbox.style.visibility = 'visible';

            // Aggiungi classe 'verified' al contenitore (cambia stile checkbox in check verde)
            captchaContainer.classList.add('verified');

            // Genera un token "finto" e salvalo
            const fakeToken = "verified_" + Date.now() + "_" + Math.random().toString(36).substr(2);
            tokenInput.value = fakeToken;

            isCaptchaVerified = true;
            console.log("Captcha verificato localmente. Token:", fakeToken);

        }, randomDelay);
    });
}

// ===== FORM VALIDATION & SUBMIT =====
function setupFormSubmit() {
    const form = document.getElementById('richiestaForm');
    const submitBtn = document.querySelector('.btn-submit');
    const errorMsg = document.getElementById('captcha-error-msg');

    if (!form || !submitBtn) {
        console.error('Form o submit button non trovato');
        return;
    }

    form.addEventListener('submit', async function(e) {
        e.preventDefault();

        // Check Local Captcha
        if (!isCaptchaVerified) {
            // Mostra errore sotto il captcha
            if (errorMsg) errorMsg.style.display = 'block';

            // Shake animation (opzionale)
            const captchaContainer = document.getElementById('custom-captcha');
            captchaContainer.style.borderColor = '#ff5252';
            setTimeout(() => captchaContainer.style.borderColor = '', 500);

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
            // formData.append('captchaToken', ...); // Già nel form come hidden input

            const response = await fetch('/richiesta', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                // Success
                await Swal.fire({
                    icon: 'success',
                    title: 'Richiesta Inviata!',
                    html: `
                        <p>La tua richiesta di soccorso è stata ricevuta.</p>
                        <p><strong>Controlla la tua mail</strong> per confermare la richiesta.</p>
                    `,
                    background: '#1a1a2e',
                    color: '#fff',
                    confirmButtonColor: '#4CAF50'
                });

                // Reset form
                form.reset();

                // Reset File Input Text
                const fileNameElement = document.getElementById('file-name');
                if (fileNameElement) fileNameElement.textContent = "Seleziona un'immagine";

                // Reset Captcha
                isCaptchaVerified = false;
                document.getElementById('custom-captcha').classList.remove('verified');
                document.getElementById('captcha-token').value = "";

                // Reset Location
                locationObtained = false;
                getLocation();

            } else {
                // Error from server
                let errorData = {};
                try {
                    errorData = await response.json();
                } catch (e) {
                    console.error('Errore parsing JSON:', e);
                }

                Swal.fire({
                    icon: 'error',
                    title: 'Errore Invio',
                    text: errorData.message || 'Si è verificato un errore. Riprova più tardi',
                    background: '#1a1a2e',
                    color: '#fff',
                    confirmButtonColor: '#FF4B2B'
                });
            }

        } catch (error) {
            console.error('Submit error:', error);

            Swal.fire({
                icon: 'error',
                title: 'Errore di Connessione',
                text: 'Impossibile contattare il server. Verifica la connessione',
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
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 SoccorsoWeb Index inizializzato');

    // Get user location
    getLocation();

    // Setup file input
    setupFileInput();

    // Setup Custom Captcha
    setupCustomCaptcha();

    // Setup form submission
    setupFormSubmit();
});
