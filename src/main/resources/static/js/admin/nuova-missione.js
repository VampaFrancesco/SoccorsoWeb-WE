// ========================================
// NUOVA MISSIONE - Creazione in tempo reale
// ========================================

document.addEventListener('DOMContentLoaded', async function () {
    const richiestaId = new URLSearchParams(window.location.search).get('richiestaId');

    if (!richiestaId) {
        Swal.fire('Errore', 'ID Richiesta mancante.', 'error')
            .then(() => window.location.href = '/admin/richieste');
        return;
    }

    document.getElementById('richiestaId').value = richiestaId;
    document.getElementById('form-missione').addEventListener('submit', invioMissione);

    // Carica tutte le risorse in parallelo
    await Promise.all([
        caricaDettagliRichiesta(richiestaId),
        caricaOperatoriDisponibili(),
        caricaMezziDisponibili(),
        caricaMaterialiDisponibili()
    ]);
});


// ========================================
// CARICAMENTO RISORSE
// ========================================

/** Mostra i dettagli della richiesta nella sidebar */
async function caricaDettagliRichiesta(id) {
    try {
        const req = await dettagliRichiestaSoccorso(id);
        if (!req) return;

        document.getElementById('obiettivo').value = req.descrizione?.substring(0, 50) || '';
        document.getElementById('posizione').value = req.indirizzo || '';

        document.getElementById('richiesta-details').innerHTML = `
            <div style="margin-bottom: 16px;">
                <label style="color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">ID Richiesta</label>
                <div style="font-weight: 600;">#${req.id}</div>
            </div>
            <div style="margin-bottom: 16px;">
                <label style="color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">Segnalante</label>
                <div style="color: white;">${req.nomeSegnalante || 'N/D'}</div>
            </div>
            <div style="margin-bottom: 16px;">
                <label style="color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">Indirizzo</label>
                <div style="color: var(--accent-primary); font-size: 0.9rem;">
                    <i class="fas fa-map-marker-alt"></i> ${req.indirizzo || 'N/D'}
                </div>
            </div>
            <div>
                <label style="color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">Descrizione</label>
                <div style="color: var(--text-secondary); font-size: 0.85rem; line-height: 1.4; margin-top: 4px;">
                    ${req.descrizione || 'Nessuna descrizione'}
                </div>
            </div>
        `;
    } catch (error) {
        console.error('Errore caricamento richiesta:', error);
    }
}

/** Carica caposquadra (select) e operatori (checkbox) */
async function caricaOperatoriDisponibili() {
    const selectCapo = document.getElementById('caposquadraId');
    const listOperatori = document.getElementById('operatori-list');

    try {
        const operatori = await operatoriDisponibili(true);
        selectCapo.innerHTML = '<option value="">Seleziona un caposquadra...</option>';
        listOperatori.innerHTML = '';

        if (!operatori?.length) {
            listOperatori.innerHTML = '<p style="grid-column:1/-1; text-align:center; color:var(--text-muted);">Nessun operatore disponibile.</p>';
            return;
        }

        operatori.forEach(op => {
            const nome = `${op.nome} ${op.cognome}`;

            // Option nel select caposquadra
            const opt = document.createElement('option');
            opt.value = op.id;
            opt.textContent = nome;
            selectCapo.appendChild(opt);

            // Checkbox operatore
            const div = document.createElement('div');
            div.className = 'resource-selection-item';
            div.style.cssText = 'display:flex; align-items:center; gap:10px; padding:10px; background:rgba(255,255,255,0.03); border-radius:8px; border:1px solid rgba(255,255,255,0.05);';
            div.innerHTML = `
                <input type="checkbox" name="operatoriIds" value="${op.id}" id="op-${op.id}" class="op-checkbox" style="cursor:pointer; width:18px; height:18px;">
                <label for="op-${op.id}" style="color:white; font-size:0.85rem; cursor:pointer; flex:1;">${nome}</label>
            `;
            listOperatori.appendChild(div);
        });

        // Il caposquadra selezionato non può essere anche operatore
        selectCapo.addEventListener('change', function () {
            const capoId = this.value;
            document.querySelectorAll('.op-checkbox').forEach(cb => {
                const item = cb.closest('.resource-selection-item');
                const isCapo = cb.value === capoId;
                cb.checked = isCapo ? false : cb.checked;
                cb.disabled = isCapo;
                item.style.opacity = isCapo ? '0.3' : '1';
            });
        });

    } catch (error) {
        console.error('Errore caricamento operatori:', error);
    }
}

