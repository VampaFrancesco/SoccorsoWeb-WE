<#import "layout.ftl" as layout>

<@layout.pagina_admin titolo="Gestione Richieste" nomeUtente=nomeUtente!"Admin" extraScripts='<script src="/js/admin/richieste.js"></script>'>
    <main>
        <header class="top-header">
            <div class="filter-bar">
                <button class="filter-btn active" data-filter="ATTIVA">
                    <i class="fas fa-bell"></i> Nuove
                </button>
                <button class="filter-btn" data-filter="IN_CORSO">
                    <i class="fas fa-clock"></i> In Corso
                </button>
                <button class="filter-btn" data-filter="CHIUSA">
                    <i class="fas fa-check-circle"></i> Concluse
                </button>
                <button class="filter-btn" data-filter="IGNORATA">
                    <i class="fas fa-ban"></i> Ignorate
                </button>
            </div>
        </header>

        <div class="table-container card">
            <table class="modern-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Segnalante</th>
                    <th>Data Convalida</th>
                    <th>Indirizzo</th>
                    <th>Descrizione</th>
                    <th>Azioni</th>
                </tr>
                </thead>
                <tbody id="requests-body">
                </tbody>
            </table>
            <div id="no-data" class="empty-state" style="display: none;">
                <i class="fas fa-clipboard-list"></i>
                <p>Nessuna richiesta trovata per questo stato.</p>
            </div>
        </div>
    </main>

    <!-- Modal Dettagli Richiesta -->
    <div id="modal-dettagli-richiesta" class="modal-overlay">
        <div class="modal-dialog modal-lg">
            <div class="modal-header">
                <h2><i class="fas fa-info-circle"></i> Dettagli Richiesta</h2>
                <button class="modal-close" onclick="closeRichiestaModal()">&times;</button>
            </div>
            <div class="modal-body" id="richiesta-dettagli-content">
            </div>
        </div>
    </div>
</@layout.pagina_admin>