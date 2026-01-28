<!DOCTYPE html>
<html lang="it">
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
</head>
<body>

<div class="result-container">
    <!-- Loading State -->
    <div id="loading" class="loading-visible">
        <div class="spinner"></div>
        <h2>Convalida in corso...</h2>
        <p>Attendere prego, stiamo verificando la tua email.</p>
    </div>

    <!-- Success State -->
    <div id="success" class="result-card success hidden">
        <div class="icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <h1>Email Convalidata!</h1>
        <p>✅ La tua richiesta di soccorso è stata attivata con successo.</p>
        <p>Le squadre di soccorso sono state allertate e interverranno il prima possibile.</p>
        <div class="error-actions">
            <a href="/" class="btn-home">
                <i class="fas fa-home"></i> Torna alla Home
            </a>
        </div>
    </div>

    <!-- Error State -->
    <div id="error" class="result-card error hidden">
        <div class="icon">
            <i class="fas fa-exclamation-circle"></i>
        </div>
        <h1 id="error-title">Errore nella Convalida</h1>
        <p id="error-message">Il link potrebbe essere scaduto o non valido. Verifica di aver copiato correttamente l'intero link dalla email.</p>
        <div class="error-actions">
            <a href="/" class="btn-home">
                <i class="fas fa-home"></i> Torna alla Home
            </a>
            <a href="mailto:supporto@soccorsoweb.it" class="btn-secondary">
                <i class="fas fa-envelope"></i> Contatta Supporto
            </a>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="/js/api.js"></script>
<script src="/js/validate-email.js"></script>

</body>
</html>