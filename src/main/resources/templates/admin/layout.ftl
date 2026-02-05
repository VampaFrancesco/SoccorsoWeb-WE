<#macro pagina_admin titolo="Control Room" nomeUtente="Admin">
    <!DOCTYPE html>
    <html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${titolo} - SoccorsoWeb</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="/css/admin.css">
    </head>
    <body>

    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo-icon"><i class="fas fa-star-of-life"></i></div>
            <span class="logo-text">SoccorsoWeb</span>
        </div>

        <ul class="nav-links">
            <li><a href="/admin"><i class="fas fa-grid-2"></i> Dashboard</a></li>
            <li><a href="/admin/richieste"><i class="fas fa-bell"></i> Richieste <span class="badge-mini" id="sidebar-badge">0</span></a></li>
            <li><a href="/admin/missioni"><i class="fas fa-map-location-dot"></i> Missioni</a></li>
            <li><a href="/admin/operatori"><i class="fas fa-users"></i> Operatori</a></li>
            <li><a href="/admin/mezzi"><i class="fas fa-ambulance"></i> Mezzi</a></li>
            <li><a href="/admin/materiali"><i class="fas fa-box-open"></i> Materiali</a></li>
            <li class="spacer"></li>
            <li><a href="/admin/aggiungi-utente"><i class="fas fa-user-plus"></i> Nuovi Utenti</a></li>
            <li><a href="/admin/profilo"><i class="fas fa-cog"></i> Impostazioni</a></li>
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

    <main class="main-content">
        <header class="top-header">
            <div class="header-title">
                <h1>${titolo}</h1>
                <p id="current-date">Caricamento data...</p>
            </div>
            <div class="header-status">
                <span class="status-indicator online"><i class="fas fa-circle"></i> Sistema Operativo</span>
            </div>
        </header>

        <#-- Punto di inserimento per il contenuto specifico della pagina -->
        <#nested>
    </main>

    <script src="/js/api.js"></script>
    <script src="/js/admin/admin.js"></script>
    </body>
    </html>
</#macro>