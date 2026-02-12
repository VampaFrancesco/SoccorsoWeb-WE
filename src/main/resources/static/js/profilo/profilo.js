document.addEventListener("DOMContentLoaded", async function () {
    const profileForm = document.getElementById("profileForm");
    // Se non siamo nella pagina profilo (o non c'è il form), non fare nulla per evitare errori o chiamate inutili.
    if (!profileForm) {
        return;
    }

    await loadUserProfile();

    // Intercetta il submit del form per salvare via AJAX
    profileForm.addEventListener("submit", async function (e) {
        e.preventDefault();
        await saveProfile();
    });
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

        // data_nascita: Jackson può serializzare LocalDate come array [YYYY,MM,DD] o stringa "YYYY-MM-DD"
        // Il campo type="date" richiede formato "YYYY-MM-DD"
        if (user.data_nascita) {
            let dateStr;
            if (Array.isArray(user.data_nascita)) {
                // Formato array: [2000, 1, 15]
                const [y, m, d] = user.data_nascita;
                dateStr = `${y}-${String(m).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
            } else {
                // Formato stringa: "2000-01-15"
                dateStr = String(user.data_nascita).substring(0, 10);
            }
            setVal("data_nascita", dateStr);
        }

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
    const nome = document.getElementById("nome")?.value || '';
    const cognome = document.getElementById("cognome")?.value || '';
    const telefono = document.getElementById("telefono")?.value || '';
    const indirizzo = document.getElementById("indirizzo")?.value || '';
    const dataNascita = document.getElementById("data_nascita")?.value || null;

    // Disponibilità: potrebbe non essere nel template
    const disponibileToggle = document.getElementById("disponibile-toggle");
    const isAvailable = disponibileToggle ? disponibileToggle.checked : currentUserData.disponibile;

    // Abilità: dal campo hidden o dai dati correnti
    const abilitaHidden = document.getElementById("abilita");
    const skillsParams = abilitaHidden && abilitaHidden.value
        ? abilitaHidden.value
        : (currentUserData.abilita ? currentUserData.abilita.map(s => s.nome).join(',') : '');

    // Patenti: dal campo hidden (JSON) o dai dati correnti
    const patentiHidden = document.getElementById("patenti");
    let patentiDto;
    if (patentiHidden && patentiHidden.value) {
        try {
            patentiDto = JSON.parse(patentiHidden.value);
        } catch (e) {
            patentiDto = (currentUserData.patenti || []).map(p => ({
                tipo: p.tipo,
                conseguita_il: p.conseguita_il,
                rilasciata_da: p.rilasciata_da,
                descrizione: p.descrizione
            }));
        }
    } else {
        patentiDto = (currentUserData.patenti || []).map(p => ({
            tipo: p.tipo,
            conseguita_il: p.conseguita_il,
            rilasciata_da: p.rilasciata_da,
            descrizione: p.descrizione
        }));
    }

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
        // Ricarica il profilo per aggiornare la UI
        await loadUserProfile();
    } catch (error) {
        Swal.fire("Errore", "Impossibile aggiornare il profilo: " + (error.message || error), "error");
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

// =====================================================
// MODAL ABILITÀ (nuovo template)
// =====================================================

let tutteLeAbilitaDisponibili = [];
let abilitaSelezionateTemp = [];

async function apriModaleAbilita() {
    const modal = document.getElementById('modal-abilita');
    if (!modal) return;
    modal.classList.add('active');

    // Copia le abilità attuali dell'utente come selezione temporanea
    abilitaSelezionateTemp = (currentUserData.abilita || []).map(a => ({ ...a }));
    renderAbilitaSelezionateModal();

    // Carica abilità disponibili dal server
    const container = document.getElementById('abilita-disponibili');
    if (container) container.innerHTML = '<p class="text-muted">Caricamento...</p>';

    try {
        tutteLeAbilitaDisponibili = await getAbilita();
        renderAbilitaDisponibili();
    } catch (e) {
        if (container) container.innerHTML = '<p class="text-muted">Errore nel caricamento.</p>';
    }
}

function chiudiModaleAbilita() {
    const modal = document.getElementById('modal-abilita');
    if (modal) modal.classList.remove('active');
}

function renderAbilitaSelezionateModal() {
    const container = document.getElementById('abilita-selezionate');
    if (!container) return;

    if (abilitaSelezionateTemp.length === 0) {
        container.innerHTML = '<p class="text-muted">Nessuna abilità selezionata</p>';
        return;
    }

    container.innerHTML = abilitaSelezionateTemp.map((a, i) => `
        <span class="chip selected" onclick="rimuoviAbilitaTemp(${i})">
            ${a.nome} <i class="fas fa-times"></i>
        </span>
    `).join('');
}

function rimuoviAbilitaTemp(index) {
    abilitaSelezionateTemp.splice(index, 1);
    renderAbilitaSelezionateModal();
    renderAbilitaDisponibili();
}

function renderAbilitaDisponibili(filtro) {
    const container = document.getElementById('abilita-disponibili');
    if (!container) return;

    let lista = tutteLeAbilitaDisponibili.filter(a =>
        !abilitaSelezionateTemp.find(s => s.nome === a.nome)
    );

    if (filtro && filtro.trim() !== '') {
        const f = filtro.toLowerCase();
        lista = lista.filter(a => a.nome.toLowerCase().includes(f));
    }

    if (lista.length === 0) {
        container.innerHTML = '<p class="text-muted">Nessuna abilità disponibile</p>';
        return;
    }

    container.innerHTML = lista.map(a => `
        <div class="abilita-item" onclick="aggiungiAbilitaTemp('${a.nome.replace(/'/g, "\\'")}')">
            <span>${a.nome}</span>
            <i class="fas fa-plus"></i>
        </div>
    `).join('');
}

function aggiungiAbilitaTemp(nome) {
    if (!abilitaSelezionateTemp.find(a => a.nome === nome)) {
        abilitaSelezionateTemp.push({ nome: nome });
        renderAbilitaSelezionateModal();
        renderAbilitaDisponibili(document.getElementById('search-abilita')?.value);
    }
}

function filtraAbilita() {
    const val = document.getElementById('search-abilita')?.value || '';
    renderAbilitaDisponibili(val);
}

async function creaNuovaAbilita() {
    const nomeInput = document.getElementById('nuova-abilita-nome');
    const descInput = document.getElementById('nuova-abilita-desc');
    const nome = nomeInput?.value?.trim();
    const desc = descInput?.value?.trim();

    if (!nome) {
        Swal.fire('Attenzione', 'Inserisci un nome per l\'abilità', 'warning');
        return;
    }

    try {
        await creaNuovaAbilitaApi({ nome: nome, descrizione: desc || '' });
        tutteLeAbilitaDisponibili.push({ nome: nome, descrizione: desc || '' });
        aggiungiAbilitaTemp(nome);
        if (nomeInput) nomeInput.value = '';
        if (descInput) descInput.value = '';
        Swal.fire({ icon: 'success', title: 'Abilità creata!', timer: 1500, showConfirmButton: false });
    } catch (e) {
        Swal.fire('Errore', 'Impossibile creare l\'abilità: ' + (e.message || ''), 'error');
    }
}

function salvaAbilitaSelezionate() {
    currentUserData.abilita = [...abilitaSelezionateTemp];

    // Aggiorna la tabella nella pagina
    const tbody = document.getElementById('abilita-tbody');
    if (tbody) {
        tbody.innerHTML = currentUserData.abilita.map((a, i) => `
            <tr>
                <td>${a.nome}</td>
                <td>${a.descrizione || ''}</td>
                <td>${a.livello || '-'}</td>
                <td><button type="button" class="btn-remove-small" onclick="rimuoviAbilitaDaTabella(${i})"><i class="fas fa-trash"></i></button></td>
            </tr>
        `).join('');
    }

    // Aggiorna il campo hidden
    const hiddenInput = document.getElementById('abilita');
    if (hiddenInput) {
        hiddenInput.value = currentUserData.abilita.map(a => a.nome).join(',');
    }

    chiudiModaleAbilita();
}

function rimuoviAbilitaDaTabella(index) {
    if (currentUserData.abilita) {
        currentUserData.abilita.splice(index, 1);
        salvaAbilitaSelezionate(); // re-render
        apriModaleAbilita(); // Don't re-open
    }
    // Just re-render table
    const tbody = document.getElementById('abilita-tbody');
    if (tbody && currentUserData.abilita) {
        tbody.innerHTML = currentUserData.abilita.map((a, i) => `
            <tr>
                <td>${a.nome}</td>
                <td>${a.descrizione || ''}</td>
                <td>${a.livello || '-'}</td>
                <td><button type="button" class="btn-remove-small" onclick="rimuoviAbilitaDaTabella(${i})"><i class="fas fa-trash"></i></button></td>
            </tr>
        `).join('');
    }
}

// =====================================================
// MODAL PATENTI (nuovo template)
// =====================================================

let tutteLePatentiDisponibili = [];
let patentiSelezionateTemp = [];

async function apriModalePatenti() {
    const modal = document.getElementById('modal-patenti');
    if (!modal) return;
    modal.classList.add('active');

    // Copia le patenti attuali dell'utente
    patentiSelezionateTemp = (currentUserData.patenti || []).map(p => ({ ...p }));
    renderPatentiSelezionateModal();

    // Carica patenti disponibili dal server
    const container = document.getElementById('patenti-disponibili');
    if (container) container.innerHTML = '<p class="text-muted">Caricamento...</p>';

    try {
        tutteLePatentiDisponibili = await getPatenti();
        renderPatentiDisponibili();
    } catch (e) {
        if (container) container.innerHTML = '<p class="text-muted">Errore nel caricamento.</p>';
    }
}

function chiudiModalePatenti() {
    const modal = document.getElementById('modal-patenti');
    if (modal) modal.classList.remove('active');
}

function renderPatentiSelezionateModal() {
    const container = document.getElementById('patenti-selezionate-dettagli');
    if (!container) return;

    if (patentiSelezionateTemp.length === 0) {
        container.innerHTML = '<p class="text-muted">Nessuna patente selezionata</p>';
        return;
    }

    container.innerHTML = patentiSelezionateTemp.map((p, i) => `
        <div class="patente-detail-card">
            <div class="patente-detail-header">
                <strong>${p.tipo}</strong>
                <button type="button" class="btn-remove-small" onclick="rimuoviPatenteTemp(${i})">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="patente-detail-body">
                <div class="form-row" style="gap: 10px;">
                    <div class="form-group" style="flex:1;">
                        <label>Conseguita il</label>
                        <input type="date" class="form-control" value="${p.conseguita_il || ''}"
                               onchange="patentiSelezionateTemp[${i}].conseguita_il = this.value">
                    </div>
                    <div class="form-group" style="flex:1;">
                        <label>Rilasciata da</label>
                        <input type="text" class="form-control" value="${p.rilasciata_da || ''}"
                               placeholder="Ente rilascio"
                               onchange="patentiSelezionateTemp[${i}].rilasciata_da = this.value">
                    </div>
                </div>
            </div>
        </div>
    `).join('');
}

function rimuoviPatenteTemp(index) {
    patentiSelezionateTemp.splice(index, 1);
    renderPatentiSelezionateModal();
    renderPatentiDisponibili();
}

function renderPatentiDisponibili(filtro) {
    const container = document.getElementById('patenti-disponibili');
    if (!container) return;

    let lista = tutteLePatentiDisponibili.filter(p =>
        !patentiSelezionateTemp.find(s => s.tipo === p.tipo)
    );

    if (filtro && filtro.trim() !== '') {
        const f = filtro.toLowerCase();
        lista = lista.filter(p => p.tipo.toLowerCase().includes(f));
    }

    if (lista.length === 0) {
        container.innerHTML = '<p class="text-muted">Nessuna patente disponibile</p>';
        return;
    }

    container.innerHTML = lista.map(p => `
        <div class="abilita-item" onclick="aggiungiPatenteTemp('${p.tipo.replace(/'/g, "\\'")}')">
            <span>${p.tipo}</span>
            <i class="fas fa-plus"></i>
        </div>
    `).join('');
}

function aggiungiPatenteTemp(tipo) {
    if (!patentiSelezionateTemp.find(p => p.tipo === tipo)) {
        patentiSelezionateTemp.push({ tipo: tipo, conseguita_il: '', rilasciata_da: '', descrizione: '' });
        renderPatentiSelezionateModal();
        renderPatentiDisponibili(document.getElementById('search-patenti')?.value);
    }
}

function filtraPatenti() {
    const val = document.getElementById('search-patenti')?.value || '';
    renderPatentiDisponibili(val);
}

async function creaNuovaPatente() {
    const tipoInput = document.getElementById('nuova-patente-tipo');
    const tipo = tipoInput?.value?.trim();

    if (!tipo) {
        Swal.fire('Attenzione', 'Inserisci il tipo di patente', 'warning');
        return;
    }

    try {
        await creaNuovaPatenteApi({ tipo: tipo });
        tutteLePatentiDisponibili.push({ tipo: tipo });
        aggiungiPatenteTemp(tipo);
        if (tipoInput) tipoInput.value = '';
        Swal.fire({ icon: 'success', title: 'Patente creata!', timer: 1500, showConfirmButton: false });
    } catch (e) {
        Swal.fire('Errore', 'Impossibile creare la patente: ' + (e.message || ''), 'error');
    }
}

function salvaPatentiSelezionate() {
    currentUserData.patenti = [...patentiSelezionateTemp];

    // Aggiorna la tabella nella pagina
    const tbody = document.getElementById('patenti-tbody');
    if (tbody) {
        tbody.innerHTML = currentUserData.patenti.map((p, i) => {
            let formattedDate = p.conseguita_il || '-';
            return `
                <tr>
                    <td>${p.tipo}</td>
                    <td>${p.descrizione || '-'}</td>
                    <td>${formattedDate}</td>
                    <td>${p.rilasciata_da || '-'}</td>
                    <td><button type="button" class="btn-remove-small" onclick="rimuoviPatenteDaTabella(${i})"><i class="fas fa-trash"></i></button></td>
                </tr>
            `;
        }).join('');
    }

    // Aggiorna il campo hidden
    const hiddenInput = document.getElementById('patenti');
    if (hiddenInput) {
        hiddenInput.value = JSON.stringify(currentUserData.patenti);
    }

    chiudiModalePatenti();
}

function rimuoviPatenteDaTabella(index) {
    if (currentUserData.patenti) {
        currentUserData.patenti.splice(index, 1);
    }
    const tbody = document.getElementById('patenti-tbody');
    if (tbody && currentUserData.patenti) {
        tbody.innerHTML = currentUserData.patenti.map((p, i) => {
            return `
                <tr>
                    <td>${p.tipo}</td>
                    <td>${p.descrizione || '-'}</td>
                    <td>${p.conseguita_il || '-'}</td>
                    <td>${p.rilasciata_da || '-'}</td>
                    <td><button type="button" class="btn-remove-small" onclick="rimuoviPatenteDaTabella(${i})"><i class="fas fa-trash"></i></button></td>
                </tr>
            `;
        }).join('');
    }
}

