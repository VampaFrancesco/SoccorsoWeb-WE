# 📧 Guida MailHog per SoccorsoWeb

## ✅ Cosa è MailHog?

**MailHog** è un server SMTP di testing locale che:
- ✅ Cattura tutte le email inviate dall'applicazione
- ✅ Non invia email reali (perfetto per sviluppo/testing)
- ✅ Fornisce una Web UI per visualizzare le email
- ✅ Non richiede account o API key

---

## 🚀 Setup Completo

### 1️⃣ Avvia MailHog e Database

```bash
cd soccorsoweb
docker-compose up -d
```

Questo avvierà:
- **MailHog SMTP**: porta 1025 (per l'invio)
- **MailHog Web UI**: porta 8025 (per visualizzare le email)
- **MariaDB**: porta 3307

### 2️⃣ Verifica che tutto sia attivo

```bash
docker-compose ps
```

Dovresti vedere:
```
NAME                IMAGE                    STATUS
soccorso-db         mariadb:11              Up
soccorso-mailhog    mailhog/mailhog:latest  Up
```

### 3️⃣ Avvia l'applicazione Spring Boot

```bash
./mvnw spring-boot:run
```

---

## 📬 Come Visualizzare le Email

### Web UI (Consigliato)

Apri il browser e vai a:
```
http://localhost:8025
```

Vedrai tutte le email catturate da MailHog!

---

## 🧪 Testare l'Invio Email

### Test 1: Email di Convalida Richiesta

1. Vai su `http://localhost:8080/home`
2. Compila il form di richiesta soccorso
3. Invia la richiesta
4. Controlla MailHog su `http://localhost:8025`
5. Dovresti vedere l'email con il link di conferma

### Test 2: Email Credenziali Operatore

1. Accedi come Admin
2. Vai su "Aggiungi Utente"
3. Crea un nuovo operatore
4. Controlla MailHog su `http://localhost:8025`
5. Dovresti vedere l'email con username e password

---

## ⚙️ Configurazione Attuale

Il file `application.properties` è già configurato per MailHog:

```properties
# Email Configuration (MailHog for local testing)
spring.mail.host=localhost
spring.mail.port=1025
spring.mail.username=soccorsoweb@localhost
spring.mail.password=
spring.mail.properties.mail.smtp.auth=false
spring.mail.properties.mail.smtp.starttls.enable=false
spring.mail.properties.mail.smtp.starttls.required=false
spring.mail.properties.mail.debug=true
```

---

## 🔧 Comandi Utili

### Fermare i servizi
```bash
docker-compose down
```

### Riavviare solo MailHog
```bash
docker-compose restart mailhog
```

### Vedere i log di MailHog
```bash
docker-compose logs -f mailhog
```

### Pulire tutte le email in MailHog
Accedi a `http://localhost:8025` e clicca su "Delete all messages"

---

## 🐛 Troubleshooting

### Problema: "Connection refused" quando invio email

**Soluzione**:
```bash
# Verifica che MailHog sia attivo
docker-compose ps

# Se non è attivo, avvialo
docker-compose up -d mailhog

# Verifica che la porta 1025 sia libera
lsof -i :1025
```

### Problema: Le email non appaiono in MailHog

**Soluzione**:
1. Controlla i log dell'applicazione:
   ```bash
   # Cerca righe che iniziano con "✅ Email inviata" o "❌ Errore invio email"
   ```

2. Controlla i log di MailHog:
   ```bash
   docker-compose logs mailhog
   ```

3. Verifica che `spring.mail.debug=true` sia attivo in `application.properties`

### Problema: Porta 8025 già in uso

**Soluzione**: Modifica `docker-compose.yaml`:
```yaml
mailhog:
  ports:
    - "1025:1025"
    - "8026:8025"  # Cambia 8025 con 8026
```

Poi accedi a `http://localhost:8026`

---

## 📊 Vantaggi di MailHog per Sviluppo

✅ **Nessuna configurazione complessa** (no SMTP server reali)  
✅ **Nessun account email necessario**  
✅ **Nessun limite di invio**  
✅ **Testing sicuro** (nessuna email reale inviata per errore)  
✅ **Web UI intuitiva** per debugging  
✅ **Supporto HTML** (vedi email formattate)  
✅ **Cattura allegati**  
✅ **API REST** per automazione test

---

## 🚀 Alternative (per Produzione)

Quando passi in produzione, sostituisci MailHog con:

### Gmail SMTP
```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=${MAIL_USERNAME}
spring.mail.password=${MAIL_PASSWORD}
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
```

### SendGrid
```properties
spring.mail.host=smtp.sendgrid.net
spring.mail.port=587
spring.mail.username=apikey
spring.mail.password=${SENDGRID_API_KEY}
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
```

### Mailgun
```properties
spring.mail.host=smtp.mailgun.org
spring.mail.port=587
spring.mail.username=${MAILGUN_USERNAME}
spring.mail.password=${MAILGUN_PASSWORD}
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
```

---

## 📋 Checklist Setup MailHog

- [x] Docker Compose con MailHog configurato
- [x] application.properties aggiornato
- [x] EmailService usa JavaMailSender
- [ ] Avvia `docker-compose up -d`
- [ ] Verifica Web UI su `http://localhost:8025`
- [ ] Avvia Spring Boot con `./mvnw spring-boot:run`
- [ ] Testa invio email
- [ ] Controlla email su MailHog

---

**Tutto pronto! 🎉**

Ora puoi sviluppare e testare le funzionalità email senza preoccuparti di configurazioni complesse o account SMTP reali.

**Web UI MailHog**: http://localhost:8025

