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

    await Promise.all([
        caricaDettagliRichiesta(richiestaId),
        caricaOperatoriDisponibili(),
        caricaMezziDisponibili(),
        caricaMaterialiDisponibili()
    ]);
});

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
        // Silent error
    }
}

async function caricaOperatoriDisponibili() {
    const listCapo = document.getElementById('caposquadra-list');
    const listOperatori = document.getElementById('operatori-list');

    try {
        const operatori = await operatoriDisponibili(true);
        listCapo.innerHTML = '';
        listOperatori.innerHTML = '';

        if (!operatori?.length) {
            listCapo.innerHTML = '<p style="grid-column:1/-1; text-align:center; color:var(--text-muted);">Nessun operatore disponibile.</p>';
            listOperatori.innerHTML = '<p style="grid-column:1/-1; text-align:center; color:var(--text-muted);">Nessun operatore disponibile.</p>';
            return;
        }

        operatori.forEach(op => {
            const nome = `${op.nome} ${op.cognome}`;

            const abilitaBadges = (op.abilita || []).map(a => `<span style="background:rgba(59,130,246,0.2); color:#60a5fa; padding:2px 6px; border-radius:4px; font-size:0.7rem; margin-right:4px; display:inline-block; margin-bottom:2px;">${a.nome}</span>`).join('');
            const patentiBadges = (op.patenti || []).map(p => `<span style="background:rgba(245, 158, 11, 0.2); color:#fbbf24; padding:2px 6px; border-radius:4px; font-size:0.7rem; margin-right:4px; display:inline-block; margin-bottom:2px;">${p.tipo}</span>`).join('');

            // Caposquadra checkbox
            const capoDiv = document.createElement('div');
            capoDiv.className = 'resource-selection-item capo-item';
            capoDiv.dataset.opId = op.id;
            capoDiv.style.cssText = 'display:flex; align-items:center; gap:10px; padding:10px; background:rgba(255,255,255,0.03); border-radius:8px; border:1px solid rgba(255,255,255,0.05);';
            capoDiv.innerHTML = `
                <input type="checkbox" name="caposquadraIds" value="${op.id}" id="capo-${op.id}" class="capo-checkbox" style="cursor:pointer; width:18px; height:18px;">
                <label for="capo-${op.id}" style="color:white; font-size:0.9rem; cursor:pointer; font-weight:500; flex:1;">${nome}</label>
            `;
            listCapo.appendChild(capoDiv);

            // Operatore checkbox
            const opDiv = document.createElement('div');
            opDiv.className = 'resource-selection-item op-item';
            opDiv.dataset.opId = op.id;
            opDiv.style.cssText = 'display:flex; align-items:start; gap:10px; padding:10px; background:rgba(255,255,255,0.03); border-radius:8px; border:1px solid rgba(255,255,255,0.05);';
            opDiv.innerHTML = `
                <input type="checkbox" name="operatoriIds" value="${op.id}" id="op-${op.id}" class="op-checkbox" style="cursor:pointer; width:18px; height:18px; margin-top:3px;">
                <div style="flex:1;">
                    <label for="op-${op.id}" style="color:white; font-size:0.9rem; cursor:pointer; font-weight:500;">${nome}</label>
                    ${patentiBadges || abilitaBadges ? `<div style="margin-top:6px; line-height:1.4;">${patentiBadges}${abilitaBadges}</div>` : ''}
                </div>
            `;
            listOperatori.appendChild(opDiv);
        });

        // Quando si seleziona un caposquadra, disabilitalo nella lista operatori
        document.querySelectorAll('.capo-checkbox').forEach(cb => {
            cb.addEventListener('change', function () {
                const opId = this.value;
                const opCheckbox = document.getElementById(`op-${opId}`);
                const opItem = opCheckbox?.closest('.op-item');

                if (this.checked) {
                    if (opCheckbox) {
                        opCheckbox.checked = false;
                        opCheckbox.disabled = true;
                    }
                    if (opItem) opItem.style.opacity = '0.3';
                } else {
                    if (opCheckbox) opCheckbox.disabled = false;
                    if (opItem) opItem.style.opacity = '1';
                }
            });
        });

    } catch (error) {
        // Silent error
    }
}

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
        // Silent error
    }
}

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

            const checkbox = div.querySelector('.material-checkbox');
            const qtyInput = div.querySelector('input[type="number"]');
            checkbox.addEventListener('change', () => {
                qtyInput.disabled = !checkbox.checked;
                div.style.background = checkbox.checked ? 'rgba(59,130,246,0.1)' : 'rgba(255,255,255,0.03)';
            });

            list.appendChild(div);
        });
    } catch (error) {
        // Silent error
    }
}

function toInt(val) {
    const n = parseInt(val);
    return isNaN(n) ? null : n;
}

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

async function invioMissione(e) {
    e.preventDefault();

    const form = new FormData(e.target);

    // Raccogli caposquadra selezionati (multipli)
    const caposquadraIds = form.getAll('caposquadraIds').map(toInt).filter(Boolean);

    if (!caposquadraIds.length) {
        Swal.fire('Attenzione', 'È obbligatorio assegnare almeno un caposquadra.', 'warning');
        return;
    }

    const payload = {
        richiesta_id: toInt(form.get('richiestaId')),
        obiettivo: form.get('obiettivo'),
        posizione: form.get('posizione'),
        caposquadra_ids: caposquadraIds,
        operatori_ids: form.getAll('operatoriIds').map(toInt).filter(Boolean),
        mezzi_ids: form.getAll('mezziIds').map(toInt).filter(Boolean),
        materiali: raccogliMateriali()
    };

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
        Swal.fire('Errore', 'Impossibile avviare la missione: ' + error.message, 'error');
    }
}
