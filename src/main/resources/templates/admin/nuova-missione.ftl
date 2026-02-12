<#import "layout.ftl" as layout>

<@layout.pagina_admin titolo="Avvia Nuova Missione" nomeUtente=nomeUtente!"Admin" extraScripts='<script src="/js/admin/nuova-missione.js"></script>'>
    <div>
        <div class="grid-container" style="display: grid; grid-template-columns: 1fr 350px; gap: 24px; margin-top: 24px;">

            <div class="main-column">
                <form id="form-missione" class="card" style="padding: 24px;">
                    <input type="hidden" id="richiestaId" name="richiestaId">

                    <section class="detail-section">
                        <h2 style="color: var(--accent-primary); margin-bottom: 20px;"><i class="fas fa-info-circle"></i> Dettagli Intervento</h2>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px;">
                            <div class="form-group">
                                <label style="display:block; margin-bottom:8px; color:var(--text-secondary); font-size:0.85rem;">Obiettivo Intervento</label>
                                <input type="text" id="obiettivo" name="obiettivo" required class="form-control"
                                       style="width:100%; background:#111827; border:1px solid var(--border-color); color:white; padding:12px; border-radius:8px;"
                                       placeholder="Es: Soccorso Medico Urgente">
                            </div>
                            <div class="form-group">
                                <label style="display:block; margin-bottom:8px; color:var(--text-secondary); font-size:0.85rem;">Località / Indirizzo</label>
                                <input type="text" id="posizione" name="posizione" required class="form-control"
                                       style="width:100%; background:#111827; border:1px solid var(--border-color); color:white; padding:12px; border-radius:8px;">
                            </div>
                        </div>
                    </section>

                    <section class="detail-section" style="margin-top: 32px;">
                        <h2 style="color: var(--accent-primary); margin-bottom: 20px;"><i class="fas fa-users"></i> Gestione Team (Real-time)</h2>

                        <div class="form-group" style="margin-bottom: 24px;">
                            <label style="display:block; margin-bottom:8px; color:var(--text-secondary); font-size:0.85rem;">Caposquadra Incaricato</label>
                            <select id="caposquadraId" name="caposquadraId" required class="form-control"
                                    style="width:100%; background:#111827; border:1px solid var(--border-color); color:white; padding:12px; border-radius:8px;">
                                <option value="">Caricamento operatori disponibili...</option>
                            </select>
                            <small style="color: var(--text-muted); margin-top: 4px; display: block;">L'operatore scelto sarà il responsabile della missione.</small>
                        </div>

                        <div class="form-group">
                            <label style="display:block; margin-bottom:12px; color:var(--text-secondary); font-size:0.85rem;">Membri Aggiuntivi del Team</label>
                            <div id="operatori-list" class="check-list-container"
                                 style="display:grid; grid-template-columns:1fr 1fr; gap:12px; max-height:200px; overflow-y:auto; background:rgba(0,0,0,0.2); padding:16px; border-radius:12px; border: 1px solid var(--border-color);">
                                <p style="grid-column: 1/-1; text-align:center; color:var(--text-secondary);">Caricamento operatori...</p>
                            </div>
                        </div>
                    </section>

                    <section class="detail-section" style="margin-top: 32px;">
                        <h2 style="color: var(--accent-primary); margin-bottom: 20px;"><i class="fas fa-ambulance"></i> Mezzi e Attrezzature</h2>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
                            <div class="form-group">
                                <label style="display:block; margin-bottom:12px; color:var(--text-secondary); font-size:0.85rem;">Mezzi di Soccorso</label>
                                <div id="mezzi-list" class="check-list-container"
                                     style="display:flex; flex-direction:column; gap:8px; max-height:250px; overflow-y:auto; background:rgba(0,0,0,0.2); padding:16px; border-radius:12px; border: 1px solid var(--border-color);">
                                    <p style="text-align:center; color:var(--text-secondary);">Caricamento mezzi...</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label style="display:block; margin-bottom:12px; color:var(--text-secondary); font-size:0.85rem;">Materiali e Consumabili</label>
                                <div id="materiali-list" class="check-list-container"
                                     style="display:flex; flex-direction:column; gap:8px; max-height:250px; overflow-y:auto; background:rgba(0,0,0,0.2); padding:16px; border-radius:12px; border: 1px solid var(--border-color);">
                                    <p style="text-align:center; color:var(--text-secondary);">Caricamento materiali...</p>
                                </div>
                            </div>
                        </div>
                    </section>

                    <div style="margin-top: 40px; padding-top: 24px; border-top: 1px solid var(--border-color); display: flex; justify-content: flex-end; gap: 16px;">
                        <button type="button" onclick="window.location.href='/admin/richieste'" class="btn-secondary" style="padding: 12px 24px;">Annulla</button>
                        <button type="submit" class="btn-primary" style="padding: 12px 32px; font-weight: 600;">
                            <i class="fas fa-paper-plane"></i> Avvia Missione
                        </button>
                    </div>
                </form>
            </div>

            <aside class="side-column">
                <div id="richiesta-summary" class="card" style="padding: 20px; position: sticky; top: 24px;">
                    <h2 style="font-size: 1rem; margin-bottom: 16px; border-bottom: 1px solid var(--border-color); padding-bottom: 12px;">Riepilogo Richiesta</h2>
                    <div id="richiesta-details">
                        <div style="text-align: center; padding: 20px;">
                            <i class="fas fa-spinner fa-spin fa-2x" style="color: var(--accent-primary);"></i>
                            <p style="margin-top: 12px; font-size: 0.9rem; color: var(--text-secondary);">Acquisizione dati...</p>
                        </div>
                    </div>
                </div>
            </aside>
        </div>
    </div>
</@layout.pagina_admin>
