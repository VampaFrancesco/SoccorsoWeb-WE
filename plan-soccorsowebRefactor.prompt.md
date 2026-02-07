# Piano di refactoring e degradazione elegante (SoccorsoWeb)

## Obiettivo
Riorganizzare il progetto per separare chiaramente layer MVC/API, migliorare coesione e testabilità, e implementare percorsi senza JavaScript per: invio richiesta di soccorso, convalida email, login.

## Milestone 0 — Analisi rapida e inventario
- Mappare controller web (FreeMarker) vs controller API (`/swa/...`).
- Elencare form e relative action URL nei template `*.ftl`.
- Identificare flussi JS che oggi bloccano l’uso senza script (login, richiesta, convalida).
- Verificare entità/DTO coinvolti: `RichiestaSoccorso`, `User`, `Role`, `Missione`.
- Definire cosa resta client-side (enhancement) e cosa diventa server-side (baseline).

Output:
- Tabella “flusso -> endpoint web -> endpoint API -> template”.

## Milestone 1 — Refactor architetturale (senza cambiare comportamento)
### 1.1 Separazione pacchetti
- Uniformare package: `it.univaq.webengineering.soccorsoweb` (attualmente mix con `it.univaq.swa.soccorsoweb`).
- Raggruppare:
  - `controller.web` (FreeMarker)
  - `controller.api` (`/swa/...`)
  - `service`
  - `repository`
  - `model.dto`, `model.entity`
  - `mapper`
- Standardizzare naming (Auth vs Login, Richiesta vs Soccorso).

### 1.2 Allineare proprietà e config
- Spostare base URL e web URL in `application.properties`.
- Centralizzare messaggi/redirect.

### 1.3 Pulizia duplicazioni
- Eliminare logica duplicata tra controller web e API.
- Portare validazioni condivise in service/validator.

Output:
- Struttura pacchetti stabile e coerente.
- Nessuna modifica di feature visibile.

## Milestone 2 — Flusso “Richiesta soccorso” senza JS
### 2.1 Form server-side
- `home.ftl` deve inviare POST standard a endpoint web (es. `POST /richieste`).
- Gestire file upload e captcha semplice (server-side).
- Mostrare messaggi di errore e success nel template (model attributes).

### 2.2 Controller web
- Aggiungere `RichiestaWebController`:
  - `POST /richieste` (crea richiesta, invia email, mostra pagina esito).
  - `GET /richieste/ok` e `GET /richieste/errore` (fallback).

### 2.3 Email di convalida (no JS)
- Link diretto a endpoint web: `GET /convalida?token=...`.
- Il controller convalida e renderizza template di conferma.

Output:
- Invio richiesta e convalida funzionano senza JS.

## Milestone 3 — Login senza JS
### 3.1 Form server-side
- `auth/login.ftl` invia POST classico (no fetch).
- Gestire errori con redirect + flash attributes o model.

### 3.2 Controller web
- `POST /login` autentica usando `AuthenticationManager`.
- Dopo login: redirect role-based (`/admin` o `/operatore`).
- `GET /logout` invalida sessione.

### 3.3 Progressive enhancement
- JS di login resta, ma diventa optional: se attivo, usa API e poi redirect.

Output:
- Login/Logout funziona senza JS.

## Milestone 4 — Rifinitura UX e fallback
- Messaggi coerenti nei template (success/error).
- Template unificati per esiti (e.g., `email/validate-email.ftl`).
- Protezioni anti-spam basiche lato server (rate limit semplice e captchas).

## Milestone 5 — Test e verifica
- Test manuali:
  - Richiesta senza JS (form submit, email link).
  - Login senza JS.
  - Convalida email diretta.
- Test con JS attivo (assicurare non regressioni).

## File/aree principali da toccare
- `src/main/java/.../controller` (aggiunta controller web per form).
- `src/main/java/.../swa/open` (API, da mantenere per enhancement).
- `src/main/resources/templates/home.ftl`, `auth/login.ftl`, `email/validate-email.ftl`.
- `src/main/resources/application.properties` (URL e config).

## Rischi
- Collisioni tra route web e API.
- Validazioni inconsistenti tra JS e server.
- Divergenza pacchetti e import errati.

## Criteri di completamento
- Tutti i flussi principali funzionano con JS disabilitato.
- Struttura del progetto coerente (package e naming).
- Nessuna regressione nei flussi JS esistenti.

