<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagina non trovata - SoccorsoWeb</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">

    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Custom CSS (Using home styles for consistency) -->
    <link rel="stylesheet" href="/css/home.css">
    <link rel="stylesheet" href="/css/404.css">

</head>
<body>

    <!-- Decorative backgrounds -->
    <div class="bg-circle circle-1" style="top: -10%; left: -10%;"></div>
    <div class="bg-circle circle-2" style="bottom: -10%; right: -10%;"></div>

    <div class="error-card">
        <i class="fas fa-exclamation-triangle error-icon"></i>
        <h1>Ops! Pagina non trovata</h1>
        <p>
            Sembra che la pagina che stai cercando non esista o sia stata spostata.<br>
            Stiamo verificando le tue credenziali per reindirizzarti alla pagina corretta...
        </p>
        
        <div class="loader"></div>
        <p style="margin-top: 1rem; font-size: 0.9rem; color: #888;">Reindirizzamento in corso...</p>
    </div>
</body>
<footer>
    <script  src="/js/auth-guard.js" rel="preload"></script>
    <script src="/js/error.js" rel="preload"></script>
</footer>
</html>
