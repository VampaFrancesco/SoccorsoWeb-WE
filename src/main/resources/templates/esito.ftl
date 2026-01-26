<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Esito Convalida Email</title>
    <link rel="stylesheet" href="/css/esito.css">
</head>
<body>
<!-- Dynamic Background -->
<div class="bg-circle circle-1"></div>
<div class="bg-circle circle-2"></div>

<!-- Result Container -->
<div class="result-container">
    <div class="result-card">
        <#if esito == "successo">
            <div class="icon success">✓</div>
            <h1 class="success">Convalida Completata!</h1>
        <#else>
            <div class="icon error">✗</div>
            <h1 class="error">Convalida Fallita</h1>
        </#if>

        <p class="message">${messaggio}</p>

        <a href="/" class="btn-home">Torna alla Home</a>
    </div>
</div>
</body>
</html>
