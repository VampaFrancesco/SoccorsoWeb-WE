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

    <#--
        ======= STATO SERVER-SIDE (no-JS) =======
        Se il controller ha già processato la convalida (POST),
        mostra direttamente il risultato.
    -->
    <#if convalidaEseguita?? && convalidaEseguita>

        <#-- Successo -->
        <#if convalidaSuccesso?? && convalidaSuccesso>
            <div class="result-card success">
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
                <p class="redirect-fallback">
                    <small>
                        <i class="fas fa-external-link-alt"></i>
                        <a href="/home">Se il redirect non andasse, clicca qui</a>
                    </small>
                </p>
            </div>
        <#else>
            <#-- Errore -->
            <div class="result-card error">
                <div class="icon">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                <h1>${convalidaErroreTitolo!'Errore nella Convalida'}</h1>
                <p>${convalidaErroreMessaggio!'Il link potrebbe essere scaduto o non valido.'}</p>
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

    <#else>
        <#--
            ======= STATO INIZIALE =======
            Il token è nell'URL ma non è ancora stato processato.
        -->

        <#if token_convalida?? && token_convalida?has_content>

            <#--
                NO-JS: Mostra un form POST con bottone di conferma.
                JS: Nasconde il form e mostra lo spinner automatico.
            -->

            <#-- Form POST per no-JS -->
            <div class="no-js-form-container" id="nojs-form">
                <div class="result-card info">
                    <div class="icon">
                        <i class="fas fa-envelope-circle-check"></i>
                    </div>
                    <h1>Conferma la tua Email</h1>
                    <p>Clicca il pulsante qui sotto per confermare la tua richiesta di soccorso.</p>

                    <form method="POST" action="/convalida">
                        <input type="hidden" name="token_convalida" value="${token_convalida}">
                        <button type="submit" class="btn-confirm">
                            <i class="fas fa-check"></i> Conferma Convalida
                        </button>
                    </form>

                    <p class="redirect-fallback">
                        <small>
                            <i class="fas fa-info-circle"></i>
                            Premendo il pulsante la tua richiesta verrà attivata.
                        </small>
                    </p>
                </div>
            </div>

            <#-- JS: Loading State (nascosto senza JS) -->
            <div id="loading" class="loading-visible js-only-block">
                <div class="spinner"></div>
                <h2>Convalida in corso...</h2>
                <p>Attendere prego, stiamo verificando la tua email.</p>
            </div>

            <#-- JS: Success State (Hidden Default) -->
            <div id="success" class="result-card success hidden js-only-block">
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
                <p class="redirect-fallback">
                    <small>
                        <i class="fas fa-external-link-alt"></i>
                        <a href="/home">Se il redirect non andasse, clicca qui</a>
                    </small>
                </p>
            </div>

            <#-- JS: Error State (Hidden Default) -->
            <div id="error" class="result-card error hidden js-only-block">
                <div class="icon">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                <h1 id="error-title">Errore nella Convalida</h1>
                <p id="error-message">
                    Il link potrebbe essere scaduto o non valido. Verifica di aver copiato correttamente l'intero link dalla email.
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

        <#else>
            <#-- Nessun token presente -->
            <div class="result-card error">
                <div class="icon">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                <h1>Link Non Valido</h1>
                <p>Il token di convalida è mancante dall'URL. Verifica di aver copiato correttamente l'intero link dalla email.</p>
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
    </#if>

</div>

<!-- Scripts (progressive enhancement) -->
<script src="/js/api.js"></script>
<script src="/js/richiestasoccorso/validate-email.js"></script>

</body>
</html>