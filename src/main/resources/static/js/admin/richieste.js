let richiestaMap = null;


document.addEventListener('DOMContentLoaded', () => {
    loadRichieste('ATTIVA');
    initFilterButtons();
});

// FILTRI

function initFilterButtons() {
    const filterBtns = document.querySelectorAll('.filter-btn');
    filterBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            filterBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            const filter = this.getAttribute('data-filter') || 'ATTIVA';
            loadRichieste(filter);
        });
    });
}

// CARICAMENTO RICHIESTE

async function loadRichieste(stato) {
    const tbody = document.getElementById('requests-body');
    const noData = document.getElementById('no-data');

    tbody.innerHTML = '<tr class="loading-row"><td colspan="6"><i class="fas fa-spinner fa-spin"></i> Caricamento...</td></tr>';
    noData.style.display = 'none';

    try {
        const data = await visualizzaRichiesteFiltrate(stato, 0, 100);

        if (!data || !data.content || data.content.length === 0) {
            tbody.innerHTML = '';
            noData.style.display = 'flex';
            return;
        }

        const fragment = document.createDocumentFragment();

        data.content.forEach(req => {
            const date = req.convalidata_at ? formatDate(req.convalidata_at) : 'N/A';

            const row = document.createElement('tr');
            row.innerHTML = `
                <td><span class="targa-badge">#${req.id}</span></td>
                <td>
                    <strong>${req.nome_segnalante || 'Anonimo'}</strong><br>
                    <small style="color: var(--text-secondary);">${req.telefono_segnalante || ''}</small>
                </td>
                <td>${date}</td>
                <td><i class="fas fa-map-marker-alt" style="color: var(--accent-danger);"></i> ${req.indirizzo || 'Non specificato'}</td>
                <td><p style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; margin:0;">${req.descrizione || 'Nessun dettaglio'}</p></td>
                <td>
                    <div class="action-group">
                        <button class="btn-assign" onclick="viewRichiestaDettaglio(${req.id})" style="background: rgba(59,130,246,0.2); color: var(--accent-primary); border: 1px solid rgba(59,130,246,0.3);">
                            <i class="fas fa-eye"></i> Dettagli
                        </button>
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

        tbody.innerHTML = '';
        tbody.appendChild(fragment);
        noData.style.display = 'none';
    } catch (err) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; color: var(--accent-danger); padding: 40px;"><i class="fas fa-exclamation-triangle"></i> Errore nel caricamento dei dati.</td></tr>';
    }
}

// DETTAGLIO RICHIESTA CON MAPPA

async function viewRichiestaDettaglio(id) {
    try {
        const req = await dettagliRichiestaSoccorso(id);
        if (!req) {
            Swal.fire('Errore', 'Impossibile caricare i dettagli', 'error');
            return;
        }

        const lat = req.latitudine;
        const lon = req.longitudine;

        let html = `
            <div class="detail-section">
                <h2><i class="fas fa-info-circle"></i> Informazioni Richiesta</h2>
                <div class="detail-grid">
                    <div class="detail-item">
                        <label>ID</label>
                        <span><strong>#${req.id}</strong></span>
                    </div>
                    <div class="detail-item">
                        <label>Stato</label>
                        <span><span class="status-pill status-${req.stato}">${req.stato}</span></span>
                    </div>
                    <div class="detail-item">
                        <label>Segnalante</label>
                        <span>${req.nome_segnalante || 'Anonimo'}</span>
                    </div>
                    <div class="detail-item">
                        <label>Email</label>
                        <span>${req.email_segnalante || 'N/D'}</span>
                    </div>
                    <div class="detail-item">
                        <label>Telefono</label>
                        <span>${req.telefono_segnalante || 'N/D'}</span>
                    </div>
                    <div class="detail-item">
                        <label>Data Convalida</label>
                        <span>${req.convalidata_at ? formatDate(req.convalidata_at) : 'N/D'}</span>
                    </div>
                    <div class="detail-item" style="grid-column: 1 / -1;">
                        <label>Indirizzo</label>
                        <span><i class="fas fa-map-marker-alt" style="color: var(--accent-danger);"></i> ${req.indirizzo || 'N/D'}</span>
                    </div>
                    <div class="detail-item" style="grid-column: 1 / -1;">
                        <label>Descrizione</label>
                        <span>${req.descrizione || 'N/D'}</span>
                    </div>
                </div>
            </div>
        `;

        // Sezione Foto
        const fotoSrc = req.foto ? `data:image/jpeg;base64,${req.foto}` : null;

        html += `
            <div class="detail-section">
                <h2><i class="fas fa-camera"></i> Foto Segnalazione</h2>
                <div style="text-align: center; padding: 10px;">
                    ${fotoSrc
                ? `<img src="${fotoSrc}" alt="Foto segnalazione" style="max-width: 100%; max-height: 300px; object-fit: contain; border-radius: 8px; border: 1px solid var(--border-color); box-shadow: 0 4px 6px rgba(0,0,0,0.3);">`
                : `<div style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 30px; background: rgba(255,255,255,0.02); border-radius: 8px; border: 1px dashed var(--border-color);">
                               <i class="fas fa-image" style="font-size: 3rem; color: var(--text-secondary); opacity: 0.5; margin-bottom: 12px;"></i>
                               <p style="color: var(--text-secondary); font-size: 0.9rem;">Nessuna foto disponibile</p>
                           </div>`
            }
                </div>
            </div>
        `;

        if (lat && lon) {
            html += `
                <div class="detail-section">
                    <h2><i class="fas fa-map-location-dot"></i> Posizione sulla Mappa</h2>
                    <div class="map-container" id="richiesta-detail-map"></div>
                </div>
            `;
        }

        if (req.missione_id) {
            html += `
                <div class="detail-section">
                    <h2><i class="fas fa-map-location-dot"></i> Missione Associata</h2>
                    <div class="detail-item">
                        <label>ID Missione</label>
                        <span><strong>#${req.missione_id}</strong></span>
                    </div>
                </div>
            `;
        }

        document.getElementById('richiesta-dettagli-content').innerHTML = html;

        // Open modal
        const modal = document.getElementById('modal-dettagli-richiesta');
        if (modal) {
            modal.classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        // Init map
        if (lat && lon) {
            setTimeout(() => {
                if (richiestaMap) {
                    richiestaMap.remove();
                    richiestaMap = null;
                }

                const latNum = parseFloat(lat);
                const lonNum = parseFloat(lon);
                if (isNaN(latNum) || isNaN(lonNum)) return;

                richiestaMap = L.map('richiesta-detail-map').setView([latNum, lonNum], 15);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; OpenStreetMap',
                    maxZoom: 19
                }).addTo(richiestaMap);

                L.marker([latNum, lonNum]).addTo(richiestaMap)
                    .bindPopup(`<strong>${req.indirizzo || 'Posizione segnalazione'}</strong>`)
                    .openPopup();
            }, 200);
        }

    } catch (error) {
        Swal.fire('Errore', 'Impossibile caricare i dettagli della richiesta', 'error');
    }
}

function closeRichiestaModal() {
    const modal = document.getElementById('modal-dettagli-richiesta');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
    if (richiestaMap) {
        richiestaMap.remove();
        richiestaMap = null;
    }
}

// Click fuori modal per chiudere
document.addEventListener('click', function (e) {
    if (e.target.id === 'modal-dettagli-richiesta') {
        closeRichiestaModal();
    }
});

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        closeRichiestaModal();
    }
});

// AZIONI

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
            await apiCall(`/swa/api/richieste/${id}/annullamento`, 'PATCH', null, true);
            Swal.fire('Aggiornato', 'Richiesta ignorata con successo.', 'success');
            loadRichieste('ATTIVA');
        } catch (err) {
            Swal.fire('Errore', 'Impossibile ignorare la richiesta.', 'error');
        }
    }
}

function creaMissione(idRichiesta) {
    window.location.href = `/admin/missioni/nuova?richiestaId=${idRichiesta}`;
}