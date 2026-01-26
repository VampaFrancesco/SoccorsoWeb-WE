// ===== GLOBAL VARIABLES =====
let locationObtained = false;
let isCaptchaVerified = false;

// ===== GEOLOCATION LOGIC (With Address Conversion) =====
function getLocation() {
    const locationStatus = document.getElementById('location-status');
    const manualContainer = document.getElementById('manual-address-field');
    const latInput = document.getElementById('latitudine');
    const lngInput = document.getElementById('longitudine');

    if (!navigator.geolocation) {
        showManualEntry('Geolocalizzazione non supportata');
        return;
    }

    locationStatus.className = 'location-status loading';
    locationStatus.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Rilevamento GPS in corso...</span>';

    navigator.geolocation.getCurrentPosition(
        // 1. Successo GPS
        async (position) => {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;

            // Salva coordinate (nascoste)
            latInput.value = lat;
            lngInput.value = lng;
            locationObtained = true;

            // 2. Converti in Indirizzo (Reverse Geocoding)
            locationStatus.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Recupero indirizzo...</span>';

            try {
                const address = await getAddressFromCoords(lat, lng);
                locationStatus.className = 'location-status success';
                locationStatus.innerHTML = `<i class="fas fa-map-location-dot"></i><span>${address}</span>`;

                if (manualContainer) manualContainer.style.display = 'none';

            } catch (error) {
                // Fallback: mostra coordinate se reverse geocoding fallisce
                console.warn("Reverse geocoding fallito:", error);
                locationStatus.className = 'location-status success';
                locationStatus.innerHTML = `<i class="fas fa-location-crosshairs"></i><span>Posizione rilevata (${lat.toFixed(4)}, ${lng.toFixed(4)})</span>`;
            }
        },
        // Errore GPS
        (error) => {
            let errorMsg = 'Impossibile rilevare posizione';
            if (error.code === error.PERMISSION_DENIED) errorMsg = 'Permesso GPS negato';
            showManualEntry(errorMsg);
        },
        { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 }
    );

    function showManualEntry(msg) {
        console.warn('GPS Fallito:', msg);
        locationStatus.className = 'location-status error';
        locationStatus.innerHTML = `<i class="fas fa-circle-exclamation"></i><span>${msg}</span>`;
        if (manualContainer) manualContainer.style.display = 'block';
    }
}

// ===== NOMINATIM API (OpenStreetMap) =====

// 1. Coordinate -> Indirizzo
async function getAddressFromCoords(lat, lon) {
    const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&zoom=18&addressdetails=1`;

    // User-Agent obbligatorio per OSM
    const response = await fetch(url, {
        headers: { 'User-Agent': 'SoccorsoWeb-Client/1.0' }
    });

    if (!response.ok) throw new Error('Network response was not ok');

    const data = await response.json();

    // Formattazione Indirizzo
    const addr = data.address;
    const street = addr.road || addr.pedestrian || addr.street || '';
    const number = addr.house_number ? `, ${addr.house_number}` : '';
    const city = addr.city || addr.town || addr.village || addr.county || '';

    if (street && city) return `${street}${number}, ${city}`;
    if (data.display_name) return data.display_name.split(',').slice(0, 3).join(',');
    return `Lat: ${lat.toFixed(4)}, Lon: ${lon.toFixed(4)}`;
}

// 2. Indirizzo -> Coordinate (Per input manuale)
async function getCoordsFromAddress(addressQuery) {
    const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(addressQuery)}&limit=1`;

    const response = await fetch(url, {
        headers: { 'User-Agent': 'SoccorsoWeb-Client/1.0' }
    });

    const data = await response.json();
    if (data && data.length > 0) {
        return {
            lat: data[0].lat,
            lon: data[0].lon,
            displayName: data[0].display_name
        };
    }
    throw new Error('Indirizzo non trovato');
}

