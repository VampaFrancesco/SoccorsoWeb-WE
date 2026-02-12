<#import "layout.ftl" as layout>

<@layout.pagina_admin titolo="Gestione Missioni" nomeUtente=nomeUtente!"Admin"
extraHead='<link rel="stylesheet" href="/css/missioni.css">'
extraScripts='<script src="/js/admin/missioni.js"></script>'>

    <div class="missioni-container">
        <header class="top-header">
            <div class="filter-bar">
                <button class="filter-btn active" data-stato="IN_CORSO">
                    <i class="fas fa-clock"></i> In Corso
                </button>
                <button class="filter-btn" data-stato="CHIUSA">
                    <i class="fas fa-check-circle"></i> Concluse
                </button>
                <button class="filter-btn" data-stato="ALL">
                    <i class="fas fa-list"></i> Tutte
                </button>
            </div>
        </header>

        <div class="table-container card">
            <table class="modern-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Richiesta</th>
                    <th>Caposquadra</th>
                    <th>Operatori</th>
                    <th>Mezzi</th>
                    <th>Data Inizio</th>
                    <th>Stato</th>
                    <th>Azioni</th>
                </tr>
                </thead>
                <tbody id="missioni-body">
                <tr class="loading-row">
                    <td colspan="8">
                        <i class="fas fa-spinner fa-spin"></i> Caricamento missioni...
                    </td>
                </tr>
                </tbody>
            </table>
            <div id="no-data" class="empty-state" style="display: none;">
                <i class="fas fa-route"></i>
                <p>Nessuna missione trovata per questo stato.</p>
            </div>
        </div>
    </div>

    <!-- Modal Dettagli -->
    <div id="modal-dettagli" class="modal-overlay">
        <div class="modal-dialog modal-lg">
            <div class="modal-header">
                <h2><i class="fas fa-info-circle"></i> Dettagli Missione</h2>
                <button class="modal-close" onclick="closeModal('modal-dettagli')">&times;</button>
            </div>
            <div class="modal-body" id="dettagli-content">
                <!-- Contenuto dinamico -->
            </div>
        </div>
    </div>

    <!-- Modal Aggiorna -->
    <div id="modal-aggiorna" class="modal-overlay">
        <div class="modal-dialog">
            <div class="modal-header">
                <h2><i class="fas fa-edit"></i> Aggiungi Aggiornamento</h2>
                <button class="modal-close" onclick="closeModal('modal-aggiorna')">&times;</button>
            </div>
            <div class="modal-body">
                <form id="form-aggiorna">
                    <div class="form-group">
                        <label for="testo-aggiornamento">Aggiornamento *</label>
                        <textarea
                                id="testo-aggiornamento"
                                name="testo"
                                rows="5"
                                placeholder="Inserisci l'aggiornamento sulla missione..."
                                required></textarea>
                        <small class="form-text">L'aggiornamento verrà inviato via email a tutti gli operatori coinvolti</small>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeModal('modal-aggiorna')">Annulla</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Invia Aggiornamento
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Chiudi -->
    <div id="modal-chiudi" class="modal-overlay">
        <div class="modal-dialog">
            <div class="modal-header">
                <h2><i class="fas fa-check-circle"></i> Chiudi Missione</h2>
                <button class="modal-close" onclick="closeModal('modal-chiudi')">&times;</button>
            </div>
            <div class="modal-body">
                <form id="form-chiudi">
                    <div class="form-group">
                        <label for="data-fine">Data e Ora Fine *</label>
                        <input type="datetime-local" id="data-fine" name="dataFine" required>
                    </div>

                    <div class="form-group">
                        <label for="livello-successo">Livello di Successo *</label>
                        <select id="livello-successo" name="livelloSuccesso" required>
                            <option value="">Seleziona un livello</option>
                            <option value="0">0 - Fallimento</option>
                            <option value="1">1 - Scarso</option>
                            <option value="2">2 - Sufficiente</option>
                            <option value="3">3 - Buono</option>
                            <option value="4">4 - Ottimo</option>
                            <option value="5">5 - Successo Pieno</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="commenti">Commenti Finali</label>
                        <textarea
                                id="commenti"
                                name="commenti"
                                rows="4"
                                placeholder="Inserisci eventuali commenti sulla missione..."></textarea>
                        <small class="form-text">Gli operatori riceveranno una notifica email con i dettagli della chiusura</small>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeModal('modal-chiudi')">Annulla</button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-check"></i> Chiudi Missione
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</@layout.pagina_admin>
