<#import "layout.ftl" as layout>

<@layout.pagina_admin titolo="Panoramica Operativa" nomeUtente=nomeUtente!"Admin">
    <div class="dashboard-grid">

        <div class="widget widget-requests">
            <div class="widget-header">
                <h3><i class="fas fa-exclamation-circle text-danger"></i> Richieste in arrivo</h3>
                <a href="/admin/richieste" class="btn-text">Vedi tutte</a>
            </div>
            <div class="requests-feed" id="requests-feed">
                <div class="loading-spinner"><i class="fas fa-spinner fa-spin"></i></div>
            </div>
        </div>

        <div class="widget widget-stat">
            <div class="stat-icon bg-blue"><i class="fas fa-map-marker-alt"></i></div>
            <div class="stat-info">
                <span class="stat-value" id="stat-missioni">--</span>
                <span class="stat-label">Missioni in corso</span>
            </div>
            <a href="/admin/missioni" class="overlay-link"></a>
        </div>

        <div class="widget widget-stat">
            <div class="stat-icon bg-green"><i class="fas fa-user-clock"></i></div>
            <div class="stat-info">
                <span class="stat-value" id="stat-operatori">--</span>
                <span class="stat-label">Operatori Pronti</span>
            </div>
            <a href="/admin/operatori" class="overlay-link"></a>
        </div>

        <!-- WIDGET 4: PROFILO -->
        <div class="widget widget-stat">
            <div class="stat-icon bg-purple"><i class="fas fa-user"></i></div>
            <div class="stat-info">
                <span class="stat-value">Tu</span>
                <span class="stat-label">Profilo</span>
            </div>
            <a href="/admin/profilo" class="overlay-link"></a>
        </div>

        <!-- WIDGET 5: AZIONI RAPIDE -->
        <div class="widget widget-actions">
            <h3>Azioni Rapide</h3>
            <div class="action-buttons">
                <a href="/admin/aggiungi-utente" class="btn-quick"><i class="fas fa-user-plus"></i> Registra Operatore</a>
                <a href="/admin/materiali" class="btn-quick"><i class="fas fa-notes-medical"></i> Check Materiali</a>
            </div>
        </div>
        <!-- WIDGET 6: MEZZI -->
        <div class="widget widget-stat">
            <div class="stat-icon bg-orange"><i class="fas fa-ambulance"></i></div>
            <div class="stat-info">dash
                <span class="stat-value" id="stat-mezzi">--</span>
                <span class="stat-label">Mezzi Disponibili</span>
            </div>
            <a href="/admin/mezzi" class="overlay-link"></a>
        </div>
    </div>
</@layout.pagina_admin>