-- =============================================
-- SCRIPT POPOLAZIONE DATABASE SOCCORSOWEB
-- Eseguire questo script dopo aver creato gli utenti
-- =============================================

-- 1. POPOLAZIONE CAPISQUADRA (Assumendo User ID 1 e 2 esistano come Admin/Operatore)
-- Se l'utente 1 è un admin/operatore, lo rendiamo caposquadra
INSERT INTO caposquadra (user_id) 
SELECT 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM caposquadra WHERE user_id = 1);

INSERT INTO caposquadra (user_id) 
SELECT 2 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM caposquadra WHERE user_id = 2);

-- 2. POPOLAZIONE MEZZI
INSERT INTO mezzo (nome, descrizione, tipo, targa, disponibile, created_at, updated_at) VALUES 
('Ambulanza Alpha 1', 'Ambulanza di rianimazione con equipaggiamento avanzato', 'AMBULANZA_A', 'AB123CD', 1, NOW(), NOW()),
('Ambulanza Bravo 2', 'Ambulanza di base per trasporto infermi', 'AMBULANZA_B', 'EF456GH', 1, NOW(), NOW()),
('Auto Medica 1', 'Veicolo rapido per intervento medico d\'urgenza', 'AUTO_MEDICA', 'IJ789KL', 1, NOW(), NOW()),
('Elicottero H1', 'Elisoccorso per zone impervie', 'ELICOTTERO', 'I-ELIT', 0, NOW(), NOW()),
('Furgone Logistico', 'Trasporto materiali e attrezzature pesanti', 'LOGISTICA', 'MN012OP', 1, NOW(), NOW()),
('Moto Medica', 'Intervento rapido in traffico urbano', 'MOTO', 'QR345ST', 1, NOW(), NOW());

-- 3. POPOLAZIONE MATERIALI
INSERT INTO materiale (nome, descrizione, tipo, quantita, disponibile, created_at, updated_at) VALUES 
('Defibrillatore AED', 'Defibrillatore semi-automatico portatile', 'MEDICO', 10, 1, NOW(), NOW()),
('Kit Primo Soccorso', 'Zaino completo per primo intervento', 'MEDICO', 25, 1, NOW(), NOW()),
('Barella Cucchiaio', 'Barella a cucchiaio per traumatizzati', 'TRASPORTO', 5, 1, NOW(), NOW()),
('Bombola Ossigeno', 'Bombola O2 portatile 5 litri', 'MEDICO', 15, 1, NOW(), NOW()),
('Torcia Tattica', 'Illuminazione LED ad alta potenza', 'LOGISTICA', 30, 1, NOW(), NOW()),
('Radio Portatile', 'Radio trasmittente VHF/UHF', 'COMUNICAZIONE', 20, 1, NOW(), NOW()),
('Coperte Termiche', 'Coperte metalline per prevenzione ipotermia', 'CONSUMABILE', 100, 1, NOW(), NOW()),
('Collari Cervicali', 'Set collari regolabili adulto/pediatrico', 'MEDICO', 12, 1, NOW(), NOW());

-- 4. POPOLAZIONE RICHIESTE DI SOCCORSO
-- Richieste ATTIVE (Nuove)
INSERT INTO richiesta_soccorso (nome_segnalante, email_segnalante, telefono_segnalante, indirizzo, latitudine, longitudine, descrizione, stato, token_convalida, convalidata_at, created_at, updated_at, ip_origine) VALUES
('Mario Rossi', 'mario.rossi@example.com', '3331111111', 'Via Roma 10, L''Aquila', 42.3498, 13.3995, 'Incidente stradale tra due veicoli, feriti lievi.', 'ATTIVA', UUID(), NOW(), NOW(), NOW(), '192.168.1.1'),
('Luigi Verdi', 'luigi.verdi@example.com', '3332222222', 'Piazza Duomo, L''Aquila', 42.3505, 13.3980, 'Persona colta da malore improvviso, cosciente ma confusa.', 'ATTIVA', UUID(), NOW(), NOW(), NOW(), '192.168.1.2'),
('Giulia Bianchi', 'giulia.bianchi@example.com', '3333333333', 'Parco del Castello, L''Aquila', 42.3550, 13.4020, 'Caduta da bicicletta, sospetta frattura braccio.', 'ATTIVA', UUID(), NOW(), NOW(), NOW(), '192.168.1.3');

