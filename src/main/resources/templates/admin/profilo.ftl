<#import "layout.ftl" as layout>

<@layout.pagina_admin
titolo="Il Mio Profilo"
nomeUtente=nomeUtente!"Admin"
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
                    ${(user.nome!"A")?substring(0,1)}${(user.cognome!"")?substring(0,1)}
                </div>
            </div>

            <!-- Informazioni Centrali -->
            <div class="profile-info-center">
                <h2 id="display-fullname">${(user.nome)!} ${(user.cognome)!}</h2>
                <span class="role-badge">
                    <#if user?? && user.roles??>
                        <#list user.roles as role>${role.name}<#sep>, </#list>
                    <#else>
                        Utente
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

            <!-- Setup data attributes for JS to use if needed -->
            <form id="profileForm" data-user-id="${(user.id)!}">
                <!-- Dati Anagrafici (Read-Only) -->
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
                    <label for="indirizzo">Indirizzo</label>
                    <input type="text" id="indirizzo" name="indirizzo" class="form-control" value="${(user.indirizzo)!}">
                </div>

                <div class="form-group">
                    <label for="telefono">Telefono</label>
                     <input type="text" id="telefono" name="telefono" class="form-control" value="${(user.telefono)!}">
                </div>

                <div class="form-group">
                    <label for="data_nascita">Data di Nascita</label>
                    <input type="date" id="data_nascita" name="dataNascita" class="form-control readonly" value="${(user.dataNascita)!}" readonly>
                </div>

                <hr class="divider">

                <!-- Campi Modificabili -->
                <h3 class="section-title">
                    <i class="fas fa-edit text-accent"></i>
                    Informazioni Extra
                </h3>

                <div class="form-group">
                    <label for="abilita">Abilità e Competenze</label>
                    <p class="help-text">Clicca per gestire le tue abilità</p>
                    <div id="abilita-tags" class="abilita-tags-container">
                        <#-- Le abilità vengono caricate via JS -->
                    </div>
                    <button type="button" class="btn-secondary" id="btn-gestisci-abilita" onclick="apriModaleAbilita()">
                        <i class="fas fa-plus"></i> Gestisci Abilità
                    </button>
                    <input type="hidden" id="abilita" name="abilita" value="">
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

    <!-- Modal Gestione Abilità -->
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

</@layout.pagina_admin>
