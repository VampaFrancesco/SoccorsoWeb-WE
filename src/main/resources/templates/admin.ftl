<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - SoccorsoWeb</title>

    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body>

<!-- Background -->
<div class="bg-circle circle-1"></div>
<div class="bg-circle circle-2"></div>

<!-- Top Bar with User Info -->
<nav class="top-nav">
    <div class="logo">
        <i class="fas fa-shield-halved"></i>
        <span>AdminPanel</span>
    </div>
    <div class="user-menu">
        <span>Benvenuto, Amministratore</span>
        <a href="/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Esci</a>
    </div>
</nav>

<!-- Real-time Ticker Banner -->
<div class="ticker-wrap">
    <div class="ticker-heading">Nuove Richieste:</div>
    <div class="ticker">
        <!-- Il JS riempirà questo div dinamicamente -->
        <div class="ticker-item" id="ticker-content">
            <span class="placeholder-text">In attesa di aggiornamenti...</span>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="dashboard-container">

    <header class="page-header">
        <h1>Panoramica Gestionale</h1>
        <p>Seleziona un modulo per iniziare a lavorare</p>
    </header>

    <div class="cards-grid">

        <!-- Card 1: Profilo -->
        <a href="/profilo" class="card">
            <div class="card-icon color-1"><i class="fas fa-user-gear"></i></div>
            <div class="card-content">
                <h3>Profilo</h3>
                <p>Gestisci i tuoi dati personali e credenziali.</p>
            </div>
        </a>

        <!-- Card 2: Registrazione -->
        <a href="/registrazione" class="card">
            <div class="card-icon color-2"><i class="fas fa-user-plus"></i></div>
            <div class="card-content">
                <h3>Registrazione</h3>
                <p>Crea nuovi account per operatori e staff.</p>
            </div>
        </a>

        <!-- Card 3: Richieste -->
        <a href="/richieste" class="card">
            <div class="card-icon color-3"><i class="fas fa-bell"></i></div>
            <div class="card-content">
                <h3>Richieste</h3>
                <p>Visualizza e smista le richieste di soccorso.</p>
            </div>
            <span class="notification-badge" id="req-count">0</span>
        </a>

        <!-- Card 4: Missioni -->
        <a href="/missioni" class="card">
            <div class="card-icon color-4"><i class="fas fa-map-location-dot"></i></div>
            <div class="card-content">
                <h3>Missioni</h3>
                <p>Monitora lo stato delle missioni attive.</p>
            </div>
        </a>

        <!-- Card 5: Mezzi -->
        <a href="/mezzi" class="card">
            <div class="card-icon color-5"><i class="fas fa-ambulance"></i></div>
            <div class="card-content">
                <h3>Mezzi</h3>
                <p>Gestione flotta e manutenzione veicoli.</p>
            </div>
        </a>

        <!-- Card 6: Materiali -->
        <a href="/materiali" class="card">
            <div class="card-icon color-6"><i class="fas fa-kit-medical"></i></div>
            <div class="card-content">
                <h3>Materiali</h3>
                <p>Inventario scorte e attrezzature mediche.</p>
            </div>
        </a>

        <!-- Card 7: Operatori -->
        <a href="/operatori" class="card">
            <div class="card-icon color-7"><i class="fas fa-users-viewfinder"></i></div>
            <div class="card-content">
                <h3>Operatori</h3>
                <p>Turni, disponibilità e anagrafica staff.</p>
            </div>
        </a>

    </div>
</div>

<!-- Scripts -->
<script src="/js/api.js"></script>
<script src="/js/admin.js"></script>
</body>
</html>
