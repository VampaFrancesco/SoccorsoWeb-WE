document.addEventListener("DOMContentLoaded", async function () {
    const profileForm = document.getElementById("profileForm");
    // Se non siamo nella pagina profilo (o non c'è il form), non fare nulla per evitare errori o chiamate inutili.
    if (!profileForm) {
        return;
    }

    const editBtn = document.getElementById("edit-btn");
    const saveBtn = document.getElementById("save-btn");
    const inputs = document.querySelectorAll("#profile-form input, #profile-form textarea");
    const selects = document.querySelectorAll("#profile-form select");

    await loadUserProfile();

    if (editBtn) {
        editBtn.addEventListener("click", function () {
            toggleEditMode(true);
        });
    }

    if (saveBtn) {
        saveBtn.addEventListener("click", saveProfile);
    }
});

let currentUserData = {};

async function loadUserProfile() {
    try {
        const user = await getMyProfile();
        currentUserData = user;

        const setVal = (id, val) => {
            const el = document.getElementById(id);
            if (el) el.value = val || "";
        };

        setVal("nome", user.nome);
        setVal("cognome", user.cognome);
        setVal("email", user.email);
        setVal("telefono", user.telefono);
        setVal("indirizzo", user.indirizzo);
        setVal("data_nascita", user.datanascita);

        // Update display text elements if they verify existence
        const setText = (id, val) => {
            const el = document.getElementById(id);
            if (el) el.innerText = val || "";
        };

        const dipendenteFields = document.getElementById("dipendente-fields");
        const voluntarioFields = document.getElementById("voluntario-fields");
        const ruoloVisual = document.getElementById("ruolo_visual");

        if (user.ruolo === "DIPENDENTE") {
            if (dipendenteFields) dipendenteFields.style.display = "block";
            if (voluntarioFields) voluntarioFields.style.display = "none";
            if (ruoloVisual) ruoloVisual.innerText = "Dipendente";

            if (user.dipendente) {
                setVal("codice_fiscale", user.dipendente.codice_fiscale);
                setVal("data_assunzione", user.dipendente.data_assunzione);
                setVal("mansione", user.dipendente.mansione);
            }
        } else if (user.ruolo === "VOLONTARIO") {
            if (dipendenteFields) dipendenteFields.style.display = "none";
            if (voluntarioFields) voluntarioFields.style.display = "block";
            if (ruoloVisual) ruoloVisual.innerText = "Volontario";
        }

        renderSkills(user.abilita || []);
        renderPatenti(user.patenti || []);
        renderDisponibilita(user.disponibile);

    } catch (error) {
        Swal.fire("Errore", "Impossibile caricare il profilo.", "error");
    }
}

function renderSkills(skills) {
    const container = document.getElementById("skills-container");
    if (!container) return; // Exit if container doesn't exist

    container.innerHTML = "";

    skills.forEach(s => {
        const span = document.createElement("span");
        span.className = "skill-tag";
        span.innerText = s.nome;
        span.onclick = () => removeSkill(s.nome);
        container.appendChild(span);
    });
}

function renderPatenti(patenti) {
    const list = document.getElementById('patenti-list-items');
    if (!list) return; // Exit if container doesn't exist

    list.innerHTML = '';

    if (!patenti || patenti.length === 0) {
        list.innerHTML = '<p class="text-muted" style="text-align:center;">Nessuna patente inserita.</p>';
        return;
    }

    patenti.forEach((p, index) => {
        const div = document.createElement('div');
        div.className = 'patente-item';

        let formattedDate = 'N/D';
        if (p.conseguita_il) {
            formattedDate = formatDate(p.conseguita_il).split(',')[0];
        }

        div.innerHTML = `
            <div class="patente-header">
                <span class="patente-type">${p.tipo || 'N/D'}</span>
                <button type="button" class="btn-remove-patente" onclick="removePatente(${index})">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="patente-body">
                <div class="patente-field">
                    <label>Rilasciata da:</label>
                    <span>${p.rilasciata_da || 'N/D'}</span>
                </div>
                <div class="patente-field">
                    <label>Data:</label>
                    <span>${formattedDate}</span>
                </div>
            </div>
        `;
        list.appendChild(div);
    });
}

function renderDisponibilita(isAvailable) {
    const badge = document.getElementById("status-badge");
    const toggle = document.getElementById("disponibile-toggle");

    // Only proceed if elements exist
    if (!badge || !toggle) return;

    if (isAvailable) {
        badge.className = "status-badge status-available";
        badge.innerHTML = '<i class="fas fa-check-circle"></i> Disponibile';
        toggle.checked = true;
    } else {
        badge.className = "status-badge status-unavailable";
        badge.innerHTML = '<i class="fas fa-times-circle"></i> Non Disponibile';
        toggle.checked = false;
    }
}

function toggleEditMode(enable) {
    const formInputs = document.querySelectorAll("#profile-form input, #profile-form textarea, #profile-form select");
    const editSection = document.getElementById("edit-actions");
    const viewSection = document.getElementById("view-actions");

    formInputs.forEach(input => {
        if (input.id !== "email" && input.id !== "codice_fiscale") {
            input.disabled = !enable;
        }
    });

    if (enable) {
        editSection.style.display = "flex";
        viewSection.style.display = "none";

        document.getElementById("add-skill-btn").style.display = "inline-flex";
        document.getElementById("add-patente-btn").style.display = "inline-flex";
        document.querySelectorAll(".btn-remove-patente").forEach(b => b.style.display = "block");

    } else {
        editSection.style.display = "none";
        viewSection.style.display = "flex";

        document.getElementById("add-skill-btn").style.display = "none";
        document.getElementById("add-patente-btn").style.display = "none";
        document.querySelectorAll(".btn-remove-patente").forEach(b => b.style.display = "none");
    }
}