/** Carica la lista dei mezzi selezionabili */
async function caricaMezziDisponibili() {
    const list = document.getElementById('mezzi-list');
    try {
        const mezzi = await getMezziDisponibili();
        list.innerHTML = '';

        if (!mezzi?.length) {
            list.innerHTML = '<p style="text-align:center; color:var(--text-muted); padding:20px;">Nessun mezzo disponibile.</p>';
            return;
        }

        mezzi.forEach(m => {
            const div = document.createElement('div');
            div.style.cssText = 'display:flex; align-items:center; gap:12px; padding:12px; background:rgba(255,255,255,0.03); border-radius:10px; border:1px solid rgba(255,255,255,0.05);';
            div.innerHTML = `
                <input type="checkbox" name="mezziIds" value="${m.id}" id="mezzo-${m.id}" style="width:18px; height:18px;">
                <div style="flex:1;">
                    <label for="mezzo-${m.id}" style="color:white; font-size:0.9rem; font-weight:500; cursor:pointer; display:block;">${m.nome}</label>
                    <small style="color:var(--text-muted); font-size:0.75rem;">${m.tipo} | ${m.targa || 'Senza targa'}</small>
                </div>
                <i class="fas fa-ambulance" style="color:var(--accent-primary); opacity:0.5;"></i>
            `;
            list.appendChild(div);
        });
    } catch (error) {
        console.error('Errore caricamento mezzi:', error);
    }
}

/** Carica materiali con input quantità */
async function caricaMaterialiDisponibili() {
    const list = document.getElementById('materiali-list');
    try {
        const materiali = await getMaterialiDisponibili();
        list.innerHTML = '';

        if (!materiali?.length) {
            list.innerHTML = '<p style="text-align:center; color:var(--text-muted); padding:20px;">Nessun materiale disponibile.</p>';
            return;
        }

        materiali.forEach(m => {
            const div = document.createElement('div');
            div.style.cssText = 'display:flex; align-items:center; gap:12px; padding:12px; background:rgba(255,255,255,0.03); border-radius:10px; border:1px solid rgba(255,255,255,0.05); margin-bottom:8px;';
            div.innerHTML = `
                <input type="checkbox" class="material-checkbox" data-id="${m.id}" id="mat-${m.id}" style="width:18px; height:18px;">
                <div style="flex:1;">
                    <label for="mat-${m.id}" style="color:white; font-size:0.9rem; font-weight:500; cursor:pointer; display:block;">${m.nome}</label>
                    <small style="color:var(--accent-primary);">Disponibili: ${m.quantita}</small>
                </div>
                <input type="number" id="qty-${m.id}" value="1" min="1" max="${m.quantita}" disabled
                    style="width:65px; background:var(--bg-app); border:1px solid var(--border-color); color:white; border-radius:6px; padding:6px; font-size:0.85rem;">
            `;

            // Abilita/disabilita input quantità
            const checkbox = div.querySelector('.material-checkbox');
            const qtyInput = div.querySelector('input[type="number"]');
            checkbox.addEventListener('change', () => {
                qtyInput.disabled = !checkbox.checked;
                div.style.background = checkbox.checked ? 'rgba(59,130,246,0.1)' : 'rgba(255,255,255,0.03)';
            });

            list.appendChild(div);
        });
    } catch (error) {
        console.error('Errore caricamento materiali:', error);
    }
}


// ========================================
// INVIO MISSIONE
// ========================================

/** Converte un valore in intero, restituisce null se non valido */
function toInt(val) {
    const n = parseInt(val);
    return isNaN(n) ? null : n;
}

/** Raccoglie i materiali selezionati con le rispettive quantità */
function raccogliMateriali() {
    const materiali = [];
    document.querySelectorAll('.material-checkbox:checked').forEach(cb => {
        const id = toInt(cb.dataset.id);
        const qty = toInt(document.getElementById(`qty-${cb.dataset.id}`).value);
        if (id && qty) {
            materiali.push({ materiale_id: id, quantita_usata: qty });
        }
    });
    return materiali;
}

/** Gestisce l'invio del form di creazione */
async function invioMissione(e) {
    e.preventDefault();

    const form = new FormData(e.target);
    const caposquadraId = form.get('caposquadraId');

    // Validazione
    if (!caposquadraId) {
        Swal.fire('Attenzione', 'È obbligatorio assegnare un caposquadra.', 'warning');
        return;
    }

    // Costruzione payload
    const payload = {
        richiesta_id: toInt(form.get('richiestaId')),
        obiettivo: form.get('obiettivo'),
        posizione: form.get('posizione'),
        caposquadra_id: toInt(caposquadraId),
        operatori_ids: form.getAll('operatoriIds').map(toInt).filter(Boolean),
        mezzi_ids: form.getAll('mezziIds').map(toInt).filter(Boolean),
        materiali: raccogliMateriali()
    };

    // Invio
    try {
        Swal.fire({ title: 'Avvio missione...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });

        const res = await inserimentoMissione(payload);
        if (res) {
            await Swal.fire({
                title: 'Missione Avviata!',
                text: 'La missione è stata creata. Gli operatori riceveranno una notifica email.',
                icon: 'success',
                confirmButtonColor: '#3b82f6'
            });
            window.location.href = '/admin/richieste';
        }
    } catch (error) {
        console.error('Errore creazione missione:', error);
        Swal.fire('Errore', 'Impossibile avviare la missione: ' + error.message, 'error');
    }
}
