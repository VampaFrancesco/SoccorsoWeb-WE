<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profilo - SoccorsoWeb</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- CSS -->
    <link rel="stylesheet" href="/css/admin.css">
    <link rel="stylesheet" href="/css/profilo.css">
</head>
<body>

<!-- SIDEBAR DINAMICA -->
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="logo-icon"><i class="fas fa-star-of-life"></i></div>
        <span class="logo-text">SoccorsoWeb</span>
    </div>

    <ul class="nav-links">
        <!-- Link Dashboard che cambia in base al ruolo -->
        <li><a href="${basePath!'/'}"><i class="fas fa-grid-2"></i> Dashboard</a></li>

        <!-- MENU DIFFERENZIATO -->
        <#if ruolo?? && ruolo == "ADMIN">
            <!-- VISTA AMMINISTRATORE -->
            <li><a href="/richieste"><i class="fas fa-bell"></i> Richieste</a></li>
            <li><a href="/missioni"><i class="fas fa-map-location-dot"></i> Missioni</a></li>
            <li><a href="/operatori"><i class="fas fa-users"></i> Personale</a></li>
            <li><a href="/mezzi"><i class="fas fa-ambulance"></i> Flotta</a></li>
            <li><a href="/materiali"><i class="fas fa-box-open"></i> Magazzino</a></li>
            <li class="spacer"></li>
            <li><a href="/registrazione"><i class="fas fa-user-plus"></i> Nuovi Utenti</a></li>

        <#else>
            <!-- VISTA OPERATORE (Default) -->
            <li><a href="/operatore/turni"><i class="fas fa-calendar-check"></i> I Miei Turni</a></li>
            <li><a href="/operatore/missioni"><i class="fas fa-truck-medical"></i> Le Mie Missioni</a></li>
            <li><a href="/operatore/protocolli"><i class="fas fa-book-medical"></i> Protocolli</a></li>
            <li class="spacer"></li>
        </#if>

        <!-- Link Profilo (attivo per entrambi) -->
        <li class="active"><a href="${basePath!'/'}/profilo"><i class="fas fa-cog"></i> Impostazioni</a></li>
    </ul>

    <div class="user-profile">
        <div class="user-avatar">${(nomeUtente!"U")?substring(0,1)}</div>
        <div class="user-details">
            <span class="name">${nomeUtente!"Ospite"}</span>
            <!-- Mostra il ruolo formattato -->
            <span class="role">${(ruolo == 'ADMIN')?then('Amministratore', 'Operatore')}</span>
        </div>
        <a href="/logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i></a>
    </div>
</aside>

<!-- CONTENUTO PRINCIPALE -->
<main class="main-content">

    <header class="top-header">
        <div class="header-title">
            <h1>Il Mio Profilo</h1>
            <p>Gestisci le tue informazioni personali e competenze</p>
        </div>
    </header>

    <div class="profile-grid">

        <!-- COLONNA SINISTRA: Card Utente -->
        <div class="profile-card">
            <div class="profile-cover"></div>
            <div class="profile-avatar-container">
                <div class="avatar-circle">${(nomeUtente!"U")?substring(0,1)}</div>
            </div>
            <div class="profile-info-center">
                <h2 id="display-fullname">Caricamento...</h2>
                <span class="role-badge">
                        <i class="fas fa-shield-alt"></i> ${(ruolo == 'ADMIN')?then('Admin', 'Volontario')}
                    </span>
            </div>
            <div class="profile-contacts">
                <div class="contact-item">
                    <i class="fas fa-envelope"></i>
                    <span id="display-email">...</span>
                </div>
                <div class="contact-item">
                    <i class="fas fa-phone"></i>
                    <span id="display-phone">...</span>
                </div>
            </div>
        </div>

        <!-- COLONNA DESTRA: Form Dati -->
        <div class="profile-details-card">
            <form id="profileForm">
                <!-- Sezione Anagrafica (Read Only) -->
                <h3 class="section-title"><i class="fas fa-user"></i> Anagrafica</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label>Nome</label>
                        <input type="text" id="nome" readonly class="form-control readonly">
                    </div>
                    <div class="form-group">
                        <label>Cognome</label>
                        <input type="text" id="cognome" readonly class="form-control readonly">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Data di Nascita</label>
                        <input type="date" id="data_nascita" readonly class="form-control readonly">
                    </div>
                    <div class="form-group">
                        <label>Indirizzo</label>
                        <input type="text" id="indirizzo" readonly class="form-control readonly">
                    </div>
                </div>

                <hr class="divider">

                <!-- Sezione Modificabile -->
                <h3 class="section-title text-accent"><i class="fas fa-edit"></i> Modifica Informazioni</h3>

                <div class="form-group">
                    <label for="info_extra">Informazioni Extra / Note</label>
                    <textarea id="info_extra" rows="4" class="form-control" placeholder="Aggiungi note..."></textarea>
                </div>

                <div class="form-group">
                    <label for="abilita">Abilità & Certificazioni</label>
                    <input type="text" id="abilita" class="form-control" placeholder="BLSD, PTC, ...">
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save">
                        <i class="fas fa-save"></i> Salva Modifiche
                    </button>
                </div>
            </form>
        </div>

    </div>
</main>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="/js/api.js"></script>
<script src="/js/profilo.js"></script>
</body>
</html>
