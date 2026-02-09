<#import "layout.ftl" as layout>

<@layout.pagina_admin titolo="Gestione Operatori" nomeUtente=nomeUtente!"Admin" extraScripts='<script src="/js/admin/operatori.js"></<script>'>
    <main>
        <header class="top-header">
            <div class="filter-bar">
                <button class="filter-btn active" data-filter="tutti">
                    <i class="fas fa-users"></i> Tutti
                </button>
                <button class="filter-btn" data-filter="disponibili">
                    <i class="fas fa-check-circle"></i> Disponibili
                </button>
                <button class="filter-btn" data-filter="occupati">
                    <i class="fas fa-tasks"></i> Occupati
                </button>
            </div>
        </header>

        <div class="table-container card">
            <table class="modern-table">
                <thead>
                    <tr>
                        <th>Operatore</th>
                        <th>Stato</th>
                        <th>Missione Attuale</th>
                        <th>Azioni</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="loading-row">
                        <td colspan="4" style="text-align: center; padding: 40px 18px;">
                            <i class="fas fa-spinner fa-spin"></i> Caricamento...
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </main>
</@layout.pagina_admin>

