document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    const loginBtn = document.querySelector('.btn-login');

    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();

            // Disable button and show loading state
            const originalBtnText = loginBtn.innerHTML;
            loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Accesso in corso...';
            loginBtn.disabled = true;

            // Get form data
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;

            try {
                const response = await fetch('/auth/v1/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ email, password })
                });

                if (response.ok) {
                    // Success handling
                    const data = await response.json();
                    
                    // Store token (if backend returns it)
                    if (data.accessToken) {
                        localStorage.setItem('jwt_token', data.accessToken);
                    }

                    Swal.fire({
                        icon: 'success',
                        title: 'Benvenuto!',
                        text: 'Accesso effettuato con successo.',
                        timer: 1500,
                        showConfirmButton: false,
                        background: '#1a1a2e',
                        color: '#fff'
                    }).then(() => {
                        window.location.href = '/dashboard_operatore.ftl';
                    });

                } else {
                    // Error handling
                    const errorText = await response.text(); 
                    // Try to parse JSON error if possible
                    let errorMessage = 'Credenziali non valide';
                    try {
                         const errJson = JSON.parse(errorText);
                         if (errJson.message) errorMessage = errJson.message;
                    } catch(e) {}

                    Swal.fire({
                        icon: 'error',
                        title: 'Errore di Accesso',
                        text: errorMessage,
                        background: '#1a1a2e',
                        color: '#fff',
                        confirmButtonColor: '#FF4B2B'
                    });
                    
                    // Reset button
                    loginBtn.innerHTML = originalBtnText;
                    loginBtn.disabled = false;
                }

            } catch (error) {
                console.error('Login error:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Errore di Sistema',
                    text: 'Impossibile contattare il server. Riprova più tardi.',
                    background: '#1a1a2e',
                    color: '#fff',
                    confirmButtonColor: '#FF4B2B'
                });
                
                // Reset button
                loginBtn.innerHTML = originalBtnText;
                loginBtn.disabled = false;
            }
        });
    }
});
