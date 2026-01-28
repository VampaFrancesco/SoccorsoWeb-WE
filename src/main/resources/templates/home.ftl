<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${titolo!""} - SoccorsoWeb</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/home.css">
</head>
<body>

<!-- Ambient Background -->
<div class="bg-circle circle-1"></div>
<div class="bg-circle circle-2"></div>
<div class="bg-circle circle-3"></div>

<!-- Top Navigation -->
<nav class="top-nav">
    <div class="logo">
        <i class="fas fa-ambulance"></i>
        <span>SoccorsoWeb</span>
    </div>
    <a href="/login" class="nav-login">
        <i class="fas fa-user"></i> Accesso Operatori
    </a>
</nav>

<!-- Main Container -->
<div class="main-container">

    <!-- Description -->
    <div class="description-section">
        <div class="hero-content">
            <h1>
                <i class="fas fa-heart-pulse"></i>
                ${descrizione_h2!"Soccorso Web"}
            </h1>
            <p class="subtitle">Il portale per le richieste di aiuto in caso di emergenza!
                                Compilando il modulo verrà inviata una richiesta agli operatori che
                                organizzeranno in breve tempo un intervento</p>

            <div class="features">
                <div class="feature-item">
                    <i class="fas fa-clock"></i>
                    <span>Intervento rapido 24/7</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-shield-halved"></i>
                    <span>Sicuro e affidabile</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-map-location-dot"></i>
                    <span>Geolocalizzazione automatica</span>
                </div>
                <p class="subtitle">ATTENZIONE: dopo l'invio della richiesta verrà inoltrata una mail di conferma
                                                all'indirizzo di posta specificato</p>
            </div>
        </div>
    </div>

    <!-- Request Form -->
    <div class="form-section">
        <div class="form-card">
            <div class="form-header">
                <h2>Richiedi Soccorso</h2>
                <p>Compila il modulo per inviare una richiesta</p>
            </div>

            <form id="richiestaForm">

                <!-- Nome -->
                <div class="form-group">
                    <label for="nomesegnalante">
                        <i class="fas fa-user"></i> Nome e Cognome
                    </label>
                    <input
                            type="text"
                            id="nomesegnalante"
                            name="nomesegnalante"
                            class="form-control"
                            placeholder="Mario Rossi"
                            required
                            minlength="3"
                    >
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="emailsegnalante">
                        <i class="fas fa-envelope"></i> Email
                    </label>
                    <input
                            type="email"
                            id="emailsegnalante"
                            name="emailsegnalante"
                            class="form-control"
                            placeholder="mario.rossi@email.com"
                            required
                    >
                </div>

                <!-- Telefono -->
                <div class="form-group">
                    <label for="telefonosegnalante">
                        <i class="fas fa-phone"></i> Telefono (opzionale)
                    </label>
                    <input
                            type="tel"
                            id="telefonosegnalante"
                            name="telefonosegnalante"
                            class="form-control"
                            placeholder="333 1234567"
                    >
                </div>

                <!-- Descrizione -->
                <div class="form-group">
                    <label for="descrizione">
                        <i class="fas fa-message"></i> Descrizione Emergenza
                    </label>
                    <textarea
                            id="descrizione"
                            name="descrizione"
                            class="form-control"
                            rows="4"
                            placeholder="Descrivi brevemente la situazione..."
                            required
                            minlength="10"
                    ></textarea>
                </div>

                <!-- HIDDEN Coordinates + Indirizzo -->
                <input type="hidden" id="latitudine" name="latitudine">
                <input type="hidden" id="longitudine" name="longitudine">
                <input type="hidden" id="indirizzo" name="indirizzo">

                <!-- Location Display & Manual Input -->
                <div class="form-group location-display-group">
                    <label><i class="fas fa-map-pin"></i> Posizione Rilevata</label>

                    <!-- Status Bar -->
                    <div id="location-status" class="location-status loading">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Rilevamento GPS in corso...</span>
                    </div>

                    <!-- Manual Address Input-->
                    <div id="manual-address-field" class="manual-input-container" style="display: none;">
                        <label for="manual-address" class="sub-label">
                            Non riusciamo a trovarti. Scrivi il tuo indirizzo:
                        </label>
                        <div class="input-with-btn">
                            <input
                                    type="text"
                                    id="manual-address"
                                    class="form-control"
                                    placeholder="Es: Via Roma 10, Milano"
                            >
                            <button type="button" id="btn-verify-address" class="btn-verify">
                                <i class="fas fa-magnifying-glass-location"></i> Cerca
                            </button>
                        </div>
                        <p class="manual-note">Inserisci Via e Città</p>
                    </div>
                </div>

                <!-- Photo Upload -->
                <div class="form-group">
                    <label for="foto">
                        <i class="fas fa-camera"></i> Allega Foto (opzionale)
                    </label>
                    <div class="file-input-wrapper">
                        <input
                                type="file"
                                id="foto"
                                name="foto"
                                accept="image/*"
                                class="file-input"
                        >
                        <label for="foto" class="file-input-label">
                            <i class="fas fa-cloud-arrow-up"></i>
                            <span id="file-name">Seleziona un'immagine</span>
                        </label>
                    </div>
                </div>

                <!-- CAPTCHA CUSTOM -->
                <div class="form-group captcha-group">
                    <label>
                        <i class="fas fa-shield-halved"></i> Verifica di Sicurezza
                    </label>

                    <div class="custom-captcha-container" id="custom-captcha">
                        <div class="captcha-checkbox" id="captcha-checkbox"></div>
                        <span class="captcha-text">Non sono un robot</span>
                        <div class="captcha-logo">
                            <i class="fas fa-shield-cat"></i>
                            <small>SafeCheck</small>
                        </div>

                        <!-- Spinner nascosto -->
                        <div class="captcha-spinner" id="captcha-spinner"></div>
                    </div>

                    <!-- Messaggio di errore nascosto -->
                    <div class="captcha-error" id="captcha-error-msg">
                        Verifica obbligatoria
                    </div>

                    <!-- Input nascosto per il token -->
                    <input type="hidden" id="captcha-token" name="captchaToken">
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn-submit">
                    <i class="fas fa-paper-plane"></i> Invia Richiesta
                </button>

                <!-- Privacy Note -->
                <p class="privacy-note">
                    <i class="fas fa-lock"></i>
                    I tuoi dati sono al sicuro
                </p>
            </form>
        </div>
    </div>

</div>

<!-- Footer -->
<footer class="footer">
    <p>
        2026 SoccorsoWeb | Sviluppato per emergenze
    </p>
</footer>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- Custom JS -->
<script src="/js/api.js"></script>
<script src="/js/home.js"></script>

</body>
</html>
