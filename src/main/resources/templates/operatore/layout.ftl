<#macro pagina_operatore titolo="Pannello Operatore">
    <!DOCTYPE html>
    <html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${titolo} - SoccorsoWeb</title>

        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="/css/global.css">
        <link rel="stylesheet" href="/css/operatore.css">
    </head>
    <body>

    <div class="dashboard-container">
        <div class="header">
            <h1>${titolo}</h1>
            <p>Gestione operativa Soccorso Web</p>
        </div>

        <#-- Punto di inserimento per il contenuto specifico della pagina -->
        <#nested>

        <div class="logout-container">
            <a href="/logout" class="btn-logout">
                <i class="fa-solid fa-power-off"></i> Disconnetti
            </a>
        </div>
    </div>

    <script src="/js/auth-guard.js"></script>
    <script src="/js/api.js"></script>
    <script src="/js/operatore_comune.js"></script>
    </body>
    </html>
</#macro>