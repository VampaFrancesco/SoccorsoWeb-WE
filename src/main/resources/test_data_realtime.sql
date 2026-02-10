-- ============================================================
-- SCRIPT DI TEST PER MISSIONI REAL-TIME E CONSUMO MATERIALI
-- ============================================================

-- 1. UTENTI E RUOLI (Assicurati che i ruoli esistano)
INSERT IGNORE INTO role (name) VALUES ('ADMIN'), ('OPERATORE');

-- Inserimento Operatori di Test (Password: 'password' hashata o semplice per test local)
-- Nota: 'attivo = 1' è fondamentale per la disponibilità
INSERT INTO user (email, password, nome, cognome, attivo, first_attempt, created_at) VALUES 
('mario.rossi@soccorso.it', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.7tAy4S3', 'Mario', 'Rossi', 1, 0, NOW()),
('luca.bianchi@soccorso.it', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.7tAy4S3', 'Luca', 'Bianchi', 1, 0, NOW()),
('giulia.verdi@soccorso.it', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.7tAy4S3', 'Giulia', 'Verdi', 1, 0, NOW()),
('marco.neri@soccorso.it', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.7tAy4S3', 'Marco', 'Neri', 1, 0, NOW());

-- Associazione Ruoli (OPERATORE è il secondo ruolo solitamente)
INSERT INTO user_role (user_id, role_id) 
SELECT u.id, r.id FROM user u, role r WHERE u.email LIKE '%@soccorso.it' AND r.name = 'OPERATORE';

-- 2. CAPISQUADRA (Tutti gli utenti creati possono essere capisquadra)
INSERT INTO caposquadra (user_id) 
SELECT id FROM user WHERE email LIKE '%@soccorso.it';

-- 3. RICHIESTE DI SOCCORSO (Stato 'ATTIVA' per essere visibili in 'Assegna')
INSERT INTO richiesta_soccorso (descrizione, indirizzo, latitudine, longitudine, nome_segnalante, email_segnalante, stato, convalidata_at, created_at) VALUES 
('Gatto bloccato su un albero alto', 'Via Roma 10, L Aquila', 42.3489, 13.3980, 'Franco Rossi', 'franco@email.it', 'ATTIVA', NOW(), NOW()),
('Malore improvviso in piazza', 'Piazza Duomo, L Aquila', 42.3510, 13.3990, 'Maria Neri', 'maria@email.it', 'ATTIVA', NOW(), NOW()),
('Incendio sterpaglie bordo strada', 'S.S. 80, km 20', 42.3600, 13.3500, 'Luigi Verde', 'luigi@email.it', 'ATTIVA', NOW(), NOW());

-- 4. MEZZI (Disponibili)
INSERT INTO mezzo (nome, descrizione, tipo, targa, disponibile, created_at) VALUES 
('Ambulanza A1', 'Unità rianimazione mobile', 'AMBULANZA', 'AQ001AA', 1, NOW()),
('Ambulanza A2', 'Supporto base', 'AMBULANZA', 'AQ002AB', 1, NOW()),
('Autobotte VVF', 'Mezzo antincendio 5000L', 'CAMION', 'VF12345', 1, NOW()),
('Elicottero Pegaso', 'Soccorso alpino/estremì', 'ELICOTTERO', 'EL-PEG1', 1, NOW());

-- 5. MATERIALI (Con quantità per testare lo scalamento)
INSERT INTO materiale (nome, descrizione, tipo, quantita, disponibile, created_at) VALUES 
('Kit Bende Sterili', 'Dimensioni 10x10cm', 'MEDICO', 100, 1, NOW()),
('Bombola Ossigeno 5L', 'Ricaricabile', 'MEDICO', 10, 1, NOW()),
('Estintore a Polvere 6kg', 'Classe ABC', 'ANTINCENDIO', 15, 1, NOW()),
('Soluzione Fisiologica 500ml', 'Sacca per flebo', 'MEDICO', 50, 1, NOW());

-- ============================================================
-- NOTE: 
-- - Le password sono impostate su 'password' (hash BCrypt standard).
-- - Le coordinate sono centrate su L'Aquila.
-- - Lo stato 'ATTIVA' garantisce che compaiano nella tabella 'Richieste Inviate'.
-- ============================================================
