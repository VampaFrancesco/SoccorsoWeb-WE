<#import "layout.ftl" as layout>

<@layout.pagina_operatore titolo="Pannello Operatore">
    <div class="menu-grid">
        <a href="/operatore/profilo" class="menu-card">
            <i class="fa-solid fa-user-astronaut"></i>
            <span>Profilo</span>
        </a>

        <a href="/operatore/richieste" class="menu-card">
            <#-- Il badge può essere reso dinamico tramite una variabile passata dal controller -->
            <#if notifiche?? && notifiche > 0>
                <div class="badge">${notifiche}</div>
            </#if>
            <i class="fa-solid fa-bell"></i>
            <span>Richieste</span>
        </a>

        <a href="/operatore/missioni" class="menu-card">
            <i class="fa-solid fa-map-location-dot"></i>
            <span>Missioni</span>
        </a>

        <a href="/operatore/mezzi" class="menu-card">
            <i class="fa-solid fa-truck-medical"></i>
            <span>Mezzi</span>
        </a>

        <a href="/operatore/materiali" class="menu-card">
            <i class="fa-solid fa-kit-medical"></i>
            <span>Materiali</span>
        </a>
    </div>
</@layout.pagina_operatore>