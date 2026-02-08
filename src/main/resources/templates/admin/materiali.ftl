<#import "layout.ftl" as layout>

<@layout.pagina_admin 
    titolo="Gestione Magazzino" 
    nomeUtente=nomeUtente!"Admin"
    headerContent='<button class="btn-modern-add" onclick="openMaterialModal(\'modal-add-material\')">
                <i class="fas fa-plus-circle"></i>
                <span>Aggiungi Articolo</span>
            </button>'
    extraScripts='<script src="/js/admin/materiali.js"></script>'>

    <div class="inventory-container">
        <div class="inventory-column">
            <div class="section-header">
                <h3 class="status-title available"><i class="fas fa-box"></i> In Stock</h3>
                <span class="inventory-badge" id="count-available">0</span>
            </div>
            <div id="list-available" class="material-list">
                <div class="loading-spinner"><i class="fas fa-circle-notch fa-spin"></i></div>
            </div>
        </div>

        <div class="inventory-column">
            <div class="section-header">
                <h3 class="status-title unavailable"><i class="fas fa-exclamation-triangle"></i> Esauriti / In Manutenzione</h3>
                <span class="inventory-badge" id="count-unavailable">0</span>
            </div>
            <div id="list-unavailable" class="material-list">
            </div>
        </div>
    </div>

    <div id="modal-add-material" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header-fancy">
                <h2><i class="fas fa-cart-plus"></i> Nuovo Materiale</h2>
                <i class="fas fa-times close-modal-white" onclick="closeMaterialModal('modal-add-material')"></i>
            </div>
            <div class="modal-body">
                <form id="formMateriale">
                    <div class="form-group">
                        <label class="form-label">Nome Materiale</label>
                        <div class="input-wrapper">
                            <i class="fas fa-tag"></i>
                            <input type="text" id="m_nome" class="form-control-icon" placeholder="es. Defibrillatore, Bende..." required>
                        </div>
                    </div>

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label">Tipologia</label>
                            <div class="input-wrapper">
                                <i class="fas fa-filter"></i>
                                <select id="m_tipo" class="form-control-icon">
                                    <option value="Vie Respiratorie">Vie Respiratorie</option>
                                    <option value="Trauma">Trauma</option>
                                    <option value="Diagnostica">Diagnostica</option>
                                    <option value="Medicazione">Medicazione</option>
                                    <option value="DPI">DPI</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Quantità</label>
                            <div class="input-wrapper">
                                <i class="fas fa-layer-group"></i>
                                <input type="number" id="m_quantita" class="form-control-icon" value="1" min="0" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Descrizione e Note</label>
                        <div class="input-wrapper">
                            <i class="fas fa-align-left" style="top: 15px;"></i>
                            <textarea id="m_descrizione" class="form-control-icon" placeholder="Dettagli tecnici o scadenze..."></textarea>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit-fancy">
                        <i class="fas fa-save"></i> Conferma Registrazione
                    </button>
                </form>
            </div>
        </div>
    </div>

    <div id="modal-edit-quantity" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header-fancy">
                <h2><i class="fas fa-edit"></i> Modifica Quantità</h2>
                <i class="fas fa-times close-modal-white" onclick="closeMaterialModal('modal-edit-quantity')"></i>
            </div>
            <div class="modal-body">
                <form id="formEditQuantity">
                    <input type="hidden" id="edit-qty-material-id">
                    <div class="form-group">
                        <label class="form-label">Nuova Quantità</label>
                        <div class="input-wrapper">
                            <i class="fas fa-layer-group"></i>
                            <input type="number" id="edit-qty-input" class="form-control-icon" min="0" required>
                        </div>
                    </div>
                    <button type="button" class="btn-submit-fancy" onclick="updateQuantity(document.getElementById('edit-qty-material-id').value, document.getElementById('edit-qty-input').value)">
                        <i class="fas fa-save"></i> Aggiorna
                    </button>
                </form>
            </div>
        </div>
    </div>
</@layout.pagina_admin>