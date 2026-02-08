// ===== VARIABILI GLOBALI =====
let locationObtained = false;
let isCaptchaVerified = false;

// ===== GEOLOCALIZZAZIONE =====
function getLocation() {
    console.log('🌍 Tentativo di geolocalizzazione...');
    const statusDiv = document.getElementById('location-status');

    if (!navigator.geolocation) {
        console.warn('❌ Geolocalizzazione non supportata');
        statusDiv.innerHTML = '<i class="fa-solid fa-triangle-exclamation"></i> Browser non supporta la geolocalizzazione';
        statusDiv.style.color = '#ff6b6b';
        showManualEntry();
        return;
    }

    statusDiv.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Rilevamento posizione...';

    navigator.geolocation.getCurrentPosition(
        // SUCCESS
        async (position) => {
            console.log('✅ Posizione ottenuta:', position.coords);
            const lat = position.coords.latitude;
            const lon = position.coords.longitude;

            document.getElementById('latitudine').value = lat;
            document.getElementById('longitudine').value = lon;

            // Reverse Geocoding
            try {
                const address = await getAddressFromCoords(lat, lon);
                document.getElementById('indirizzo').value = address;
                statusDiv.innerHTML = `<i class="fa-solid fa-location-dot"></i> ${address}`;
                statusDiv.style.color = '#4CAF50';
                locationObtained = true;
            } catch (error) {
                console.error('Errore reverse geocoding:', error);
                statusDiv.innerHTML = `<i class="fa-solid fa-map-pin"></i> Coordinate: ${lat.toFixed(4)}, ${lon.toFixed(4)}`;
                statusDiv.style.color = '#4CAF50';
                document.getElementById('indirizzo').value = `Lat: ${lat}, Lon: ${lon}`;
                locationObtained = true;
            }
        },
        // ERROR
        (error) => {
            console.error('❌ Errore geolocalizzazione:', error);
            let errorMsg = '';

            switch(error.code) {
                case error.PERMISSION_DENIED:
                    errorMsg = 'Permesso negato. Inserisci l\'indirizzo manualmente.';
                    break;
                case error.POSITION_UNAVAILABLE:
                    errorMsg = 'Posizione non disponibile.';
                    break;
                case error.TIMEOUT:
                    errorMsg = 'Timeout rilevamento posizione.';
                    break;
                default:
                    errorMsg = 'Errore sconosciuto.';
            }

            statusDiv.innerHTML = `<i class="fa-solid fa-exclamation-circle"></i> ${errorMsg}`;
            statusDiv.style.color = '#ff6b6b';
            showManualEntry();
        },
        {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 0
        }
    );
}

// Mostra campo inserimento manuale
function showManualEntry() {
    document.getElementById('manual-address-field').style.display = 'block';
}

// Reverse Geocoding: Coordinate -> Indirizzo
async function getAddressFromCoords(lat, lon) {
    const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&zoom=18&addressdetails=1`;

    const response = await fetch(url);
    const data = await response.json();

    if (data && data.display_name) {
        return data.display_name;
    }
    throw new Error('Indirizzo non trovato');
}

// Geocoding: Indirizzo -> Coordinate
async function getCoordsFromAddress(address) {
    const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}&limit=1`;

    const response = await fetch(url);
    const data = await response.json();

    if (data && data.length > 0) {
        return {
            lat: parseFloat(data[0].lat),
            lon: parseFloat(data[0].lon),
            display_name: data[0].display_name
        };
    }
    throw new Error('Indirizzo non trovato');
}

// Setup inserimento manuale
function setupManualAddress() {
    const btnVerify = document.getElementById('btn-verify-address');
    const manualInput = document.getElementById('manual-address');
    const statusDiv = document.getElementById('location-status');

    if (!btnVerify) return;

    btnVerify.addEventListener('click', async () => {
        const address = manualInput.value.trim();

        if (!address) {
            Swal.fire({
                icon: 'warning',
                title: 'Attenzione',
                text: 'Inserisci un indirizzo valido',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF6B6B'
            });
            return;
        }

        btnVerify.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Ricerca...';
        btnVerify.disabled = true;

        try {
            const result = await getCoordsFromAddress(address);

            document.getElementById('latitudine').value = result.lat;
            document.getElementById('longitudine').value = result.lon;
            document.getElementById('indirizzo').value = result.display_name;

            statusDiv.innerHTML = `<i class="fa-solid fa-location-dot"></i> ${result.display_name}`;
            statusDiv.style.color = '#4CAF50';

            manualInput.value = '';
            document.getElementById('manual-address-field').style.display = 'none';
            locationObtained = true;

            Swal.fire({
                icon: 'success',
                title: 'Indirizzo trovato!',
                text: result.display_name,
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#4CAF50',
                timer: 3000
            });

        } catch (error) {
            Swal.fire({
                icon: 'error',
                title: 'Errore',
                text: 'Indirizzo non trovato. Riprova con un indirizzo più dettagliato.',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF6B6B'
            });
        } finally {
            btnVerify.innerHTML = '<i class="fa-solid fa-search"></i> Cerca';
            btnVerify.disabled = false;
        }
    });
}

