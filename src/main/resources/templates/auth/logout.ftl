<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout - SoccorsoWeb</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/login.css">
    <link rel="stylesheet" href="/css/logout.css">
</head>
<body>
<div class="bg-circle circle-1"></div>
<div class="bg-circle circle-2"></div>

<div class="login-container">
    <div class="login-card logout-card">
        <div class="login-header">
            <div class="logout-icon-wrapper">
                <i class="fas fa-sign-out-alt"></i>
            </div>
            <h2>Disconnessione</h2>
            <p id="status-text">Chiusura sessione in corso...</p>
        </div>

        <div class="progress-container">
            <div class="progress-bar" id="progress-bar"></div>
        </div>

        <div class="logout-footer">
            <p>Sicurezza dei dati garantita</p>
        </div>
    </div>
</div>

<script src="/js/auth/logout.js"></script>
</body>
</html>