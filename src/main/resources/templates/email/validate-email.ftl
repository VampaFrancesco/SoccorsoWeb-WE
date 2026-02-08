<!DOCTYPE html>
<html lang="it" class="no-js">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Convalida Email - SoccorsoWeb</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/validate-email.css">

    <!-- JS Detection -->
    <script>
        document.documentElement.classList.remove('no-js');
        document.documentElement.classList.add('js-enabled');
    </script>
</head>
<body>

<div class="result-container">

    <#-- Loading State (solo con JS) -->
    <div id="loading" class="loading-visible">
        <div class="spinner"></div>
        <h2>Convalida in corso...</h2>
        <p>Attendere prego, stiamo verificando la tua email.</p>
    </div>

    <#-- Success State (mostrato se validationSuccess è true) -->
    <#if validationSuccess?? && validationSuccess>
        <div id="success" class="result-card success">
            <div class="icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h1>Email Convalidata!</h1>
            <p>✅ La tua richiesta di soccorso è stata attivata con successo.</p>
            <p>Le squadre di soccorso sono state allertate e interverranno il prima possibile.</p>
            <div class="error-actions">
                <a href="/home" class="btn-home">
                    <i class="fas fa-home"></i> Torna alla Home
                </a>
            </div>
        </div>
    </#if>

    <#-- Error State (mostrato se validationError è true) -->
    <#if validationError?? && validationError>
        <div id="error" class="result-card error">
            <div class="icon">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <h1 id="error-title">${errorTitle!"Errore nella Convalida"}</h1>
            <p id="error-message">
                ${errorMessage!"Il link potrebbe essere scaduto o non valido. Verifica di aver copiato correttamente l'intero link dalla email."}
            </p>
            <div class="error-actions">
                <a href="/home" class="btn-home">
                    <i class="fas fa-home"></i> Torna alla Home
                </a>
                <a href="mailto:supporto@soccorsoweb.it" class="btn-secondary">
                    <i class="fas fa-envelope"></i> Contatta Supporto
                </a>
            </div>
        </div>
    </#if>

    <#-- Fallback per utenti senza JS (mostra pending state) -->
    <noscript>
        <div class="result-card">
            <div class="icon">
                <i class="fas fa-hourglass-half"></i>
            </div>
            <h1>Convalida in Elaborazione</h1>
            <p>JavaScript è disabilitato nel tuo browser.</p>
            <p>La convalida è stata ricevuta dal server. Riceverai una email di conferma a breve.</p>
            <div class="error-actions">
                <a href="/home" class="btn-home">
                    <i class="fas fa-home"></i> Torna alla Home
                </a>
            </div>
        </div>
    </noscript>

    <#-- Messaggio generico se nessuna variabile è stata passata -->
    <#if !validationSuccess?? && !validationError??>
        <div class="result-card" style="display: block;">
            <div class="noscript-message">
                <i class="fas fa-info-circle"></i>
                JavaScript sembra essere disabilitato. La convalida funziona anche senza JS,
                ma potrebbero volerci alcuni secondi per elaborare la richiesta.
            </div>
            <div class="icon">
                <i class="fas fa-hourglass-half"></i>
            </div>
            <h1>Verifica in Corso</h1>
            <p>Stiamo verificando la tua richiesta...</p>
            <p>Se questa pagina non si aggiorna, <a href="/home" style="color: #FF4B2B;">clicca qui per tornare alla home</a>.</p>
        </div>
    </#if>

</div>

<!-- Scripts (progressive enhancement) -->
<script src="/js/api.js"></script>
<script src="/js/richiestasoccorso/validate-email.js"></script>

</body>
</html>