-- Richieste IN_CORSO (Associate a missioni)
INSERT INTO richiesta_soccorso (nome_segnalante, email_segnalante, telefono_segnalante, indirizzo, latitudine, longitudine, descrizione, stato, token_convalida, convalidata_at, created_at, updated_at, ip_origine) VALUES
('Anna Neri', 'anna.neri@example.com', '3334444444', 'Viale della Croce Rossa, L''Aquila', 42.3600, 13.3900, 'Investimento pedone, richiesti soccorsi urgenti.', 'IN_CORSO', UUID(), NOW(), DATE_SUB(NOW(), INTERVAL 2 HOUR), NOW(), '192.168.1.4'),
('Paolo Gialli', 'paolo.gialli@example.com', '3335555555', 'Stazione Ferroviaria, L''Aquila', 42.3450, 13.3850, 'Uomo svenuto in sala d''attesa.', 'IN_CORSO', UUID(), NOW(), DATE_SUB(NOW(), INTERVAL 1 HOUR), NOW(), '192.168.1.5'),
('Sofia Blu', 'sofia.blu@example.com', '3336666666', 'Centro Commerciale L''Aquilone', 42.3680, 13.3400, 'Reazione allergica grave al ristorante.', 'IN_CORSO', UUID(), NOW(), DATE_SUB(NOW(), INTERVAL 30 MINUTE), NOW(), '192.168.1.6');

-- Richieste CHIUSE (Concluse)
INSERT INTO richiesta_soccorso (nome_segnalante, email_segnalante, telefono_segnalante, indirizzo, latitudine, longitudine, descrizione, stato, token_convalida, convalidata_at, created_at, updated_at, ip_origine) VALUES
('Marco Viola', 'marco.viola@example.com', '3337777777', 'Via XX Settembre, L''Aquila', 42.3480, 13.3950, 'Caduta anziano in casa.', 'CHIUSA', UUID(), DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), NOW(), '192.168.1.7'),
('Elena Arancio', 'elena.arancio@example.com', '3338888888', 'Via Amiternum, L''Aquila', 42.3580, 13.3880, 'Incendio in appartamento, intossicazione fumo.', 'CHIUSA', UUID(), DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), NOW(), '192.168.1.8');

-- Richieste IGNORATE
INSERT INTO richiesta_soccorso (nome_segnalante, email_segnalante, telefono_segnalante, indirizzo, latitudine, longitudine, descrizione, stato, token_convalida, convalidata_at, created_at, updated_at, ip_origine) VALUES
('Troll Utente', 'troll@example.com', '0000000000', 'Null Island', 0.0, 0.0, 'Falsa segnalazione di prova.', 'IGNORATA', UUID(), NOW(), DATE_SUB(NOW(), INTERVAL 3 DAY), NOW(), '192.168.1.9');


-- 5. POPOLAZIONE MISSIONI
-- Missioni IN CORSO
-- Missione 1 (collegata a richiesta Anna Neri - ID dinamico approssimato, in prod usare ID reali)
-- Qui assumiamo che gli ID richiesta siano sequenziali da 4, 5, 6 per le IN_CORSO create sopra. 
-- NOTA: In uno script reale bisognerebbe recuperare gli ID, ma per test locale assumiamo l'ordine di inserimento.

