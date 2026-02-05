<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aggiungi Utente - SoccorsoWeb</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link rel="stylesheet" href="/css/aggiungi-utente.css">
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="logo-icon"><i class="fas fa-star-of-life"></i></div>
        <span class="logo-text">SoccorsoWeb</span>
    </div>

    <ul class="nav-links">
        <li><a href="/admin"><i class="fas fa-grid-2"></i> Dashboard</a></li>
        <li><a href="/richieste"><i class="fas fa-bell"></i> Richieste</a></li>
        <li><a href="/operatori"><i class="fas fa-users"></i> Operatori</a></li>
        <li class="active"><a href="/aggiungi-utente"><i class="fas fa-user-plus"></i> Aggiungi Utente</a></li>
        <li class="spacer"></li>
        <li><a href="/logout" class="logout-btn-sidebar"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</aside>

<main class="main-content">
    <header class="top-header">
        <div class="header-title">
            <h1>Gestione Staff</h1>
            <p>Registrazione di un nuovo profilo operativo nel sistema</p>
        </div>
        <div class="header-status">
            <span class="status-indicator"><i class="fas fa-shield-halved"></i> Area Protetta</span>
        </div>
    </header>

    <div class="form-container">
        <div class="widget">
            <div class="widget-header">
                <h3><i class="fas fa-id-card"></i> Dati Nuovo Operatore</h3>
            </div>

            <form id="formAggiungiUtente" class="tech-form">
                <div class="form-grid-layout">
                    <div class="input-group">
                        <label>Nome</label>
                        <input type="text" name="nome" placeholder="Mario" required>
                    </div>
                    <div class="input-group">
                        <label>Cognome</label>
                        <input type="text" name="cognome" placeholder="Rossi" required>
                    </div>
                    <div class="input-group">
                        <label>Email Istituzionale</label>
                        <input type="email" name="email" placeholder="m.rossi@soccorsoweb.it" required>
                    </div>
                    <div class="input-group">
                        <label>Recapito Telefonico</label>
                        <input type="tel" name="telefono" placeholder="+39 333 1234567" required>
                    </div>
                    <div class="input-group password-field">
                        <label>Password Temporanea</label>
                        <div class="input-with-action">
                            <input type="text" id="passwordInput" name="password" required>
                            <button type="button" id="btnGeneratePass" class="btn-action-small" title="Genera Password">
                                <i class="fas fa-sync"></i>
                            </button>
                        </div>
                    </div>
                    <div class="input-group">
                        <label>Ruolo Sistema</label>
                        <select name="ruolo" required>
                            <option value="OPERATORE">Operatore (Standard)</option>
                            <option value="ADMIN">Amministratore (Full Access)</option>
                        </select>
                    </div>
                </div>

                <div class="form-footer">
                    <button type="reset" class="btn-secondary">Svuota Campi</button>
                    <button type="submit" id="btnSalva" class="btn-quick" style="background: var(--accent-primary); border: none;">
                        <i class="fas fa-user-check" style="color: white;"></i>
                        Salva Nuovo Utente
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<script src="/js/auth-guard.js"></script>
<script src="/js/api.js"></script>
<script src="/js/admin/aggiungi-utente.js"></script>
</body>
</html>