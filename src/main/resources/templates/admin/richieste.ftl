<#import "layout.ftl" as layout>

<@layout.pagina_admin titolo="Gestione Richieste" nomeUtente=nomeUtente!"Admin" extraScripts='<script src="/js/admin/richieste.js"></script>'>
    <main>
        <header class="top-header">
            <div class="header-title">
                <h1>Richieste di Soccorso</h1>
                <p>Monitoraggio emergenze e assegnazione missioni</p>
            </div>
            <div class="filter-bar">
                <button class="filter-btn active" onclick="loadRichieste('ATTIVA')">Nuove (Attive)</button>
                <button class="filter-btn" onclick="loadRichieste('IN_CORSO')">In Corso</button>
                <button class="filter-btn" onclick="loadRichieste('CHIUSA')">Concluse</button>
                <button class="filter-btn" onclick="loadRichieste('IGNORATA')">Ignorate</button>
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
                    <th>Stato</th>
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
</@layout.pagina_admin>