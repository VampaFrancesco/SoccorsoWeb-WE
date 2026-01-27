document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    const loginBtn = document.querySelector('.btn-login');

    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();

            const originalBtnText = loginBtn.innerHTML;
            loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Accesso in corso...';
            loginBtn.disabled = true;

            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;

            try {
                const data = await login({ email, password });

                //il login è andato bene (status 200)

                // Salva il token
                if (data.accessToken) {
                    localStorage.setItem('authToken', data.accessToken); // Importante: api.js usa 'authToken' per le chiamate future
                } else if (data.token) {
                    localStorage.setItem('authToken', data.token);
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

            } catch (error) {
                // Se api.js riceve un errore (es. 401), lancia un throw
                console.error('Login error:', error);

                const msg = error.message || 'Credenziali non valide o errore server.';

                Swal.fire({
                    icon: 'error',
                    title: 'Errore di Accesso',
                    text: msg,
                    background: '#1a1a2e',
                    color: '#fff',
                    confirmButtonColor: '#FF4B2B'
                });

                loginBtn.innerHTML = originalBtnText;
                loginBtn.disabled = false;
            }
        });
    }
});