INSERT INTOmissione (richiesta_id, caposquadra_id, obiettivo, posizione, latitudine, longitudine, stato, inizio_at, created_at, updated_at)
SELECT id, 1, 'Stabilizzazione e trasporto in ospedale', indirizzo, latitudine, longitudine, 'IN_CORSO', NOW(), NOW(), NOW()
FROM richiesta_soccorso WHERE email_segnalante = 'anna.neri@example.com';

INSERT INTO missione (richiesta_id, caposquadra_id, obiettivo, posizione, latitudine, longitudine, stato, inizio_at, created_at, updated_at)
SELECT id, 1, 'Valutazione parametri vitali', indirizzo, latitudine, longitudine, 'IN_CORSO', NOW(), NOW(), NOW()
FROM richiesta_soccorso WHERE email_segnalante = 'paolo.gialli@example.com';

INSERT INTO missione (richiesta_id, caposquadra_id, obiettivo, posizione, latitudine, longitudine, stato, inizio_at, created_at, updated_at)
SELECT id, 1, 'Somministrazione adrenalina e monitoraggio', indirizzo, latitudine, longitudine, 'IN_CORSO', NOW(), NOW(), NOW()
FROM richiesta_soccorso WHERE email_segnalante = 'sofia.blu@example.com';

-- Missioni CHIUSE
INSERT INTO missione (richiesta_id, caposquadra_id, obiettivo, posizione, latitudine, longitudine, stato, inizio_at, fine_at, livello_successo, commenti_finali, created_at, updated_at)
SELECT id, 1, 'Assistenza domiciliare', indirizzo, latitudine, longitudine, 'CHIUSA', DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), 5, 'Intervento riuscito senza complicazioni', DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()
FROM richiesta_soccorso WHERE email_segnalante = 'marco.viola@example.com';

INSERT INTO missione (richiesta_id, caposquadra_id, obiettivo, posizione, latitudine, longitudine, stato, inizio_at, fine_at, livello_successo, commenti_finali, created_at, updated_at)
SELECT id, 1, 'Evacuazione e supporto respiratorio', indirizzo, latitudine, longitudine, 'CHIUSA', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), 4, 'Paziente trasportato in codice giallo', DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()
FROM richiesta_soccorso WHERE email_segnalante = 'elena.arancio@example.com';


-- 6. POPOLAZIONE MISSIONE_MEZZI (Junction Table)
-- Collega le missioni ai mezzi (assumendo ID mezzi 1, 2, 3...)
-- Colleghiamo la missione IN CORSO di Anna Neri (prima missione inserita -> ID basso) a Ambulanza Alpha (ID 1)
INSERT INTO missione_mezzi (missione_id, mezzo_id, assegnato_at)
SELECT m.id, 1, NOW()
FROM missione m
JOIN richiesta_soccorso r ON m.richiesta_id = r.id
WHERE r.email_segnalante = 'anna.neri@example.com';

-- Colleghiamo la missione di Paolo Gialli a Auto Medica (ID 3)
INSERT INTO missione_mezzi (missione_id, mezzo_id, assegnato_at)
SELECT m.id, 3, NOW()
FROM missione m
JOIN richiesta_soccorso r ON m.richiesta_id = r.id
WHERE r.email_segnalante = 'paolo.gialli@example.com';


-- 7. POPOLAZIONE MISSIONE_MATERIALI (Junction Table)
-- Assegna materiali alle missioni
INSERT INTO missione_materiali (missione_id, materiale_id, quantita_usata, assegnato_at)
SELECT m.id, 2, 2, NOW() -- 2 Kit Primo Soccorso
FROM missione m
JOIN richiesta_soccorso r ON m.richiesta_id = r.id
WHERE r.email_segnalante = 'anna.neri@example.com';

INSERT INTO missione_materiali (missione_id, materiale_id, quantita_usata, assegnato_at)
SELECT m.id, 1, 1, NOW() -- 1 Defibrillatore
FROM missione m
JOIN richiesta_soccorso r ON m.richiesta_id = r.id
WHERE r.email_segnalante = 'paolo.gialli@example.com';
