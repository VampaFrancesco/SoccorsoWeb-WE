<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Flotta - SoccorsoWeb</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="/css/admin.css">
    <link rel="stylesheet" href="/css/mezzi.css">
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="logo-icon"><i class="fas fa-star-of-life"></i></div>
        <span class="logo-text">SoccorsoWeb</span>
    </div>
    <ul class="nav-links">
        <li><a href="/admin"><i class="fas fa-grid-2"></i> Dashboard</a></li>
        <li><a href="/richieste"><i class="fas fa-bell"></i> Richieste</a></li>
        <li><a href="/missioni"><i class="fas fa-map-location-dot"></i> Missioni</a></li>
        <li><a href="/operatori"><i class="fas fa-users"></i> Operatori</a></li>
        <li class="active"><a href="/admin/mezzi"><i class="fas fa-ambulance"></i> Mezzi</a></li>
        <li><a href="/materiali"><i class="fas fa-box-open"></i> Materiali</a></li>
        <li class="spacer"></li>
        <li><a href="/registrazione"><i class="fas fa-user-plus"></i> Nuovi Utenti</a></li>
        <li><a href="/admin/profilo"><i class="fas fa-cog"></i> Impostazioni</a></li>
    </ul>
    <div class="user-profile">
        <div class="user-avatar">${(nomeUtente!"A")?substring(0,1)}</div>
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
            <h1>Gestione Mezzi</h1>
            <p>Monitoraggio dei mezzi di soccorso</p>
        </div>
        <button class="btn-primary" onclick="openModal('modal-add')">
            <i class="fas fa-plus"></i> Nuovo Mezzo
        </button>
    </header>

    <div class="fleet-container">

        <!-- DISPONIBILI -->
        <div class="fleet-column">
            <div class="section-header">
                <h3 class="text-success"><i class="fas fa-check-circle"></i> Operativi</h3>
                <span class="badge" id="count-available">0</span>
            </div>
            <div id="list-available">
                <div class="loading-spinner"><i class="fas fa-spinner fa-spin"></i></div>
            </div>
        </div>

        <!-- NON DISPONIBILI -->
        <div class="fleet-column">
            <div class="section-header">
                <h3 class="text-danger"><i class="fas fa-ban"></i> In Servizio / Manutenzione</h3>
                <span class="badge" id="count-unavailable">0</span>
            </div>
            <div id="list-unavailable">
            </div>
        </div>

    </div>
</main>

<!-- MODALE AGGIUNTA MEZZO -->
<div id="modal-add" class="modal-overlay">
    <div class="modal-content">
        <!-- Header Colorato -->
        <div class="modal-header-fancy">
            <h2><i class="fas fa-ambulance"></i> Registra Nuovo Mezzo</h2>
            <i class="fas fa-times close-modal-white" onclick="closeModal('modal-add')"></i>
        </div>

        <div class="modal-body">
            <form id="formAddMezzo">

                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="form-label">Nome</label>
                        <div class="input-wrapper">
                            <i class="fas fa-tag"></i>
                            <input type="text" id="m_nome" class="form-control-icon" placeholder="es. Bravo 1" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Targa</label>
                        <div class="input-wrapper">
                            <i class="fas fa-barcode"></i>
                            <input type="text" id="m_targa" class="form-control-icon" placeholder="es. FX 000 YZ" required>
                        </div>
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="form-label">Tipologia</label>
                        <div class="input-wrapper">
                            <i class="fas fa-truck-medical"></i>
                            <select id="m_tipo" class="form-control-icon">
                                <option value="Ambulanza">Ambulanza</option>
                                <option value="Automedica">Automedica</option>
                                <option value="Elisoccorso">Elisoccorso</option>
                                <option value="Logistica">Trasporti organici</option>
                                <option value="Servizio">Auto di servizio</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Stato Iniziale</label>
                        <div class="input-wrapper">
                            <i class="fas fa-toggle-on"></i>
                            <select class="form-control-icon" disabled>
                                <option selected>Disponibile</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Dotazioni</label>
                    <div class="input-wrapper">
                        <i class="fas fa-clipboard-list" style="top: 20px;"></i>
                        <textarea id="m_descrizione" class="form-control-icon" placeholder="Specificare dotazioni particolari (es. Defibrillatore X Series, Ventilatore polmonare) o note meccaniche..."></textarea>
                    </div>
                </div>

                <div style="margin-top: 25px;">
                    <button type="submit" class="btn-submit-fancy">
                        <i class="fas fa-save"></i> Salva Veicolo
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODALE STORICO -->
<div id="modal-history" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header-fancy" style="background: linear-gradient(135deg, #374151 0%, #1f2937 100%);">
            <h2><i class="fas fa-history"></i> Storico Missioni</h2>
            <i class="fas fa-times close-modal-white" onclick="closeModal('modal-history')"></i>
        </div>

        <div class="modal-body">
            <p id="history-title" style="margin-bottom: 15px; font-weight: 600; color: #555;"></p>
            <div class="history-table-wrapper">
                <table class="modal-table history-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Data Inizio</th>
                        <th>Stato</th>
                        <th>Link</th>
                    </tr>
                    </thead>
                    <tbody id="history-body">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="/js/api.js"></script>
<script src="/js/mezzi.js"></script>

</body>
</html>
