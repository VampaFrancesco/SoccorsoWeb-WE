function determineRedirectUrl(data) {
    // 🔍 DEBUG: Stampa TUTTO quello che ricevi
    console.log('🔍 DEBUG REDIRECT:');
    console.log('data completo:', data);
    console.log('data.roles:', data.roles);
    console.log('data.first_attempt:', data.first_attempt);

    if (data.first_attempt) {
        console.log('✅ Primo accesso rilevato. Redirect a: /auth/cambia-password');
        return '/auth/cambia-password';
    }

    if (data.roles) {
        data.roles.forEach((role, index) => {
            console.log(`Role ${index}:`, role);
            console.log(`  - name: "${role.name}"`);
            console.log(`  - tipo: ${typeof role.name}`);
        });
    }

    const isAdmin = data.roles && data.roles.some(role => role.name === 'ADMIN');
    const isOperatore = data.roles && data.roles.some(role => role.name === 'OPERATORE');

    console.log('isAdmin:', isAdmin);
    console.log('isOperatore:', isOperatore);

    if (isAdmin) {
        console.log('✅ Redirect a: /admin');
        return '/admin';
    } else {
        console.log('✅ Redirect a: /operatore');
        return '/operatore';
    }
}





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

                // Verifica che data non sia null
                if (!data) {
                    throw new Error('Nessuna risposta dal server');
                }

                const statusCode = data.status;

                // Gestione degli errori HTTP (400, 401, 403, 404, 500+)
                if (statusCode >= 400) {
                    let errorMessage = 'Errore sconosciuto';

                    switch (statusCode) {
                        case 400:
                            errorMessage = 'Richiesta non valida. Controlla i dati inseriti.';
                            break;
                        case 401:
                            errorMessage = 'Credenziali non valide. Riprova.';
                            break;
                        case 403:
                            errorMessage = 'Accesso negato. Contatta l\'amministratore.';
                            break;
                        case 404:
                            errorMessage = 'Utente non trovato. Verifica l\'email inserita.';
                            break;
                        default:
                            if (statusCode >= 500) {
                                errorMessage = 'Errore del server. Riprova più tardi.';
                            }
                            break;
                    }

                    Swal.fire({
                        icon: 'error',
                        title: 'Errore di Accesso',
                        text: errorMessage,
                        background: '#1a1a2e',
                        color: '#fff',
                        confirmButtonColor: '#FF4B2B'
                    });

                    loginBtn.innerHTML = originalBtnText;
                    loginBtn.disabled = false;
                    return; // Interrompe qui in caso di errore
                }

                // Login andato a buon fine (status 200)
                // Salva il token (dalla tua API si chiama "token")
                if (data.token) {
                    localStorage.setItem('authToken', data.token);
                } else {
                    throw new Error('Token non presente nella risposta');
                }

                // Salva i ruoli (roles è un array di oggetti)
                if (data.roles && data.roles.length > 0) {
                    localStorage.setItem('userRole', data.roles[0].name);
                    localStorage.setItem('userRoles', JSON.stringify(data.roles));
                }

                // Salva i dati utente completi
                const userData = {
                    id: data.id,
                    email: data.email,
                    nome: data.nome,
                    cognome: data.cognome,
                    telefono: data.telefono,
                    disponibile: data.disponibile,
                    roles: data.roles,
                    first_attempt: data.first_attempt // 🆕 Salva lo stato del primo accesso
                };
                localStorage.setItem('user', JSON.stringify(userData));

                // Messaggio personalizzato per il primo accesso
                const welcomeMessage = data.first_attempt
                    ? `Benvenuto ${data.nome || ''}! Ti chiediamo di cambiare la password.`
                    : `Accesso effettuato con successo. Benvenuto ${data.nome || ''}!`;

                // Mostra messaggio di successo
                Swal.fire({
                    icon: data.first_attempt ? 'info' : 'success',
                    title: data.first_attempt ? 'Primo Accesso' : 'Benvenuto!',
                    text: welcomeMessage,
                    timer: data.first_attempt ? 2500 : 1500,
                    showConfirmButton: false,
                    background: '#1a1a2e',
                    color: '#fff'
                }).then(() => {
                    // Determina dove reindirizzare in base al ruolo
                    const redirectUrl = determineRedirectUrl(data);

                    // Flag per evitare loop di redirect
                    sessionStorage.setItem('justLoggedIn', 'true');

                    // Effettua il redirect
                    window.location.href = redirectUrl;
                });

            } catch (error) {
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
