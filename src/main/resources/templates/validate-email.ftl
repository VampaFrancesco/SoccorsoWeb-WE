<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conferma Email - SoccorsoWeb</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="/css/validate-email.css" rel="stylesheet">
</head>
<body>
<div class="result-container">
    <!-- Loading -->
    <div id="loading" class="loading-visible">
        <div class="spinner"></div>
        <h2>Conferma in corso...</h2>
        <p>Stiamo verificando la tua richiesta di soccorso</p>
    </div>

    <!-- Success -->
    <div id="success" class="result-card success hidden">
        <div class="icon">✓</div>
        <h1>Convalida Completata!</h1>
        <p>La tua richiesta di soccorso è stata confermata con successo.</p>
        <p>I nostri operatori la prenderanno in carico al più presto.</p>
        <a href="/" class="btn-home">Torna alla Home</a>
    </div>

    <!-- Error -->
    <div id="error" class="result-card error hidden">
        <div class="icon">✗</div>
        <h1 id="error-title">Conferma Fallita</h1>
        <p id="error-message">Il link di conferma non è valido o è scaduto.</p>
        <div class="error-actions">
            <a href="/" class="btn-home">Home</a>
            <a href="/nuova-richiesta" class="btn-secondary">Nuova Richiesta</a>
        </div>
    </div>
</div>

<script src="/js/api.js"></script>
<script src="validate-email.js"></script>

</body>
</html>
