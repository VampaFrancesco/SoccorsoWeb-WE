<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cambio Password - SoccorsoWeb</title>
    <!-- Fonts e CSS esterni come da standard progetto -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/login.css">
    <link rel="stylesheet" href="/css/cambia-password.css">
</head>
<body>
<div class="bg-circle circle-1"></div>
<div class="bg-circle circle-2"></div>

<div class="login-container">
    <div class="login-card">
        <div class="info-banner">
            <i class="fas fa-shield-halved"></i>
            <h3>Primo Accesso</h3>
            <p>Aggiorna la password per accedere al sistema.</p>
        </div>

        <div class="login-header">
            <h2>Cambia Password</h2>
        </div>

        <form id="changePasswordForm">
            <div class="form-group">
                <label for="currentPassword">Password Attuale</label>
                <div class="input-wrapper">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="currentPassword" class="form-control" placeholder="Inserisci attuale" required>
                    <i class="fas fa-eye toggle-password" data-target="currentPassword"></i>
                </div>
            </div>

            <div class="form-group">
                <label for="newPassword">Nuova Password</label>
                <div class="input-wrapper">
                    <i class="fas fa-key"></i>
                    <input type="password" id="newPassword" class="form-control" placeholder="Nuova password" required>
                    <i class="fas fa-eye toggle-password" data-target="newPassword"></i>
                </div>
                <div class="password-strength">
                    <div class="password-strength-bar" id="strengthBar"></div>
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Conferma Password</label>
                <div class="input-wrapper">
                    <i class="fas fa-check-double"></i>
                    <input type="password" id="confirmPassword" class="form-control" placeholder="Ripeti password" required>
                    <i class="fas fa-eye toggle-password" data-target="confirmPassword"></i>
                </div>
            </div>

            <div class="password-requirements">
                <h4><i class="fas fa-info-circle"></i> Requisiti:</h4>
                <ul id="requirements">
                    <li id="req-length"><i class="fas fa-circle"></i> Almeno 8 caratteri</li>
                    <li id="req-uppercase"><i class="fas fa-circle"></i> Una maiuscola</li>
                    <li id="req-number"><i class="fas fa-circle"></i> Un numero</li>
                    <li id="req-special"><i class="fas fa-circle"></i> Un carattere speciale</li>
                </ul>
            </div>

            <button type="submit" class="btn-login" id="submitBtn">
                Cambia Password <i class="fas fa-arrow-right"></i>
            </button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="/js/api.js"></script>
<script src="/js/auth/cambia-password.js"></script>
</body>
</html>
