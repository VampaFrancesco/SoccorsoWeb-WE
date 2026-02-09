<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SoccorsoWeb - Portale per richieste di soccorso in emergenza">
    <title>${titolo!} - SoccorsoWeb</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/home.css">
</head>
<body>

<div class="bg-circle circle-1"></div>
<div class="bg-circle circle-2"></div>
<div class="bg-circle circle-3"></div>

<nav class="top-nav">
    <div class="logo">
        <i class="fas fa-ambulance"></i>
        <span>SoccorsoWeb</span>
    </div>
    <div>
        <#if isLogged?? && isLogged>
            <span class="nav-user">
                    <i class="fas fa-user-circle"></i>
                    Benvenuto, ${username!}
                </span>
            <a href="/auth/logout" class="nav-login">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        <#else>
            <a href="/auth/login" class="nav-login">
                <i class="fas fa-user"></i> Accesso Operatori
            </a>
        </#if>
    </div>
</nav>

<div class="main-container">

    <div class="description-section">
        <div class="hero-content">
            <h1>
                <i class="fas fa-heart-pulse"></i>
                Soccorso Web
            </h1>
            <p class="subtitle">
                Il portale per le richieste di aiuto di carattere sanitario!
                Compilando il modulo verrà inviata una richiesta agli operatori
                che organizzeranno in breve tempo un intervento.
            </p>

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
            </div>
        </div>
    </div>

    <div class="form-section">
        <div class="form-card">
            <div class="form-header">
                <h2>Richiedi Soccorso</h2>
                <p>Compila il modulo per inviare una richiesta</p>
            </div>

            <form id="richiestaForm" method="POST" novalidate>

                <!-- NOME E COGNOME -->
                <div class="form-group">
                    <label for="nomesegnalante">
                        <i class="fas fa-user"></i> Nome e Cognome
                        <span class="required">*</span>
                    </label>
                    <input
                            type="text"
                            id="nomesegnalante"
                            name="nomeSegnalante"
                            class="form-control"
                            placeholder="Mario Rossi"
                            required
                            minlength="3"
                            maxlength="100">
                    <small class="form-hint">Inserisci nome e cognome completi</small>
                </div>

                <!-- EMAIL -->
                <div class="form-group">
                    <label for="emailsegnalante">
                        <i class="fas fa-envelope"></i> Email
                        <span class="required">*</span>
                    </label>
                    <input
                            type="email"
                            id="emailsegnalante"
                            name="emailSegnalante"
                            class="form-control"
                            placeholder="mario.rossi@email.com"
                            required>
                    <small class="form-hint">Riceverai una email di conferma</small>
                </div>

                <!-- TELEFONO (opzionale) -->
                <div class="form-group">
                    <label for="telefonosegnalante">
                        <i class="fas fa-phone"></i> Telefono
                        <span class="optional">(opzionale)</span>
                    </label>
                    <input
                            type="tel"
                            id="telefonosegnalante"
                            name="telefonoSegnalante"
                            class="form-control"
                            placeholder="+39 333 1234567">
                    <small class="form-hint">Formato: +39 333 1234567</small>
                </div>

                <!-- DESCRIZIONE EMERGENZA -->
                <div class="form-group">
                    <label for="descrizione">
                        <i class="fas fa-message"></i> Descrizione Emergenza
                        <span class="required">*</span>
                    </label>
                    <textarea
                            id="descrizione"
                            name="descrizione"
                            class="form-control"
                            rows="4"
                            placeholder="Descrivi brevemente la situazione di emergenza..."
                            required
                            minlength="10"
                            maxlength="1000"></textarea>
                    <small class="form-hint">Minimo 10 caratteri, massimo 1000</small>
                </div>

                <!-- CAMPI HIDDEN - COORDINATE E INDIRIZZO REALE -->
                <input type="hidden" id="latitudine" name="latitudine" value="">
                <input type="hidden" id="longitudine" name="longitudine" value="">
                <input type="hidden" id="indirizzo" name="indirizzo" value="">

                <!-- LOCATION / INDIRIZZO -->
                <div class="form-group location-display-group">
                    <label>
                        <i class="fas fa-map-pin"></i> Posizione
                        <span class="required">*</span>
                    </label>

                    <!-- Status Bar (geolocalizzazione) -->
                    <div id="location-status" class="location-status loading">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Rilevamento posizione in corso...</span>
                    </div>

                    <!-- Manual Address Input (nascosto finché non serve) -->
                    <div class="manual-input-container" id="manual-input">
                        <label for="manual-address" class="sub-label">
                            Indirizzo completo (Via, Città, CAP)
                        </label>

                        <div style="display: flex; gap: 8px;">
                            <input
                                    type="text"
                                    id="manual-address"
                                    class="form-control"
                                    placeholder="Es: Via Roma 10, 20121 Milano (MI)"
                            >
                            <button type="button" id="btn-verify-address" class="form-control" style="width: auto; background: var(--primary); color: white; border: none; cursor: pointer;">
                                <i class="fas fa-search-location"></i>
                            </button>
                        </div>

                        <small class="manual-note">
                            <i class="fas fa-info-circle"></i>
                            Inserisci l'indirizzo e clicca sulla lente per confermare la posizione
                        </small>
                    </div>
                </div>

                <!-- PHOTO UPLOAD (opzionale) -->
                <div class="form-group">
                    <label for="foto">
                        <i class="fas fa-camera"></i> Allega Foto
                        <span class="optional">(opzionale)</span>
                    </label>
                    <div class="file-input-wrapper">
                        <input
                                type="file"
                                id="foto"
                                name="foto"
                                accept="image/*"
                                class="file-input">
                        <label for="foto" class="file-input-label">
                            <i class="fas fa-cloud-arrow-up"></i>
                            <span id="file-name">Seleziona un'immagine</span>
                        </label>
                    </div>
                    <small class="form-hint">Dimensione massima: 5MB. Formati: JPG, PNG, WEBP</small>
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

                <button type="submit" class="btn-submit">
                    <i class="fas fa-paper-plane"></i> Invia Richiesta
                </button>


                <p class="privacy-note">
                    <i class="fas fa-lock"></i>
                    I tuoi dati sono al sicuro
                </p>

                <p class="required-note">
                    <span class="required">*</span> Campi obbligatori
                </p>

            </form>
        </div>
    </div>

</div>

<footer class="footer">
    <div class="footer-content">
        <p>
            2026 SoccorsoWeb |
            Sviluppato per emergenze sanitarie
    </div>
</footer>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Custom JS -->
<script src="/js/api.js"></script>
<script src="/js/home.js"></script>

</body>
</html>
