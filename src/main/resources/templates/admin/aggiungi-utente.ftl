<#import "layout.ftl" as layout>

<@layout.pagina_admin 
    titolo="Gestione Staff"
    nomeUtente=nomeUtente!"Admin"
    extraHead='<link rel="stylesheet" href="/css/aggiungi-utente.css"><script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>'
    extraScripts='<script src="/js/admin/aggiungi-utente.js"></script>'
    headerContent='<div class="header-status"><span class="status-indicator"><i class="fas fa-shield-halved"></i> Area Protetta</span></div>'>

    <div class="form-container">
        <div class="widget">
            <div class="widget-header">
                <h3><i class="fas fa-id-card"></i> Dati Nuovo Operatore</h3>
            </div>

            <form id="formAggiungiUtente" class="tech-form">
                <div class="form-grid-layout">
                    <div class="input-group">
                        <label>Nome</label>
                        <input type="text" name="nome" placeholder="Mario" required>
                    </div>
                    <div class="input-group">
                        <label>Cognome</label>
                        <input type="text" name="cognome" placeholder="Rossi" required>
                    </div>
                    <div class="input-group">
                        <label>Email Istituzionale</label>
                        <input type="email" name="email" placeholder="m.rossi@soccorsoweb.it" required>
                    </div>
                    <div class="input-group">
                        <label>Recapito Telefonico</label>
                        <input type="tel" name="telefono" placeholder="+39 333 1234567" required>
                    </div>
                    <div class="input-group password-field">
                        <label>Password Temporanea</label>
                        <div class="input-with-action">
                            <input type="text" id="passwordInput" name="password" required>
                            <button type="button" id="btnGeneratePass" class="btn-action-small" title="Genera Password">
                                <i class="fas fa-sync"></i>
                            </button>
                        </div>
                    </div>
                    <div class="input-group">
                        <label>Ruolo Sistema</label>
                        <select name="ruolo" required>
                            <option value="OPERATORE">Operatore (Standard)</option>
                            <option value="ADMIN">Amministratore (Full Access)</option>
                        </select>
                    </div>
                </div>

                <div class="form-footer">
                    <button type="reset" class="btn-secondary">Svuota Campi</button>
                    <button type="submit" id="btnSalva" class="btn-quick" style="background: var(--accent-primary); border: none;">
                        <i class="fas fa-user-check" style="color: white;"></i>
                        Salva Nuovo Utente
                    </button>
                </div>
            </form>
        </div>
    </div>
</@layout.pagina_admin>