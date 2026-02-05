<#import "layout.ftl" as layout>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="logo-icon"><i class="fas fa-star-of-life"></i></div>
        <span class="logo-text">SoccorsoWeb</span>
    </div>

    <ul class="nav-links">
        <li class="active"><a href="/admin"><i class="fas fa-grid-2"></i> Dashboard</a></li>
        <li><a href="/richieste"><i class="fas fa-bell"></i> Richieste <span class="badge-mini" id="sidebar-badge">0</span></a></li>
        <li><a href="/missioni"><i class="fas fa-map-location-dot"></i> Missioni</a></li>
        <li><a href="/operatori"><i class="fas fa-users"></i> Operatori</a></li>
        <li><a href="/mezzi"><i class="fas fa-ambulance"></i> Mezzi</a></li>
        <li><a href="/materiali"><i class="fas fa-box-open"></i> Materiali</a></li>
        <li class="spacer"></li>
        <li><a href="/registrazione"><i class="fas fa-user-plus"></i> Nuovi Utenti</a></li>
        <li><a href="/admin/profilo"><i class="fas fa-cog"></i> Profilo</a></li>
    </ul>

    <div class="user-profile">
        <div class="user-avatar">${(nomeUtente!"Admin")?substring(0,1)}</div>
        <div class="user-details">
            <span class="name">${nomeUtente!"Admin"}</span>
            <span class="role">Amministratore</span>
        </div>
        <a href="/logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i></a>
    </div>
</aside>

<!-- MAIN CONTENT -->
<main class="main-content">
    <header class="top-header">
        <div class="header-title">
            <h1>Panoramica Operativa</h1>
            <p id="current-date">Caricamento data...</p>
        </div>
        <div class="header-status">
            <span class="status-indicator online"><i class="fas fa-circle"></i> Sistema Operativo</span>
        </div>
    </header>

    <!-- DASHBOARD GRID -->
    <div class="dashboard-grid">

        <div class="widget widget-requests">
            <div class="widget-header">
                <h3><i class="fas fa-exclamation-circle text-danger"></i> Richieste in arrivo</h3>
                <a href="/admin/richieste" class="btn-text">Vedi tutte</a>
            </div>
            <div class="requests-feed" id="requests-feed">
                <div class="loading-spinner"><i class="fas fa-spinner fa-spin"></i></div>
            </div>
        </div>

        <div class="widget widget-stat">
            <div class="stat-icon bg-blue"><i class="fas fa-map-marker-alt"></i></div>
            <div class="stat-info">
                <span class="stat-value" id="stat-missioni">--</span>
                <span class="stat-label">Missioni in corso</span>
            </div>
            <a href="/admin/missioni" class="overlay-link"></a>
        </div>

        <div class="widget widget-stat">
            <div class="stat-icon bg-green"><i class="fas fa-user-clock"></i></div>
            <div class="stat-info">
                <span class="stat-value" id="stat-operatori">--</span>
                <span class="stat-label">Operatori Pronti</span>
            </div>
            <a href="/admin/operatori" class="overlay-link"></a>
        </div>

        <!-- WIDGET 4: PROFILO -->
        <div class="widget widget-stat">
            <div class="stat-icon bg-purple"><i class="fas fa-user"></i></div>
            <div class="stat-info">
                <span class="stat-value">Tu</span>
                <span class="stat-label">Profilo</span>
            </div>
            <a href="/admin/profilo" class="overlay-link"></a>
        </div>

        <!-- WIDGET 5: AZIONI RAPIDE -->
        <div class="widget widget-actions">
            <h3>Azioni Rapide</h3>
            <div class="action-buttons">
                <a href="/registrazione" class="btn-quick"><i class="fas fa-user-plus"></i> Registra Operatore</a>
                <a href="/materiali" class="btn-quick"><i class="fas fa-notes-medical"></i> Check Materiali</a>
            </div>
        </div>

        <!-- WIDGET 6: MEZZI -->
        <div class="widget widget-stat">
            <div class="stat-icon bg-orange"><i class="fas fa-ambulance"></i></div>
            <div class="stat-info">
                <span class="stat-value" id="stat-mezzi">--</span>
                <span class="stat-label">Mezzi Disponibili</span>
            </div>
            <a href="/admin/mezzi" class="overlay-link"></a>
        </div>

    </div>
</@layout.pagina_admin>