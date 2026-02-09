<#import "layout.ftl" as layout>

<@layout.pagina_operatore titolo="Pannello Operatore">
    <div class="operatore-dashboard">
        <!-- Colonna sinistra: Menu principale -->
        <div class="menu-section">
            <h2 class="section-title">Azioni Rapide</h2>
            <div class="menu-grid-single">
                <a href="/operatore/profilo" class="menu-card">
                    <i class="fa-solid fa-user-gear"></i>
                    <div class="menu-card-content">
                        <span>Il Mio Profilo</span>
                        <small>Gestisci abilità e informazioni</small>
                    </div>
                </a>

                <a href="#" class="menu-card card-highlight" id="btn-apri-missioni">
                    <i class="fa-solid fa-map-location-dot"></i>
                    <div class="menu-card-content">
                        <span>Le Mie Missioni</span>
                        <small>Visualizza le missioni assegnate</small>
                    </div>
                </a>
            </div>
        </div>

        <!-- Colonna destra: Pannello missioni recenti -->
        <div class="missioni-panel">
            <div class="panel-header">
                <h3><i class="fas fa-route"></i> Missioni Recenti</h3>
                <a href="#" id="btn-vedi-tutte" class="btn-text">Vedi tutte</a>
            </div>

            <div class="missioni-feed" id="missioni-feed">
                <div class="loading-spinner"><i class="fas fa-spinner fa-spin"></i></div>
            </div>
        </div>
    </div>

    <!-- MODALE MISSIONI -->
    <div class="modal-overlay" id="modal-missioni">
        <div class="modal-container">
            <div class="modal-header">
                <h2><i class="fas fa-map-location-dot"></i> Le Tue Missioni</h2>
                <button class="modal-close" id="close-modal-missioni">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <!-- Filtri -->
            <div class="modal-filtri">
                <div class="filtri-group">
                    <button class="filtro-btn active" data-stato="tutte">
                        <i class="fas fa-list"></i> Tutte
                    </button>
                    <button class="filtro-btn" data-stato="in_corso">
                        <i class="fas fa-circle-dot"></i> In Corso
                    </button>
                    <button class="filtro-btn" data-stato="completata">
                        <i class="fas fa-check-circle"></i> Completate
                    </button>
                    <button class="filtro-btn" data-stato="annullata">
                        <i class="fas fa-times-circle"></i> Annullate
                    </button>
                </div>

                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="search-missioni" placeholder="Cerca per luogo o tipo...">
                </div>
            </div>

            <!-- Lista Missioni nel Modale -->
            <div class="modal-body">
                <div class="missioni-modal-list" id="missioni-modal-list">
                    <div class="loading-spinner">
                        <i class="fas fa-spinner fa-spin"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- MODALE DETTAGLIO MISSIONE -->
    <div class="modal-overlay" id="modal-dettaglio">
        <div class="modal-container modal-large">
            <div class="modal-header">
                <h2><i class="fas fa-info-circle"></i> Dettaglio Missione</h2>
                <button class="modal-close" id="close-modal-dettaglio">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div class="modal-body" id="dettaglio-content">
                <div class="loading-spinner">
                    <i class="fas fa-spinner fa-spin"></i>
                </div>
            </div>
        </div>
    </div>
</@layout.pagina_operatore>
