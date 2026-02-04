<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout - SoccorsoWeb</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/logout.css">
</head>
<body>
<div class="logout-container">
    <div class="logout-box">
        <div class="icon-wrapper">
            <i class="fas fa-sign-out-alt fa-fade"></i>
        </div>
        <h1>Disconnessione...</h1>
        <p>Stiamo chiudendo la tua sessione in sicurezza.</p>

        <div class="loader-bar">
            <div class="progress"></div>
        </div>

        <div class="status-text" id="status-msg">Pulizia dati locali...</div>
    </div>
</div>

<script src="/js/logout.js"></script>
</body>
</html>