// ===== MANUAL ADDRESS HANDLER =====
function setupManualAddress() {
    const btnVerify = document.getElementById('btn-verify-address');
    const inputAddress = document.getElementById('manual-address');
    const locationStatus = document.getElementById('location-status');
    const latInput = document.getElementById('latitudine');
    const lngInput = document.getElementById('longitudine');

    if (!btnVerify) return;

    btnVerify.addEventListener('click', async () => {
        const query = inputAddress.value;
        if (!query || query.length < 3) {
            Swal.fire({
                icon: 'warning',
                title: 'Indirizzo troppo breve',
                text: 'Inserisci almeno città e via.',
                background: '#1a1a2e',
                color: '#fff'
            });
            return;
        }

        const originalBtnText = btnVerify.innerHTML;
        btnVerify.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        btnVerify.disabled = true;

        try {
            const result = await getCoordsFromAddress(query);

            // Successo: Aggiorna hidden inputs e UI
            latInput.value = result.lat;
            lngInput.value = result.lon;
            locationObtained = true;

            locationStatus.className = 'location-status success';
            locationStatus.innerHTML = `<i class="fas fa-check-circle"></i><span>Trovato: ${result.displayName.split(',').slice(0, 2).join(',')}</span>`;

        } catch (error) {
            Swal.fire({
                icon: 'error',
                title: 'Indirizzo non trovato',
                text: 'Prova a specificare meglio Città e Via',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF4B2B'
            });
        } finally {
            btnVerify.innerHTML = originalBtnText;
            btnVerify.disabled = false;
        }
    });
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
        if (isCaptchaVerified) return;

        checkbox.style.visibility = 'hidden';
        spinner.style.display = 'block';
        errorMsg.style.display = 'none';

        const randomDelay = Math.floor(Math.random() * 700) + 800;

        setTimeout(() => {
            spinner.style.display = 'none';
            checkbox.style.visibility = 'visible';

            captchaContainer.classList.add('verified');

            const fakeToken = "verified_" + Date.now() + "_" + Math.random().toString(36).substr(2);
            tokenInput.value = fakeToken;

            isCaptchaVerified = true;
            console.log("Captcha verificato localmente. Token:", fakeToken);

        }, randomDelay);
    });
}

// ===== FORM SUBMIT =====
function setupFormSubmit() {
    const form = document.getElementById('richiestaForm');
    const submitBtn = document.querySelector('.btn-submit');
    const errorMsg = document.getElementById('captcha-error-msg');

    if (!form || !submitBtn) return;

    form.addEventListener('submit', async function(e) {
        e.preventDefault();

        // 1. Check Captcha
        if (!isCaptchaVerified) {
            if (errorMsg) errorMsg.style.display = 'block';
            const captchaContainer = document.getElementById('custom-captcha');
            captchaContainer.style.borderColor = '#ff5252';
            setTimeout(() => captchaContainer.style.borderColor = '#d0d0d0', 500);
            return;
        }

        // 2. Check Location
        if (!locationObtained) {
            Swal.fire({
                icon: 'warning',
                title: 'Posizione Mancante',
                text: 'Attendi il GPS oppure cerca il tuo indirizzo manualmente',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF4B2B'
            });
            return;
        }

        // Disable button
        const originalBtnHTML = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Invio...';
        submitBtn.disabled = true;

        try {
            const formData = new FormData(form);
            const response = await fetch('/richiesta', { method: 'POST', body: formData });

            if (response.ok) {
                Swal.fire({
                    icon: 'success',
                    title: 'Richiesta Inviata',
                    html: '<p>Controlla la tua email per confermare.</p>',
                    background: '#1a1a2e', color: '#fff'
                });

                // RESET Form & UI
                form.reset();
                locationObtained = false;

                // Reset Captcha
                isCaptchaVerified = false;
                document.getElementById('custom-captcha').classList.remove('verified');
                document.getElementById('captcha-token').value = "";
                document.getElementById('captcha-checkbox').style.visibility = 'visible';

                // Reset File Input
                const fileNameElement = document.getElementById('file-name');
                if (fileNameElement) fileNameElement.textContent = "Seleziona un'immagine";

                // Re-get Location
                getLocation();

            } else {
                throw new Error('Errore server');
            }
        } catch (error) {
            Swal.fire({
                icon: 'error',
                title: 'Errore',
                text: 'Si è verificato un errore durante l\'invio',
                background: '#1a1a2e',
                color: '#fff'
            });
        } finally {
            submitBtn.innerHTML = originalBtnHTML;
            submitBtn.disabled = false;
        }
    });
}

// ===== INIT =====
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 SoccorsoWeb Index inizializzato');
    getLocation();
    setupFileInput();
    setupCustomCaptcha();
    setupManualAddress();
    setupFormSubmit();
});
