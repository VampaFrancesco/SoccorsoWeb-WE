# Modifiche di Refactoring - SoccorsoWeb

## Data: 7 Febbraio 2026

### 1. Correzione Package Names
**Problema**: Incoerenza tra package `it.univaq.swa.soccorsoweb` e `it.univaq.webengineering.soccorsoweb`

**Soluzione**: Standardizzato tutto su `it.univaq.webengineering.soccorsoweb` come definito nel `pom.xml`

**File modificati**:
- Tutti i file in `model/entity/*` 
- Tutti i file in `model/dto/request/*` e `model/dto/response/*`
- Tutti i file in `repository/*`
- Tutti i file in `mapper/*`
- Tutti i file in `service/*`
- Tutti i file in `swa/api/*` e `swa/open/*`
- Tutti i file in `exception/*`
- Tutti i file in `config/*`
- Tutti i file in `security/*`
- Tutti i file in `controller/*`

---

### 2. Correzione pom.xml
**Problema**: Dipendenze inesistenti e mancanti

**Cambiamenti**:
- ❌ Rimosso: `spring-boot-starter-webmvc` (non esiste, corretto in `spring-boot-starter-web`)
- ❌ Rimosso: `spring-boot-starter-freemarker-test` (non esiste)
- ❌ Rimosso: `spring-boot-starter-mail-test` (non esiste)
- ❌ Rimosso: `spring-boot-starter-validation-test` (non esiste)
- ❌ Rimosso: `spring-boot-starter-webmvc-test` (non esiste)

**Aggiunte dipendenze mancanti**:
- ✅ `spring-boot-starter-web` - Framework web Spring Boot
- ✅ `spring-boot-starter-data-jpa` - Persistenza JPA/Hibernate
- ✅ `spring-boot-starter-security` - Spring Security
- ✅ `mariadb-java-client` - Driver MariaDB
- ✅ `jjwt-api`, `jjwt-impl`, `jjwt-jackson` (v0.12.5) - JWT per autenticazione
- ✅ `jackson-databind` - Serializzazione/Deserializzazione JSON
- ✅ `jackson-datatype-jsr310` - Supporto Java 8 Date/Time API
- ✅ `mapstruct` e `mapstruct-processor` (v1.6.0) - Mapping DTO/Entity
- ✅ `lombok` (scope provided) - Riduzione boilerplate
- ✅ `jspecify` (v1.0.0) - Annotazioni nullability
- ✅ `spring-boot-starter-test` - Testing
- ✅ `spring-security-test` - Testing Spring Security

**Plugin aggiunti**:
- ✅ `maven-compiler-plugin` con configuration per Lombok + MapStruct
- ✅ Annotation processors configurati correttamente

---

### 3. Correzione application.properties
**Problema**: Configurazioni mancanti

**Aggiunte**:
```properties
# JWT Configuration
jwt.secret=Kv6R9N8P4M2xY7qWzT5jLbGhFdAeC3oUpI1nXmVsZkQcJrHgEfDwByUiOtSaRpLm
jwt.expiration=86400000

# Frontend URL (for CORS)
app.frontend-url=http://localhost:3000

# Email Configuration (con variabili d'ambiente)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=${MAIL_USERNAME:your-email@gmail.com}
spring.mail.password=${MAIL_PASSWORD:your-app-password}
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.smtp.starttls.required=true

# Logging Configuration
logging.level.it.univaq.webengineering.soccorsoweb=DEBUG
logging.level.org.springframework.security=DEBUG
logging.level.org.hibernate.SQL=DEBUG
logging.level.org.hibernate.type.descriptor.sql.BasicBinder=TRACE

# JPA/Hibernate migliorato
spring.jpa.properties.hibernate.format_sql=true
```

---

### 4. Struttura Package Finale

```
it.univaq.webengineering.soccorsoweb
├── SoccorsoWebApplication.java (main)
├── config/
│   ├── CorsConfig.java
│   └── SecurityConfig.java
├── controller/ (Web Controllers)
│   ├── AdminController.java
│   ├── AuthController.java
│   ├── HomeController.java
│   ├── MezziController.java
│   ├── OperatoreController.java
│   ├── ProfiloController.java
│   ├── RichiestaWebController.java
│   └── ValidateEmailController.java
├── swa/ (REST API Controllers)
│   ├── api/
│   │   ├── AuthController.java
│   │   ├── MaterialeController.java
│   │   ├── MezzoController.java
│   │   ├── MissioneController.java
│   │   ├── OperatoreController.java
│   │   ├── RichiestaApiController.java
│   │   └── SquadraController.java
│   └── open/
│       ├── AuthController.java
│       └── RichiestaOpenController.java
├── model/
│   ├── entity/ (17 entities)
│   └── dto/
│       ├── request/ (23 request DTOs)
│       └── response/ (18 response DTOs)
├── repository/ (17 JPA repositories)
├── mapper/ (17 MapStruct mappers)
├── service/ (8 services)
├── security/
│   ├── jwt/
│   │   ├── JWTAuthenticationFilter.java
│   │   └── JWTUtil.java
│   ├── userdetails/
│   │   └── CustomUserDetailsService.java
│   └── interceptor/
│       └── LoginValidationInterceptor.java
└── exception/
    └── GlobalExceptionHandler.java
```

---

### 5. Coerenza Architetturale

**Separazione chiara**:
- **Web Controllers** (`/controller/*`) → Restituiscono templates Freemarker
- **REST API Controllers** (`/swa/api/*`) → Endpoint protetti con JWT, richiedono autenticazione
- **Open API Controllers** (`/swa/open/*`) → Endpoint pubblici (es. login, registrazione richieste)

**Pattern applicati**:
- ✅ Repository Pattern (Spring Data JPA)
- ✅ Service Layer
- ✅ DTO Pattern con MapStruct
- ✅ JWT Authentication
- ✅ Global Exception Handling
- ✅ CORS Configuration
- ✅ Security Filter Chain

---

### 6. Prossimi Passi Suggeriti

1. **Compilare il progetto**:
   ```bash
   ./mvnw clean install
   ```

2. **Verificare la configurazione del database**:
   - Assicurati che MariaDB sia in esecuzione sulla porta 3307
   - Database: `soccorsodb_we`
   - User: `soccorso_user`
   - Password: `soccorso_pass`

3. **Configurare le variabili d'ambiente per email**:
   ```bash
   export MAIL_USERNAME=your-email@gmail.com
   export MAIL_PASSWORD=your-app-password
   ```

4. **Avviare l'applicazione**:
   ```bash
   ./mvnw spring-boot:run
   ```

5. **Testare gli endpoint**:
   - Home: `http://localhost:8080/home`
   - API Docs: Vedere `src/main/resources/api/api_core.yaml`

---

### 7. Note Importanti

⚠️ **Security**:
- Il `jwt.secret` nel file properties è un esempio. In produzione, usa variabili d'ambiente
- Non committare mai credenziali reali nel repository

⚠️ **CORS**:
- Configurato per permettere richieste da più origini in sviluppo
- In produzione, limitare a origini specifiche

⚠️ **Logging**:
- Livello DEBUG attivato per sviluppo
- In produzione, impostare a INFO o WARN

---

## Riepilogo Modifiche

- **File Java modificati**: ~126 file
- **Package rinominati**: Da `it.univaq.swa.soccorsoweb` a `it.univaq.webengineering.soccorsoweb`
- **Dipendenze corrette**: 15+ dipendenze aggiunte/corrette
- **Configurazioni aggiunte**: JWT, Email, Logging, CORS

**Stato finale**: Progetto coerente e pronto per la compilazione

