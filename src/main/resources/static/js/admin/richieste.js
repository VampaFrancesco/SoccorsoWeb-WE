document.addEventListener('DOMContentLoaded', () => {
    // Carichiamo le richieste con stato 'ATTIVA' come default
    loadRichieste('ATTIVA');

    // Gestione click bottoni filtro
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });
});

async function loadRichieste(stato) {
    const tbody = document.getElementById('requests-body');
    const noData = document.getElementById('no-data');

    // Mostra loading con classe stabile
    tbody.innerHTML = '<tr class="loading-row"><td colspan="6"><i class="fas fa-spinner fa-spin"></i> Caricamento...</td></tr>';
    noData.style.display = 'none';

    try {
        // Chiama API con stato, page e size
        const data = await visualizzaRichiesteFiltrate(stato, 0, 100);

        if (!data || !data.content || data.content.length === 0) {
            tbody.innerHTML = '';
            noData.style.display = 'block';
            return;
        }

        // Creiamo un fragment per accumulare le righe prima di inserirle
        const fragment = document.createDocumentFragment();

        data.content.forEach(req => {
            const date = req.convalidata_at ? new Date(req.convalidata_at).toLocaleString('it-IT') : 'N/A';

            const row = document.createElement('tr');
            row.innerHTML = `
                <td><span class="targa-badge">#${req.id}</span></td>
                <td>
                    <strong>${req.nome_segnalante || 'Anonimo'}</strong><br>
                    <small style="color: #64748b;">${req.telefono_segnalante || ''}</small>
                </td>
                <td>${date}</td>
                <td><i class="fas fa-map-marker-alt" style="color: #ef4444;"></i> ${req.indirizzo || 'Non specificato'}</td>
                <td><p style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; margin:0;">${req.descrizione || 'Nessun dettaglio'}</p></td>
                <td>
                    <div class="action-group">
                        ${req.stato === 'ATTIVA' ? `
                            <button class="btn-assign" onclick="creaMissione(${req.id})">
                                <i class="fas fa-ambulance"></i> Assegna
                            </button>
                            <button class="btn-ignore" onclick="gestisciIgnora(${req.id})">
                                <i class="fas fa-ban"></i> Ignora
                            </button>
                        ` : `
                            <span class="status-pill status-${req.stato}">${req.stato}</span>
                        `}
                    </div>
                </td>
            `;
            fragment.appendChild(row);
        });

        // Cancella il tbody e aggiungi tutte le righe in una volta sola
        tbody.innerHTML = '';
        tbody.appendChild(fragment);
        noData.style.display = 'none';
    } catch (err) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; color: #ef4444; padding: 40px;">Errore nel caricamento dei dati.</td></tr>';
        console.error('Errore nel caricamento delle richieste:', err);
    }
}

async function gestisciIgnora(id) {
    const confirm = await Swal.fire({
        title: 'Ignorare questa richiesta?',
        text: "La richiesta verrà segnata come IGNORATA e non sarà più possibile assegnarla.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        confirmButtonText: 'Sì, ignora'
    });

    if (confirm.isConfirmed) {
        try {
            // Utilizza l'API di annullamento/aggiornamento stato
            // Nota: Se l'API specifica per IGNORA non esiste, si usa aggiornaRichiesta
            await apiCall(`/swa/api/richieste/${id}/annullamento`, 'PATCH', null, true);
            Swal.fire('Aggiornato', 'Richiesta ignorata con successo.', 'success');
            loadRichieste('ATTIVA');
        } catch (err) {
            Swal.fire('Errore', 'Impossibile ignorare la richiesta.', 'error');
        }
    }
}

function creaMissione(idRichiesta) {
    // Reindirizzamento alla pagina di creazione missione passando l'ID richiesta
    window.location.href = `/admin/missioni/nuova?richiestaId=${idRichiesta}`;
}