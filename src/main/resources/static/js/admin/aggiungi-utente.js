document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('formAggiungiUtente');
    const btnSalva = document.getElementById('btnSalva');
    const btnGenerate = document.getElementById('btnGeneratePass');
    const passwordInput = document.getElementById('passwordInput');

    // Funzione Generazione Password
    const generatePassword = () => {
        const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
        let password = "";
        for (let i = 0; i < 12; i++) {
            password += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        passwordInput.value = password;

        // Effetto visivo feedback
        passwordInput.style.borderColor = 'var(--accent-success)';
        setTimeout(() => passwordInput.style.borderColor = 'var(--border-color)', 1000);
    };

    btnGenerate.addEventListener('click', generatePassword);

    if (form) {
        form.addEventListener('submit', async (e) => {
            e.preventDefault();

            // Loading state
            const originalContent = btnSalva.innerHTML;
            btnSalva.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Elaborazione...';
            btnSalva.disabled = true;

            const formData = new FormData(form);

            // Struttura dati per API 22
            const datiUtente = {
                nome: formData.get('nome'),
                cognome: formData.get('cognome'),
                email: formData.get('email'),
                telefono: formData.get('telefono'),
                password: formData.get('password'),
                ruoli: [{ name: formData.get('ruolo') }]
            };

            try {
                // Chiamata alla funzione definita in api.js
                await registraNuovoUtente(datiUtente);

                Swal.fire({
                    icon: 'success',
                    title: 'Operatore Registrato',
                    text: `Profilo per ${datiUtente.nome} creato correttamente nel sistema.`,
                    background: '#1e1f26',
                    color: '#fff',
                    confirmButtonColor: '#3b82f6'
                });

                form.reset();
                passwordInput.style.borderColor = 'var(--border-color)';

            } catch (error) {
                console.error('Errore registrazione:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Errore Sistema',
                    text: error.message || 'Impossibile completare la registrazione.',
                    background: '#1e1f26',
                    color: '#fff',
                    confirmButtonColor: '#ef4444'
                });
            } finally {
                btnSalva.innerHTML = originalContent;
                btnSalva.disabled = false;
            }
        });
    }
});