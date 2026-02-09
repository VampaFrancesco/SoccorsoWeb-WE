document.addEventListener('DOMContentLoaded', async () => {
    console.log("Inventario Materiali caricato.");
    await refreshInventory();

    const form = document.getElementById('formMateriale');
    if (form) {
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            await saveMaterial();
        });
    }
});

async function refreshInventory() {
    try {
        // Endpoint basato sulla tua struttura API
        const data = await apiCall('/swa/api/materiali', 'GET');

        const listOk = document.getElementById('list-available');
        const listKo = document.getElementById('list-unavailable');

        listOk.innerHTML = '';
        listKo.innerHTML = '';

        let countOk = 0; let countKo = 0;

        data.forEach(m => {
            const card = createMaterialCard(m);
            if (m.disponibile) {
                listOk.appendChild(card);
                countOk++;
            } else {
                listKo.appendChild(card);
                countKo++;
            }
        });

        document.getElementById('count-available').innerText = countOk;
        document.getElementById('count-unavailable').innerText = countKo;
    } catch (err) {
        console.error("Errore caricamento:", err);
    }
}

function createMaterialCard(m) {
    const div = document.createElement('div');
    div.className = `material-card ${m.disponibile ? 'available' : 'unavailable'}`;

    div.innerHTML = `
        <div class="mat-main-info">
            <h4>${m.nome} <span class="qty-tag">Q.tà: ${m.quantita}</span></h4>
            <p class="mat-sub-info">
                <span class="type-pill">${m.tipo}</span> | ${m.descrizione || 'Nessuna nota'}
            </p>
        </div>
        <div class="mat-actions">
            <button class="btn-mat-action" onclick="openEditQuantityModal(${m.id}, ${m.quantita})" title="Modifica Quantità">
                <i class="fas fa-edit"></i>
            </button>
            <button class="btn-mat-action" onclick="patchStatus(${m.id})" title="Cambia Disponibilità">
                <i class="fas fa-sync-alt"></i>
            </button>
            <button class="btn-mat-action del" onclick="deleteMaterial(${m.id})" title="Elimina">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `;
    return div;
}

async function patchStatus(id) {
    const result = await Swal.fire({
        title: 'Cambio Disponibilità',
        text: "Vuoi davvero cambiare lo stato di disponibilità di questo materiale?",
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3b82f6',
        cancelButtonColor: '#ef4444',
        confirmButtonText: 'Sì, procedi',
        cancelButtonText: 'Annulla'
    });

    if (result.isConfirmed) {
        try {
            Swal.showLoading();

            await apiCall(`/swa/api/materiali/${id}/toggle-disponibilita`, 'PATCH');

            // Feedback toast
            const toast = Swal.mixin({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 2000
            });
            toast.fire({ icon: 'success', title: 'Stato aggiornato' });

            await refreshInventory();
        } catch (err) {
            Swal.fire('Errore', 'Aggiornamento fallito', 'error');
        }
    }
}

async function updateQuantity(id, nuovaQuantita) {
    try {
        Swal.showLoading();

        const payload = { quantita: parseInt(nuovaQuantita) };
        await apiCall(`/swa/api/materiali/${id}/quantita`, 'PATCH', payload);

        closeMaterialModal('modal-edit-quantity');
        await refreshInventory();

        Swal.fire({
            icon: 'success',
            title: 'Quantità Aggiornata',
            timer: 1500,
            showConfirmButton: false
        });
    } catch (err) {
        console.error('Errore:', err);
        Swal.fire('Errore', 'Impossibile aggiornare la quantità', 'error');
    }
}

function openEditQuantityModal(id, currentQuantity) {
    document.getElementById('edit-qty-material-id').value = id;
    document.getElementById('edit-qty-input').value = currentQuantity;
    document.getElementById('modal-edit-quantity').classList.add('show');
    document.getElementById('edit-qty-input').focus();
}

async function saveMaterial() {
    const payload = {
        nome: document.getElementById('m_nome').value,
        tipo: document.getElementById('m_tipo').value,
        quantita: parseInt(document.getElementById('m_quantita').value),
        descrizione: document.getElementById('m_descrizione').value,
        disponibile: true
    };

    try {
        Swal.showLoading();

        await apiCall('/swa/api/materiali', 'POST', payload);

        closeMaterialModal('modal-add-material');
        document.getElementById('formMateriale').reset();
        await refreshInventory();

        Swal.fire({
            icon: 'success',
            title: 'Articolo Salvato',
            timer: 1500,
            showConfirmButton: false
        });
    } catch (err) {
        Swal.fire('Errore', 'Impossibile salvare il materiale', 'error');
    }
}

async function deleteMaterial(id) {
    const result = await Swal.fire({
        title: 'Eliminare articolo?',
        text: "L'azione è definitiva",
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#3b82f6',
        confirmButtonText: 'Sì, elimina',
        cancelButtonText: 'Annulla'
    });

    if (result.isConfirmed) {
        try {
            Swal.showLoading();

            await apiCall(`/swa/api/materiali/${id}`, 'DELETE');

            // Feedback toast
            const toast = Swal.mixin({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 2000
            });
            toast.fire({ icon: 'success', title: 'Articolo eliminato' });

            await refreshInventory();
        } catch (err) {
            Swal.fire('Errore', 'Impossibile eliminare l\'articolo', 'error');
        }
    }
}

function openMaterialModal(id) { document.getElementById(id).classList.add('show'); }
function closeMaterialModal(id) { document.getElementById(id).classList.remove('show'); }
