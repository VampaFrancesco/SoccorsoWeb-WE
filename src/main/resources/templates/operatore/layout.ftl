<#macro pagina_operatore titolo="Pannello Operatore" nomeUtente="Operatore" extraHead="" extraScripts="">
    <!DOCTYPE html>
    <html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${titolo} - SoccorsoWeb</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="/css/operatore.css">
        ${extraHead}
    </head>
    <body>

    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo-icon"><i class="fas fa-star-of-life"></i></div>
            <span class="logo-text">SoccorsoWeb</span>
        </div>

        <ul class="nav-links">
            <li><a href="/operatore"><i class="fas fa-gauge-high"></i> <span>Dashboard</span></a></li>
            <li>
            </li>
            <li><a href="/operatore/missioni"><i class="fas fa-map-location-dot"></i> <span>Missioni</span></a></li>
            <li class="spacer"></li>
            <li><a href="/operatore/profilo"><i class="fas fa-user-gear"></i> <span>Profilo</span></a></li>
        </ul>

        <div class="user-profile">
            <div class="user-avatar">
                <#if loggedUser??>
                    ${(loggedUser.nome!"O")?substring(0,1)}${(loggedUser.cognome!"")?substring(0,1)}
                <#else>
                    ${(nomeUtente!"Operatore")?substring(0,1)}
                </#if>
            </div>
            <div class="user-details">
                <span class="name">
                    <#if loggedUser??>
                        ${loggedUser.nome!} ${loggedUser.cognome!}
                    <#else>
                        ${nomeUtente!"Operatore"}
                    </#if>
                </span>
                <span class="role">Operatore</span>
            </div>
            <a href="/auth/logout" class="logout-btn"><i class="fas fa-right-from-bracket"></i></a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div class="header-title">
                <h1>${titolo}</h1>
                <p>Gestione operativa Soccorso Web</p>
            </div>
        </header>

        <#nested>
    </main>

    <script src="/js/api.js"></script>
    <script src="/js/operatore/operatore.js"></script>
    ${extraScripts}
    </body>
    </html>
</#macro>
