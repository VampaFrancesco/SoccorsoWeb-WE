<#import "layout.ftl" as layout>

<@layout.pagina_operatore
titolo="Il Mio Profilo"
nomeUtente=nomeUtente!"Operatore"
extraHead='<link rel="stylesheet" href="/css/profilo.css">'
extraScripts='<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script><script src="/js/profilo/profilo.js?v=2"></script>'>

    <div class="profile-grid">

        <!-- Card Sinistra: Informazioni Visualizzazione -->
        <div class="profile-card">
            <!-- Cover superiore -->
            <div class="profile-cover"></div>

            <!-- Avatar -->
            <div class="profile-avatar-container">
                <div class="avatar-circle">
                    ${(user.nome!"O")?substring(0,1)}${(user.cognome!"")?substring(0,1)}
                </div>
            </div>

            <!-- Informazioni Centrali -->
            <div class="profile-info-center">
                <h2 id="display-fullname">${(user.nome)!} ${(user.cognome)!}</h2>
                <span class="role-badge">
                    <#if user?? && user.roles??>
                        <#list user.roles as role>${role.name}<#sep>, </#list>
                    <#else>
                        Operatore
                    </#if>
                </span>
            </div>

            <!-- Contatti -->
            <div class="profile-contacts">
                <div class="contact-item">
                    <i class="fas fa-envelope"></i>
                    <span id="display-email">${(user.email)!"N/D"}</span>
                </div>
                <div class="contact-item">
                    <i class="fas fa-phone"></i>
                    <span id="display-phone">${(user.telefono)!"N/D"}</span>
                </div>
            </div>
        </div>

        <!-- Card Destra: Form Modifica -->
        <div class="profile-details-card">

            <h3 class="section-title">
                <i class="fas fa-user text-accent"></i>
                Informazioni Personali
            </h3>

            <form id="profileForm" data-user-id="${(user.id)!}">
                <!-- Dati Anagrafici -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="nome">Nome</label>
                        <input type="text" id="nome" name="nome" class="form-control readonly" value="${(user.nome)!}" readonly>
                    </div>
                    <div class="form-group">
                        <label for="cognome">Cognome</label>
                        <input type="text" id="cognome" name="cognome" class="form-control readonly" value="${(user.cognome)!}" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <label for="data_nascita">Data di Nascita</label>
                    <input type="text" id="data_nascita" name="dataNascita" class="form-control readonly" readonly>
                </div>

                <div class="form-group">
                    <label for="indirizzo">Indirizzo</label>
                    <input type="text" id="indirizzo" name="indirizzo" class="form-control" value="${(user.indirizzo)!}">
                </div>

                <div class="form-group">
                    <label for="telefono">Telefono</label>
                    <input type="text" id="telefono" name="telefono" class="form-control" value="${(user.telefono)!}">
                </div>

                <hr class="divider">

                <!-- Campi Modificabili -->
                <h3 class="section-title">
                    <i class="fas fa-edit text-accent"></i>
                    Informazioni Extra
                </h3>

                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                        <label for="abilita" style="margin-bottom: 0;">Abilità e Competenze</label>
                        <button type="button" class="btn-secondary btn-sm" onclick="apriModaleAbilita()">
                            <i class="fas fa-plus"></i> Aggiungi
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table class="table-custom" id="tabella-abilita">
                            <thead>
                                <tr>
                                    <th>Nome</th>
                                    <th>Descrizione</th>
                                    <th>Livello</th>
                                    <th style="width: 50px;"></th>
                                </tr>
                            </thead>
                            <tbody id="abilita-tbody">
                                <!-- Le righe vengono caricate via JS -->
                            </tbody>
                        </table>
                    </div>
                    <input type="hidden" id="abilita" name="abilita" value="">
                </div>

                <div class="form-group" style="margin-top: 30px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                        <label for="patenti" style="margin-bottom: 0;">Patenti e Certificazioni</label>
                        <button type="button" class="btn-secondary btn-sm" onclick="apriModalePatenti()">
                            <i class="fas fa-plus"></i> Aggiungi
                        </button>
                    </div>
                    <div class="table-responsive">
                       <table class="table-custom" id="tabella-patenti">
                            <thead>
                                <tr>
                                    <th>Tipo</th>
                                    <th>Descrizione</th>
                                    <th>Conseguita Il</th>
                                    <th>Rilasciata Da</th>
                                    <th style="width: 50px;"></th>
                                </tr>
                            </thead>
                            <tbody id="patenti-tbody">
                                <!-- Le righe vengono caricate via JS -->
                            </tbody>
                        </table>
                    </div>
                    <input type="hidden" id="patenti" name="patenti" value="">
                </div>

                <!-- Pulsante Salva -->
                <div class="form-actions">
                    <button type="submit" class="btn-save">
                        <i class="fas fa-save"></i>
                        Salva Modifiche
                    </button>
                </div>
            </form>

        </div>

    </div>

    <div id="modal-abilita" class="modal-overlay">
        <div class="modal-content modal-lg">
            <div class="modal-header">
                <h3><i class="fas fa-tools"></i> Gestisci Abilità</h3>
                <button class="modal-close" onclick="chiudiModaleAbilita()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <!-- Abilità Selezionate -->
                <div class="abilita-section">
                    <h4>Le tue abilità</h4>
                    <div id="abilita-selezionate" class="abilita-chips">
                        <p class="text-muted">Nessuna abilità selezionata</p>
                    </div>
                </div>

                <hr class="divider">

                <!-- Abilità Disponibili -->
                <div class="abilita-section">
                    <h4>Abilità disponibili</h4>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="search-abilita" placeholder="Cerca abilità..." oninput="filtraAbilita()">
                    </div>
                    <div id="abilita-disponibili" class="abilita-list">
                        <p class="text-muted">Caricamento...</p>
                    </div>
                </div>

                <hr class="divider">

                <!-- Crea Nuova Abilità -->
                <div class="abilita-section">
                    <h4>Crea nuova abilità</h4>
                    <div class="new-abilita-form">
                        <input type="text" id="nuova-abilita-nome" placeholder="Nome abilità" class="form-control">
                        <input type="text" id="nuova-abilita-desc" placeholder="Descrizione (opzionale)" class="form-control">
                        <button type="button" class="btn-primary" onclick="creaNuovaAbilita()">
                            <i class="fas fa-plus"></i> Aggiungi
                        </button>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="chiudiModaleAbilita()">Chiudi</button>
                <button type="button" class="btn-primary" onclick="salvaAbilitaSelezionate()">
                    <i class="fas fa-check"></i> Conferma Selezione
                </button>
            </div>
        </div>
    </div>

    <!-- Modal Gestione Patenti -->
    <div id="modal-patenti" class="modal-overlay">
        <div class="modal-content modal-lg">
            <div class="modal-header">
                <h3><i class="fas fa-id-card"></i> Gestisci Patenti</h3>
                <button class="modal-close" onclick="chiudiModalePatenti()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <!-- Patenti Selezionate (con dettagli) -->
                <div class="abilita-section">
                    <h4>Le tue patenti selezionate</h4>
                    <div id="patenti-selezionate-dettagli" class="patenti-list-details">
                        <!-- Qui verranno iniettati i form per i dettagli di ogni patente selezionata -->
                        <p class="text-muted">Nessuna patente selezionata</p>
                    </div>
                </div>

                <hr class="divider">

                <!-- Patenti Disponibili -->
                <div class="abilita-section">
                    <h4>Aggiungi patente da elenco</h4>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="search-patenti" placeholder="Cerca tipo patente..." oninput="filtraPatenti()">
                    </div>
                    <div id="patenti-disponibili" class="abilita-list">
                        <p class="text-muted">Caricamento...</p>
                    </div>
                </div>

                <hr class="divider">

                <!-- Crea Nuova Patente -->
                <div class="abilita-section">
                    <h4>Crea nuova tipologia patente</h4>
                    <div class="new-abilita-form">
                        <input type="text" id="nuova-patente-tipo" placeholder="Tipo patente (es. B, C, Nautica)" class="form-control">
                        <button type="button" class="btn-primary" onclick="creaNuovaPatente()">
                            <i class="fas fa-plus"></i> Crea
                        </button>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="chiudiModalePatenti()">Chiudi</button>
                <button type="button" class="btn-primary" onclick="salvaPatentiSelezionate()">
                    <i class="fas fa-check"></i> Conferma Selezione
                </button>
            </div>
        </div>
    </div>

</@layout.pagina_operatore>