async function saveProfile() {
    const nome = document.getElementById("nome").value;
    const cognome = document.getElementById("cognome").value;
    const telefono = document.getElementById("telefono").value;
    const indirizzo = document.getElementById("indirizzo").value;
    const dataNascita = document.getElementById("data_nascita").value;
    const isAvailable = document.getElementById("disponibile-toggle").checked;

    const skillsParams = currentUserData.abilita ? currentUserData.abilita.map(s => s.nome).join(',') : '';

    const patentiDto = (currentUserData.patenti || []).map(p => ({
        tipo: p.tipo,
        conseguita_il: p.conseguita_il,
        rilasciata_da: p.rilasciata_da,
        descrizione: p.descrizione
    }));

    const updateRequest = {
        nome: nome,
        cognome: cognome,
        telefono: telefono,
        indirizzo: indirizzo,
        data_nascita: dataNascita,
        disponibile: isAvailable,
        abilita: skillsParams,
        patenti: patentiDto
    };

    try {
        await updateMyProfile(updateRequest);
        Swal.fire("Successo", "Profilo aggiornato!", "success");
        toggleEditMode(false);
        renderDisponibilita(isAvailable);
    } catch (error) {
        Swal.fire("Errore", "Impossibile aggiornare il profilo: " + error.message, "error");
    }
}

// MANAGEMENT SKILLS
async function openSkillModal() {
    const modal = document.getElementById('skill-modal');
    if (modal) modal.classList.add('active');

    const select = document.getElementById('skill-select');
    if (select) {
        select.innerHTML = '<option value="">Caricamento...</option>';

        try {
            const allSkills = await getAbilita();
            select.innerHTML = '<option value="">-- Seleziona o Scrivi Nuova --</option>';
            allSkills.forEach(s => {
                const opt = document.createElement('option');
                opt.value = s.nome;
                opt.textContent = s.nome;
                select.appendChild(opt);
            });
        } catch (e) {
            select.innerHTML = '<option value="">Errore caricamento</option>';
        }
    }
}

function closeSkillModal() {
    const modal = document.getElementById('skill-modal');
    if (modal) modal.classList.remove('active');

    const input = document.getElementById('new-skill-input');
    if (input) input.value = '';

    const container = document.getElementById('new-skill-container');
    if (container) container.style.display = 'none';
}

const skillSelect = document.getElementById('skill-select');
if (skillSelect) {
    skillSelect.addEventListener('change', function () {
        if (this.value === 'new') {
            // Gestione "Nuova" se prevista
        }
    });
}

const btnConfirmSkill = document.getElementById('btn-confirm-skill');
if (btnConfirmSkill) {
    btnConfirmSkill.addEventListener('click', async () => {
        const select = document.getElementById('skill-select');
        let val = select ? select.value : null;

        const newSkillInput = document.getElementById('new-skill-input');
        if (newSkillInput && newSkillInput.value.trim() !== '') {
            val = newSkillInput.value.trim();
        }

        if (!val) return;

        if (!currentUserData.abilita) currentUserData.abilita = [];
        if (!currentUserData.abilita.find(s => s.nome === val)) {
            currentUserData.abilita.push({ nome: val });
            renderSkills(currentUserData.abilita);
        }
        closeSkillModal();
    });
}

function removeSkill(name) {
    if (!currentUserData.abilita) return;
    currentUserData.abilita = currentUserData.abilita.filter(s => s.nome !== name);
    renderSkills(currentUserData.abilita);
}
// MANAGEMENT PATENTI
function openPatenteModal() {
    const modal = document.getElementById('patente-modal');
    if (modal) {
        modal.classList.add('active');
        const ente = document.getElementById('patente-ente');
        if (ente) ente.value = '';
        const data = document.getElementById('patente-data');
        if (data) data.value = '';
        const tipo = document.getElementById('patente-tipo');
        if (tipo) tipo.value = 'B';
    }
}

function closePatenteModal() {
    const modal = document.getElementById('patente-modal');
    if (modal) modal.classList.remove('active');
}

const btnSavePatente = document.getElementById('btn-save-patente');
if (btnSavePatente) {
    btnSavePatente.addEventListener('click', () => {
        const tipoEl = document.getElementById('patente-tipo');
        const enteEl = document.getElementById('patente-ente');
        const dataEl = document.getElementById('patente-data');

        if (!tipoEl || !enteEl || !dataEl) return;

        const tipo = tipoEl.value;
        const ente = enteEl.value;
        const data = dataEl.value;

        if (!tipo || !ente || !data) {
            Swal.fire('Attenzione', 'Compila tutti i campi', 'warning');
            return;
        }

        if (!currentUserData.patenti) currentUserData.patenti = [];

        currentUserData.patenti = currentUserData.patenti.filter(p => p.tipo !== tipo);

        currentUserData.patenti.push({
            tipo: tipo,
            rilasciata_da: ente,
            conseguita_il: data,
            descrizione: ''
        });

        renderPatenti(currentUserData.patenti);
        closePatenteModal();
    });
}

function removePatente(index) {
    currentUserData.patenti.splice(index, 1);
    renderPatenti(currentUserData.patenti);
}
