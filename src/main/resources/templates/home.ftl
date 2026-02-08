<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SoccorsoWeb - Richiesta Intervento</title>

    <!-- Font e Icone -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Libreria SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- CSS Locale -->
    <link rel="stylesheet" href="/css/home.css">
</head>
<body>

<!-- Sfondo Animato -->
<div class="bg-circle circle-1"></div>
<div class="bg-circle circle-2"></div>
<div class="bg-circle circle-3"></div>

<!-- Navigazione -->
<nav class="top-nav">
    <div class="logo">
        <i class="fa-solid fa-heart-pulse"></i> SoccorsoWeb
    </div>
    <a href="/auth/login" class="nav-login">
        <i class="fa-solid fa-user-lock"></i> Area Operatori
    </a>
</nav>

<!-- Contenitore Principale -->
<main class="main-container">

    <!-- Sezione Sinistra: Descrizione -->
    <section class="description-section">
        <div class="hero-content">
            <h1>
                <i class="fa-solid fa-shield-halved"></i>
                Soccorso Immediato
            </h1>
            <p class="subtitle">
                Il portale per le richieste di aiuto in caso di emergenza.
                Compilando il modulo verrà attivata la procedura di intervento più vicina alla tua posizione.
            </p>

            <div class="features">
                <div class="feature-item">
                    <i class="fa-solid fa-bolt"></i>
                    <span>Intervento rapido 24/7</span>
                </div>
                <div class="feature-item">
                    <i class="fa-solid fa-location-dot"></i>
                    <span>Geolocalizzazione automatica</span>
                </div>
                <div class="feature-item">
                    <i class="fa-solid fa-user-shield"></i>
                    <span>Sicuro e Affidabile</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Sezione Destra: Form -->
    <section class="form-section">
        <div class="form-card">
            <div class="form-header">
                <h2>Richiedi Aiuto</h2>
                <p>Compila il modulo sottostante</p>
            </div>

            <form id="richiestaForm" action="/richiesta" method="POST" enctype="multipart/form-data">

                <!-- Dati Segnalante -->
                <div class="form-group">
                    <label for="nome_segnalante"><i class="fa-solid fa-user"></i> Nome e Cognome</label>
                    <input type="text" id="nome_segnalante" name="nome_segnalante" class="form-control" placeholder="Il tuo nome" required>
                </div>

                <div class="form-group">
                    <label for="email_segnalante"><i class="fa-solid fa-envelope"></i> Email</label>
                    <input type="email" id="email_segnalante" name="email_segnalante" class="form-control" placeholder="Per la conferma" required>
                </div>

                <div class="form-group">
                    <label for="telefono_segnalante"><i class="fa-solid fa-phone"></i> Telefono (Opzionale)</label>
                    <input type="tel" id="telefono_segnalante" name="telefono_segnalante" class="form-control" placeholder="Per contatti urgenti">
                </div>

                <!-- Geolocalizzazione -->
                <div class="form-group location-display-group">
                    <label><i class="fa-solid fa-map-location-dot"></i> Posizione</label>

                    <!-- Status Bar -->
                    <div id="location-status" class="location-status">
                        <i class="fa-solid fa-spinner fa-spin"></i> Rilevamento posizione in corso...
                    </div>

                    <!-- Campi Nascosti -->
                    <input type="hidden" id="latitudine" name="latitudine">
                    <input type="hidden" id="longitudine" name="longitudine">
                    <input type="hidden" id="indirizzo" name="indirizzo">

                    <!-- Fallback Manuale -->
                    <div id="manual-address-field" class="manual-input-container" style="display: none;">
                        <span class="sub-label">Inserisci l'indirizzo manualmente:</span>
                        <div class="input-with-btn">
                            <input type="text" id="manual-address" class="form-control" placeholder="Es: Via Roma 1, Milano">
                            <button type="button" id="btn-verify-address" class="btn-verify">
                                <i class="fa-solid fa-search"></i> Cerca
                            </button>
                        </div>
                        <p class="manual-note">Inserisci città e via per ottenere le coordinate.</p>
                    </div>
                </div>

                <div class="form-group">
                    <label for="descrizione"><i class="fa-solid fa-comment-medical"></i> Descrizione Emergenza</label>
                    <textarea id="descrizione" name="descrizione" class="form-control" rows="4" placeholder="Descrivi brevemente l'accaduto..." required></textarea>
                </div>

                <!-- Upload Foto -->
                <div class="form-group">
                    <label><i class="fa-solid fa-camera"></i> Foto (Opzionale)</label>
                    <div class="file-input-wrapper">
                        <input type="file" id="foto" name="foto" class="file-input" accept="image/*">
                        <label for="foto" class="file-input-label">
                            <i class="fa-solid fa-cloud-arrow-up"></i>
                            <span id="file-name">Seleziona un'immagine</span>
                        </label>
                    </div>
                </div>

                <!-- Custom Captcha -->
                <div class="form-group captcha-group">
                    <div id="custom-captcha" class="custom-captcha-container">
                        <div class="captcha-checkbox-wrapper">
                            <input type="checkbox" id="captcha-checkbox" style="display:none;">
                            <div class="captcha-checkbox"></div>
                            <div id="captcha-spinner" class="captcha-spinner"></div>
                        </div>
                        <div class="captcha-text">Non sono un robot</div>
                        <div class="captcha-logo">
                            <i class="fa-solid fa-shield-cat"></i>
                            <span>SafeCheck</span>
                        </div>
                    </div>
                    <div id="captcha-error-msg" class="captcha-error">Verifica il captcha</div>
                    <input type="hidden" id="captcha-token" name="captcha_token">
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fa-solid fa-paper-plane"></i> INVIA RICHIESTA
                </button>

                <p class="privacy-note">
                    <i class="fa-solid fa-lock"></i> I tuoi dati sono trattati in modo sicuro.
                </p>
            </form>
        </div>
    </section>
</main>

<footer class="footer">
    &copy; 2026 SoccorsoWeb <span class="footer-separator">|</span> <a href="#">Privacy Policy</a>
</footer>

<!-- Script JS -->
<script src="/js/home.js"></script>
</body>
</html>