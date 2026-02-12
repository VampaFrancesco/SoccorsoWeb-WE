<!DOCTYPE html>
<html lang="it" class="no-js">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SoccorsoWeb - Portale per richieste di soccorso in emergenza">
    <title>${titolo!} - SoccorsoWeb</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" media="print" onload="this.media='all'">

    <!-- JS detection: rimuove no-js e aggiunge js-enabled -->
    <script>
        document.documentElement.classList.remove('no-js');
        document.documentElement.classList.add('js-enabled');
    </script>
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

            <!-- Messaggi di successo/errore dal server (no-JS fallback) -->
            <#if successMessage??>
                <div class="server-message server-success">
                    <i class="fas fa-check-circle"></i>
                    <div>
                        <strong>Richiesta Inviata!</strong>
                        <p>${successMessage}</p>
                    </div>
                </div>
            </#if>
            <#if errorMessage??>
                <div class="server-message server-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <div>
                        <strong>Errore</strong>
                        <p>${errorMessage}</p>
                    </div>
                </div>
            </#if>

            <!--
                Progressive Enhancement:
                - action="/richiesta-soccorso" → funziona senza JS (POST standard)
                - enctype="multipart/form-data" → per upload foto senza JS
                - Il JS sovrascriverà il submit con AJAX quando disponibile
            -->
            <form id="richiestaForm" method="POST" action="/richiesta-soccorso" enctype="multipart/form-data">

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

                <!-- COORDINATE HIDDEN (popolate solo da JS/GPS) -->
                <input type="hidden" id="latitudine" name="latitudine" value="">
                <input type="hidden" id="longitudine" name="longitudine" value="">

                <!-- POSIZIONE / INDIRIZZO -->
                <div class="form-group location-display-group">
                    <label for="indirizzo">
                        <i class="fas fa-map-pin"></i> Posizione
                        <span class="required">*</span>
                    </label>

                    <!--
                        Status Bar GPS: visibile SOLO con JS (nascosta via CSS con .no-js)
                        JS la usa per mostrare stato geolocalizzazione
                    -->
                    <div id="location-status" class="location-status js-only-block">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Rilevamento posizione in corso...</span>
                    </div>

                    <!--
                        Campo indirizzo manuale: SEMPRE VISIBILE senza JS.
                        Con JS, viene nascosto se GPS ha successo.
                    -->
                    <div class="manual-input-container" id="manual-input">
                        <label for="indirizzo" class="sub-label">
                            Indirizzo completo (Via, Città, CAP)
                        </label>

                        <div class="address-input-row">
                            <input
                                    type="text"
                                    id="indirizzo"
                                    name="indirizzo"
                                    class="form-control"
                                    placeholder="Es: Via Roma 10, 20121 Milano (MI)"
                                    required>

                            <!-- Bottone GPS: visibile SOLO con JS -->
                            <button type="button" id="btn-gps" class="btn-gps js-only-inline" title="Rileva posizione GPS">
                                <i class="fas fa-location-crosshairs"></i>
                            </button>

                            <!-- Bottone verifica indirizzo: visibile SOLO con JS -->
                            <button type="button" id="btn-verify-address" class="btn-verify js-only-inline" title="Verifica indirizzo">
                                <i class="fas fa-search-location"></i>
                            </button>
                        </div>

                        <small class="form-hint">
                            <i class="fas fa-info-circle"></i>
                            <span class="no-js-hint">Inserisci l'indirizzo completo del luogo dell'emergenza</span>
                            <span class="js-hint js-only-inline">Usa il GPS oppure inserisci l'indirizzo e verifica con la lente</span>
                        </small>
                    </div>
                </div>

                <!-- PHOTO UPLOAD -->
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

                <!--
                    ======= CAPTCHA =======
                    Doppio sistema:
                    1. NO-JS: Domanda matematica generata server-side (visibile senza JS)
                    2. JS: Captcha custom interattivo (visibile solo con JS)
                -->

                <!-- CAPTCHA NO-JS: Domanda di sicurezza server-side -->
                <div class="form-group captcha-group no-js-block" id="captcha-nojs">
                    <label for="captchaRisposta">
                        <i class="fas fa-shield-halved"></i> Verifica di Sicurezza
                    </label>
                    <div class="captcha-question">
                        <span class="captcha-math">Quanto fa <strong>${captchaDomanda!}</strong>?</span>
                        <input
                                type="text"
                                id="captchaRisposta"
                                name="captchaRisposta"
                                class="form-control captcha-input"
                                placeholder="Inserisci la risposta"
                                required
                                autocomplete="off"
                                inputmode="numeric">
                    </div>
                    <!-- Token nascosto per verificare server-side quale domanda era -->
                    <input type="hidden" name="captchaId" value="${captchaId!}">
                </div>

                <!-- CAPTCHA JS: Custom interattivo (nascosto senza JS via CSS) -->
                <div class="form-group captcha-group js-only-block" id="captcha-js-wrapper">
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

                    <!-- Input nascosto per il token JS -->
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

<!-- SweetAlert2 (solo per JS) -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11" defer></script>

<!-- Custom JS -->
<script src="/js/api.js" defer></script>
<script src="/js/home.js" defer></script>

</body>
</html>
