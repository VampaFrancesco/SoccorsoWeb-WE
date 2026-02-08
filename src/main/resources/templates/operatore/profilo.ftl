<#import "layout.ftl" as layout>

<@layout.pagina_operatore
titolo="Il Mio Profilo"
nomeUtente=nomeUtente!"Operatore"
extraHead='<link rel="stylesheet" href="/css/profilo.css">'
extraScripts='<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script><script src="/js/profilo/profilo.js"></script>'>

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
                    <p class="help-text">Elenco abilità (Separate da virgola)</p>
                     <#-- Convert set of abilita to comma string -->
                    <#assign abilitaStr = "">
                    <#if user?? && user.abilita??>
                         <#list user.abilita as ab>
                             <#assign abilitaStr = abilitaStr + ab.nome + ", ">
                         </#list>
                    </#if>
                    <input type="text" id="abilita" class="form-control" placeholder="Abilità..." value="${abilitaStr}" readonly>
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

</@layout.pagina_operatore>
