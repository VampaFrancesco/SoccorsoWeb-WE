<#import "layout.ftl" as layout>

<@layout.pagina_operatore titolo="Le Mie Missioni">
    <div class="content-section">
        <div id="missioniContainer" class="missioni-list-container">
            <#-- Spinner di caricamento -->
            <div class="loading-state">
                <i class="fas fa-spinner fa-spin"></i> Caricamento missioni...
            </div>
        </div>
    </div>

    <script>
        // Questa è la variabile che mancava!
        // Se opId è null nel controller, qui diventerà una stringa vuota
        const INITIAL_OPERATORE_ID = "${operatoreId!''}";
    </script>

    <script src="/js/operatore/operatore_missioni.js"></script>
</@layout.pagina_operatore>