// ===== FILE INPUT =====
function setupFileInput() {
    const fileInput = document.getElementById('foto');
    const fileName = document.getElementById('file-name');

    if (!fileInput) return;

    fileInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            fileName.textContent = this.files[0].name;
        } else {
            fileName.textContent = "Seleziona un'immagine";
        }
    });
}

// ===== CUSTOM CAPTCHA =====
function setupCustomCaptcha() {
    const captchaContainer = document.getElementById('custom-captcha');
    const checkbox = document.querySelector('.captcha-checkbox');
    const spinner = document.getElementById('captcha-spinner');
    const errorMsg = document.getElementById('captcha-error-msg');
    const tokenInput = document.getElementById('captcha-token');

    if (!captchaContainer || !checkbox) return;

    checkbox.addEventListener('click', function() {
        if (isCaptchaVerified) return;

        // Nascondi checkbox, mostra spinner
        checkbox.style.visibility = 'hidden';
        spinner.style.display = 'block';

        // Simula verifica (1-3 secondi)
        const delay = Math.random() * 2000 + 1000;

        setTimeout(() => {
            spinner.style.display = 'none';
            checkbox.style.visibility = 'visible';

            // Aggiungi check mark
            checkbox.innerHTML = '<i class="fa-solid fa-check" style="color: #009688; font-size: 20px;"></i>';
            captchaContainer.classList.add('verified');
            captchaContainer.style.borderColor = '#009688';

            isCaptchaVerified = true;
            errorMsg.style.display = 'none';

            // Token simulato
            tokenInput.value = 'captcha_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);

        }, delay);
    });
}

// ===== FORM SUBMIT =====
function setupFormSubmit() {
    const form = document.getElementById('richiestaForm');
    const submitBtn = document.querySelector('.btn-submit');

    if (!form) return;

    form.addEventListener('submit', async function(e) {
        e.preventDefault();

        // Validazioni
        if (!locationObtained) {
            Swal.fire({
                icon: 'warning',
                title: 'Posizione Mancante',
                text: 'Devi fornire la tua posizione (GPS o indirizzo manuale)',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF6B6B'
            });
            return;
        }

        if (!isCaptchaVerified) {
            document.getElementById('captcha-error-msg').style.display = 'block';
            Swal.fire({
                icon: 'warning',
                title: 'Verifica Captcha',
                text: 'Devi completare la verifica captcha',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF6B6B'
            });
            return;
        }

        // Disabilita bottone
        const originalBtnHTML = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Invio in corso...';
        submitBtn.disabled = true;

        try {
            // Qui puoi fare submit con fetch o FormData
            const formData = new FormData(form);

            // Esempio: submit normale
            Swal.fire({
                icon: 'success',
                title: 'Richiesta Inviata!',
                text: 'La tua richiesta di soccorso è stata ricevuta.',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#4CAF50'
            }).then(() => {
                form.reset();
                locationObtained = false;
                isCaptchaVerified = false;
                document.getElementById('custom-captcha').classList.remove('verified');
                document.getElementById('captcha-token').value = '';
                document.querySelector('.captcha-checkbox').innerHTML = '';
                document.getElementById('file-name').textContent = "Seleziona un'immagine";
                getLocation();
            });

        } catch (error) {
            console.error('Errore submit:', error);
            Swal.fire({
                icon: 'error',
                title: 'Errore',
                text: 'Si è verificato un errore. Riprova.',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF6B6B'
            });
        } finally {
            submitBtn.innerHTML = originalBtnHTML;
            submitBtn.disabled = false;
        }
    });
}

// ===== SMART NAVIGATION BAR =====
function setupSmartNav() {
    let lastScrollTop = 0;
    const topNav = document.querySelector('.top-nav');

    window.addEventListener('scroll', function() {
        let scrollTop = window.pageYOffset || document.documentElement.scrollTop;

        if (scrollTop <= 0) {
            topNav.classList.remove('nav-hidden');
            lastScrollTop = 0;
            return;
        }

        if (scrollTop > lastScrollTop) {
            topNav.classList.add('nav-hidden');
        } else {
            topNav.classList.remove('nav-hidden');
        }

        lastScrollTop = scrollTop;
    });
}

// ===== INIT =====
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 SoccorsoWeb inizializzato');

    getLocation();
    setupFileInput();
    setupCustomCaptcha();
    setupManualAddress();
    setupFormSubmit();
    setupSmartNav();
});