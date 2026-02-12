<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SoccorsoWeb</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/login.css">

    <!-- FontAwesome (deferred) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" media="print" onload="this.media='all'">
</head>
<body>

    <!-- Ambient Background -->
    <div class="bg-circle circle-1"></div>
    <div class="bg-circle circle-2"></div>

    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <h2>SoccorsoWeb</h2>
                <p>Accedi al portale operativo</p>
            </div>
            
            <form id="loginForm">
                <div class="form-group">
                    <label for="email">Indirizzo Email</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" class="form-control" placeholder="nome@soccorso.it" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" class="form-control" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn-login">
                    Accedi <i class="fas fa-arrow-right"></i>
                </button>
            </form>
        </div>
    </div>

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- Check per errori di sessione -->
    <script>
        // Controlla se l'utente è stato reindirizzato per problemi di sessione
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('error') === 'session') {
            Swal.fire({
                icon: 'warning',
                title: 'Accesso Richiesto',
                text: 'Devi effettuare il login per accedere a questa sezione.',
                background: '#1a1a2e',
                color: '#fff',
                confirmButtonColor: '#FF4B2B'
            });
        }
    </script>

    <!-- Logic -->
    <script src="/js/api.js"></script>
    <script src="/js/auth/login.js"></script>

</body>
</html>
