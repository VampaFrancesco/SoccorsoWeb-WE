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
    <link rel="stylesheet" href="/css/index.css">
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

    <!-- Left Section: Description -->
    <div class="description-section">
        <div class="hero-content">
            <h1>
                <i class="fas fa-heart-pulse"></i>
                ${descrizione_h2!"Soccorso Web"}
            </h1>
            <p class="subtitle">${descrizione_paragrafo!"Il portale per la gestione delle missioni di soccorso"}</p>

            <div class="features">
                <div class="feature-item">
                    <i class="fas fa-clock"></i>
                    <span>Risposta rapida 24/7</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-shield-halved"></i>
                    <span>Sicuro e affidabile</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-map-location-dot"></i>
                    <span>Geolocalizzazione automatica</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Section: Request Form -->
    <div class="form-section">
        <div class="form-card">
            <div class="form-header">
                <h2>Richiedi Soccorso</h2>
                <p>Compila il modulo per inviare una richiesta</p>
            </div>

            <form id="richiestaForm" action="/richiesta" method="post" enctype="multipart/form-data">

                <!-- Nome Segnalante -->
                <div class="form-group">
                    <label for="nome_segnalante">
                        <i class="fas fa-user"></i> Nome Completo
                    </label>
                    <input
                            type="text"
                            id="nome_segnalante"
                            name="nome_segnalante"
                            class="form-control"
                            placeholder="Mario Rossi"
                            required
                            minlength="3"
                    >
                </div>

                <!-- Email Segnalante -->
                <div class="form-group">
                    <label for="email_segnalante">
                        <i class="fas fa-envelope"></i> Indirizzo Email
                    </label>
                    <input
                            type="email"
                            id="email_segnalante"
                            name="email_segnalante"
                            class="form-control"
                            placeholder="mario.rossi@email.com"
                            required
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

                <!-- Geolocation Status -->
                <div class="location-status-container">
                    <div id="location-status" class="location-status loading">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Rilevamento posizione in corso...</span>
                    </div>
                </div>

                <!-- Hidden Location Fields -->
                <input type="hidden" id="latitudine" name="latitudine">
                <input type="hidden" id="longitudine" name="longitudine">

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

                <!-- NUOVO CAPTCHA CUSTOM -->
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
<script src="/js/index.js"></script>
<script src="/js/api.js"></script>
</body>
</html>
