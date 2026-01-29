<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Operatore - SoccorsoWeb</title>

    <!-- Font Outfit -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome per le icone -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- CSS Globale -->
    <link rel="stylesheet" href="/css/global.css">
    <!-- CSS Dashboard -->
    <link rel="stylesheet" href="/css/operatore.css">
</head>
<body>

<div class="dashboard-container">
    <div class="header">
        <h1>Pannello Operatore</h1>
        <p>Gestione operativa Soccorso Web</p>
    </div>

    <div class="menu-grid">
        <!-- Profilo -->
        <a href="/operatore/profilo" class="menu-card">
            <i class="fa-solid fa-user-astronaut"></i>
            <span>Profilo</span>
        </a>

        <!-- Richieste (con esempio badge notifiche) -->
        <a href="/operatore/richieste" class="menu-card">
            <div class="badge">3</div>
            <i class="fa-solid fa-bell"></i>
            <span>Richieste</span>
        </a>

        <!-- Missioni -->
        <a href="/operatore/missioni" class="menu-card">
            <i class="fa-solid fa-map-location-dot"></i>
            <span>Missioni</span>
        </a>

        <!-- Mezzi -->
        <a href="/operatore/mezzi" class="menu-card">
            <i class="fa-solid fa-truck-medical"></i>
            <span>Mezzi</span>
        </a>

        <!-- Materiali -->
        <a href="/operatore/materiali" class="menu-card">
            <i class="fa-solid fa-kit-medical"></i>
            <span>Materiali</span>
        </a>
    </div>

    <div class="logout-container">
        <a href="/logout" class="btn-logout">
            <i class="fa-solid fa-power-off"></i> Disconnetti
        </a>
    </div>
</div>

</body>
</html>
