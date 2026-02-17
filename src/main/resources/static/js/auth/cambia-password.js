document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('changePasswordForm');
    const newPass = document.getElementById('newPassword');
    const submitBtn = document.getElementById('submitBtn');

    // Toggle visibilità
    document.querySelectorAll('.toggle-password').forEach(t => {
        t.addEventListener('click', function () {
            const input = document.getElementById(this.dataset.target);
            const isPass = input.type === 'password';
            input.type = isPass ? 'text' : 'password';
            this.classList.toggle('fa-eye', !isPass);
            this.classList.toggle('fa-eye-slash', isPass);
        });
    });

    // Validazione e Forza
    newPass.addEventListener('input', (e) => {
        const v = e.target.value;
        const checks = {
            'req-length': v.length >= 8,
            'req-uppercase': /[A-Z]/.test(v),
            'req-number': /[0-9]/.test(v),
            'req-special': /[!@#$%^&*]/.test(v)
        };

        let score = 0;
        Object.keys(checks).forEach(id => {
            const el = document.getElementById(id);
            if (checks[id]) {
                el.classList.add('valid');
                el.querySelector('i').className = 'fas fa-check-circle';
                score++;
            } else {
                el.classList.remove('valid');
                el.querySelector('i').className = 'fas fa-circle';
            }
        });

        const bar = document.getElementById('strengthBar');
        bar.className = 'password-strength-bar ' + (score < 2 ? 'weak' : score < 4 ? 'medium' : 'strong');
    });

    // Submit
    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        if (newPass.value !== document.getElementById('confirmPassword').value) {
            return Swal.fire({ icon: 'error', title: 'Errore', text: 'Le password non coincidono' });
        }

        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Invio...';

        try {
            // funzione definita in api.js
            await cambiaPassword(
                document.getElementById('currentPassword').value,
                newPass.value
            );

            // la chiamata è andata a buon fine
            Swal.fire({ icon: 'success', title: 'Successo', timer: 1500, showConfirmButton: false })
                .then(() => {
                    const role = localStorage.getItem('userRole');
                    if (role === 'ADMIN') {
                        window.location.href = '/admin';
                    } else {
                        window.location.href = '/operatore';
                    }
                });
        } catch {
            Swal.fire({ icon: 'error', title: 'Errore', text: 'Impossibile cambiare la password' });
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Cambia Password <i class="fas fa-arrow-right"></i>';
        }
    });
});
