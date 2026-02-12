<#import "layout.ftl" as layout>

<@layout.pagina_admin
titolo="Gestione Mezzi"
nomeUtente=nomeUtente!"Admin"
extraHead='<link rel="stylesheet" href="/css/mezzi.css">'
headerContent='<button class="btn-modern-add" onclick="openModal(\'modal-add\')">
            <i class="fas fa-plus-circle fa-lg"></i>
            <span>Nuovo Mezzo</span>
        </button>'
extraScripts='<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="/js/mezzi.js"></script>'>

    <div class="fleet-container">
        <!-- DISPONIBILI -->
        <div class="fleet-column">
            <div class="section-header">
                <h2 class="text-success"><i class="fas fa-check-circle"></i> Operativi</h2>
                <span class="badge" id="count-available">0</span>
            </div>
            <div id="list-available">
                <div class="loading-spinner"><i class="fas fa-spinner fa-spin"></i></div>
            </div>
        </div>

        <!-- NON DISPONIBILI -->
        <div class="fleet-column">
            <div class="section-header">
                <h3 class="text-danger"><i class="fas fa-ban"></i> In Servizio / Manutenzione</h3>
                <span class="badge" id="count-unavailable">0</span>
            </div>
            <div id="list-unavailable">
            </div>
        </div>
    </div>

    <!-- MODALE AGGIUNTA MEZZO -->
    <div id="modal-add" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header-fancy">
                <h2><i class="fas fa-ambulance"></i> Registra Nuovo Mezzo</h2>
                <i class="fas fa-times close-modal-white" onclick="closeModal('modal-add')"></i>
            </div>

            <div class="modal-body">
                <form id="formAddMezzo">
                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label">Nome</label>
                            <div class="input-wrapper">
                                <i class="fas fa-tag"></i>
                                <input type="text" id="m_nome" class="form-control-icon" placeholder="es. Bravo 1" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Targa</label>
                            <div class="input-wrapper">
                                <i class="fas fa-barcode"></i>
                                <input type="text" id="m_targa" class="form-control-icon" placeholder="es. FX 000 YZ" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label">Tipologia</label>
                            <div class="input-wrapper">
                                <i class="fas fa-truck-medical"></i>
                                <select id="m_tipo" class="form-control-icon">
                                    <option value="Ambulanza">Ambulanza</option>
                                    <option value="Automedica">Automedica</option>
                                    <option value="Elisoccorso">Elisoccorso</option>
                                    <option value="Logistica">Trasporti organici</option>
                                    <option value="Servizio">Auto di servizio</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Stato Iniziale</label>
                            <div class="input-wrapper">
                                <i class="fas fa-toggle-on"></i>
                                <select class="form-control-icon" disabled>
                                    <option selected>Disponibile</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Dotazioni</label>
                        <div class="input-wrapper">
                            <i class="fas fa-clipboard-list" style="top: 20px;"></i>
                            <textarea id="m_descrizione" class="form-control-icon" placeholder="Specificare dotazioni particolari..."></textarea>
                        </div>
                    </div>

                    <div style="margin-top: 25px;">
                        <button type="submit" class="btn-submit-fancy">
                            <i class="fas fa-save"></i> Salva Veicolo
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODALE MODIFICA MEZZO -->
    <div id="modal-edit" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header-fancy">
                <h2><i class="fas fa-edit"></i> Modifica Dati Mezzo</h2>
                <i class="fas fa-times close-modal-white" onclick="closeModal('modal-edit')"></i>
            </div>

            <div class="modal-body">
                <form id="formEditMezzo">
                    <input type="hidden" id="edit_m_id">

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label">Nome</label>
                            <div class="input-wrapper">
                                <i class="fas fa-tag"></i>
                                <input type="text" id="edit_m_nome" class="form-control-icon" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Targa</label>
                            <div class="input-wrapper">
                                <i class="fas fa-barcode"></i>
                                <input type="text" id="edit_m_targa" class="form-control-icon" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Tipologia</label>
                        <div class="input-wrapper">
                            <i class="fas fa-truck-medical"></i>
                            <select id="edit_m_tipo" class="form-control-icon">
                                <option value="Ambulanza">Ambulanza</option>
                                <option value="Automedica">Automedica</option>
                                <option value="Elisoccorso">Elisoccorso</option>
                                <option value="Logistica">Trasporti organici</option>
                                <option value="Servizio">Auto di servizio</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Dotazioni / Note</label>
                        <div class="input-wrapper">
                            <i class="fas fa-clipboard-list" style="top: 20px;"></i>
                            <textarea id="edit_m_descrizione" class="form-control-icon"></textarea>
                        </div>
                    </div>

                    <div style="margin-top: 25px;">>
                        <button type="submit" class="btn-submit-fancy">
                            <i class="fas fa-save"></i> Aggiorna Dati
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODALE STORICO -->
    <div id="modal-history" class="modal-overlay">
        <div class="modal-content" style="width: 950px; max-width: 98%;">
            <div class="modal-header-fancy">
                <h2><i class="fas fa-history"></i> Storico Missioni</h2>
                <i class="fas fa-times close-modal-white" onclick="closeModal('modal-history')"></i>
            </div>

            <div class="modal-body">
                <p id="history-title" style="margin-bottom: 15px; font-weight: 600; color: #555;"></p>
                <div class="history-table-wrapper">
                    <table class="modal-table history-table">
                        <thead>
                        <tr>
                            <th>Stato</th>
                            <th>Inizio</th>
                            <th>Fine</th>
                            <th>Posizione</th>
                            <th>Squadra</th>
                            <th>Caposquadra</th>
                            <th>Dettagli</th>
                        </tr>
                        </thead>
                        <tbody id="history-body">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</@layout.pagina_admin>
