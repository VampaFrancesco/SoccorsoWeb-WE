-- ==============================================================================
-- POPOLAMENTO MASSIVO SOCCORSOWEB
-- Generato automaticamente
-- ==============================================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


-- Tabella Role
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    INDEX `idx_role_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella User
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `nome` VARCHAR(100) NOT NULL,
    `cognome` VARCHAR(100) NOT NULL,
    `data_nascita` DATE NULL,
    `telefono` VARCHAR(20) NULL,
    `indirizzo` VARCHAR(255) NULL,
    `attivo` BOOLEAN NOT NULL DEFAULT TRUE,
    `first_attempt` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_email` (`email`),
    INDEX `idx_attivo` (`attivo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella User_Role (Many-to-Many)
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
    `user_id` BIGINT NOT NULL,
    `role_id` BIGINT NOT NULL,
    PRIMARY KEY (`user_id`, `role_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`role_id`) REFERENCES `role`(`id`) ON DELETE CASCADE,
    INDEX `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Patente
DROP TABLE IF EXISTS `patente`;
CREATE TABLE `patente` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `tipo` VARCHAR(50) NOT NULL UNIQUE,
    `descrizione` TEXT NULL,
    INDEX `idx_tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella User_Patenti (Many-to-Many)
DROP TABLE IF EXISTS `user_patenti`;
CREATE TABLE `user_patenti` (
    `user_id` BIGINT NOT NULL,
    `patente_id` BIGINT NOT NULL,
    `conseguita_il` DATE NULL,
    `rilasciata_da` VARCHAR(100) NULL,
    PRIMARY KEY (`user_id`, `patente_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`patente_id`) REFERENCES `patente`(`id`) ON DELETE CASCADE,
    INDEX `idx_patente_id` (`patente_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Abilita
DROP TABLE IF EXISTS `abilita`;
CREATE TABLE `abilita` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(100) NOT NULL UNIQUE,
    `descrizione` TEXT NULL,
    INDEX `idx_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella User_Abilita (Many-to-Many)
DROP TABLE IF EXISTS `user_abilita`;
CREATE TABLE `user_abilita` (
    `user_id` BIGINT NOT NULL,
    `abilita_id` BIGINT NOT NULL,
    `livello` VARCHAR(50) NULL,
    PRIMARY KEY (`user_id`, `abilita_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`abilita_id`) REFERENCES `abilita`(`id`) ON DELETE CASCADE,
    INDEX `idx_abilita_id` (`abilita_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Caposquadra
DROP TABLE IF EXISTS `caposquadra`;
CREATE TABLE `caposquadra` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL UNIQUE,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE RESTRICT,
    INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Squadra
DROP TABLE IF EXISTS `squadra`;
CREATE TABLE `squadra` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(100) NOT NULL,
    `descrizione` TEXT NULL,
    `caposquadra_id` BIGINT NOT NULL,
    `attiva` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`caposquadra_id`) REFERENCES `caposquadra`(`id`) ON DELETE RESTRICT,
    INDEX `idx_caposquadra` (`caposquadra_id`),
    INDEX `idx_attiva` (`attiva`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Squadra_Operatori (Many-to-Many)
DROP TABLE IF EXISTS `squadra_operatori`;
CREATE TABLE `squadra_operatori` (
    `squadra_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `ruolo` VARCHAR(50) NULL,
    `assegnato_il` DATE NULL,
    PRIMARY KEY (`squadra_id`, `user_id`),
    FOREIGN KEY (`squadra_id`) REFERENCES `squadra`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Richiesta_Soccorso
DROP TABLE IF EXISTS `richiesta_soccorso`;
CREATE TABLE `richiesta_soccorso` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `descrizione` TEXT NOT NULL,
    `indirizzo` VARCHAR(255) NOT NULL,
    `latitudine` DECIMAL(10, 8) NULL,
    `longitudine` DECIMAL(11, 8) NULL,
    `nome_segnalante` VARCHAR(100) NOT NULL,
    `email_segnalante` VARCHAR(255) NOT NULL,
    `telefono_segnalante` VARCHAR(20) NULL,
    `foto` LONGBLOB NULL,
    `ip_origine` VARCHAR(45) NULL,
    `token_convalida` VARCHAR(255) NULL UNIQUE,
    `stato` ENUM('ATTIVA', 'IN_CORSO', 'CHIUSA', 'IGNORATA') NULL,
    `convalidata_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_stato` (`stato`),
    INDEX `idx_email_segnalante` (`email_segnalante`),
    INDEX `idx_token` (`token_convalida`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Mezzo
DROP TABLE IF EXISTS `mezzo`;
CREATE TABLE `mezzo` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(100) NOT NULL,
    `descrizione` TEXT NULL,
    `tipo` VARCHAR(50) NULL,
    `targa` VARCHAR(20) NULL,
    `disponibile` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_disponibile` (`disponibile`),
    INDEX `idx_tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Materiale
DROP TABLE IF EXISTS `materiale`;
CREATE TABLE `materiale` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(100) NOT NULL,
    `descrizione` TEXT NULL,
    `tipo` VARCHAR(50) NULL,
    `quantita` INT NOT NULL DEFAULT 0,
    `disponibile` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_disponibile` (`disponibile`),
    INDEX `idx_tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Missione
DROP TABLE IF EXISTS `missione`;
CREATE TABLE `missione` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `richiesta_id` BIGINT NOT NULL UNIQUE,
    `squadra_id` BIGINT NULL,
    `caposquadra_id` BIGINT NOT NULL,
    `obiettivo` TEXT NOT NULL,
    `posizione` VARCHAR(255) NULL,
    `latitudine` DECIMAL(10, 8) NULL,
    `longitudine` DECIMAL(11, 8) NULL,
    `stato` ENUM('IN_CORSO', 'CHIUSA', 'FALLITA') NOT NULL DEFAULT 'IN_CORSO',
    `inizio_at` TIMESTAMP NULL,
    `fine_at` TIMESTAMP NULL,
    `livello_successo` INT NULL CHECK (`livello_successo` BETWEEN 1 AND 5),
    `commenti_finali` TEXT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`richiesta_id`) REFERENCES `richiesta_soccorso`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`squadra_id`) REFERENCES `squadra`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`caposquadra_id`) REFERENCES `caposquadra`(`id`) ON DELETE RESTRICT,
    INDEX `idx_stato` (`stato`),
    INDEX `idx_caposquadra` (`caposquadra_id`),
    INDEX `idx_squadra` (`squadra_id`),
    INDEX `idx_richiesta` (`richiesta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Aggiornamento_Missione
DROP TABLE IF EXISTS `aggiornamento_missione`;
CREATE TABLE `aggiornamento_missione` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `missione_id` BIGINT NOT NULL,
    `admin_id` BIGINT NOT NULL,
    `descrizione` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`missione_id`) REFERENCES `missione`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`admin_id`) REFERENCES `user`(`id`) ON DELETE RESTRICT,
    INDEX `idx_missione` (`missione_id`),
    INDEX `idx_admin` (`admin_id`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Missione_Operatori (Many-to-Many)
DROP TABLE IF EXISTS `missione_operatori`;
CREATE TABLE `missione_operatori` (
    `missione_id` BIGINT NOT NULL,
    `operatore_id` BIGINT NOT NULL,
    `notificato_at` TIMESTAMP NULL,
    `assegnato_at` TIMESTAMP NULL,
    PRIMARY KEY (`missione_id`, `operatore_id`),
    FOREIGN KEY (`missione_id`) REFERENCES `missione`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`operatore_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    INDEX `idx_operatore` (`operatore_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Missione_Mezzi (Many-to-Many)
DROP TABLE IF EXISTS `missione_mezzi`;
CREATE TABLE `missione_mezzi` (
    `missione_id` BIGINT NOT NULL,
    `mezzo_id` BIGINT NOT NULL,
    `assegnato_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`missione_id`, `mezzo_id`),
    FOREIGN KEY (`missione_id`) REFERENCES `missione`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`mezzo_id`) REFERENCES `mezzo`(`id`) ON DELETE CASCADE,
    INDEX `idx_mezzo` (`mezzo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Missione_Materiali (Many-to-Many)
DROP TABLE IF EXISTS `missione_materiali`;
CREATE TABLE `missione_materiali` (
    `missione_id` BIGINT NOT NULL,
    `materiale_id` BIGINT NOT NULL,
    `quantita_usata` INT NOT NULL DEFAULT 1,
    `assegnato_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`missione_id`, `materiale_id`),
    FOREIGN KEY (`missione_id`) REFERENCES `missione`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`materiale_id`) REFERENCES `materiale`(`id`) ON DELETE CASCADE,
    INDEX `idx_materiale` (`materiale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- INSERT ROLES
INSERT INTO `role` (`id`, `name`) VALUES (1, 'ADMIN'), (2, 'OPERATORE');
-- INSERT ABILITA
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (1, 'Primo Soccorso', 'Abilità certificata Primo Soccorso');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (2, 'BLS-D', 'Abilità certificata BLS-D');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (3, 'Guida Avanzata', 'Abilità certificata Guida Avanzata');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (4, 'Soccorso Alpino', 'Abilità certificata Soccorso Alpino');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (5, 'Sommozzatore', 'Abilità certificata Sommozzatore');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (6, 'Antincendio', 'Abilità certificata Antincendio');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (7, 'Gestione Crisi', 'Abilità certificata Gestione Crisi');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (8, 'Unità Cinofila', 'Abilità certificata Unità Cinofila');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (9, 'Logistica', 'Abilità certificata Logistica');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (10, 'Telecomunicazioni', 'Abilità certificata Telecomunicazioni');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (11, 'NBCR', 'Abilità certificata NBCR');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (12, 'Psicologia Emergenza', 'Abilità certificata Psicologia Emergenza');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (13, 'Cartografia', 'Abilità certificata Cartografia');
INSERT INTO `abilita` (`id`, `nome`, `descrizione`) VALUES (14, 'Uso Drone', 'Abilità certificata Uso Drone');
-- INSERT PATENTI
INSERT INTO `patente` (`id`, `tipo`, `descrizione`) VALUES (1, 'B', 'Patente di guida tipo B');
INSERT INTO `patente` (`id`, `tipo`, `descrizione`) VALUES (2, 'C', 'Patente di guida tipo C');
INSERT INTO `patente` (`id`, `tipo`, `descrizione`) VALUES (3, 'D', 'Patente di guida tipo D');
INSERT INTO `patente` (`id`, `tipo`, `descrizione`) VALUES (4, 'CQC', 'Patente di guida tipo CQC');
INSERT INTO `patente` (`id`, `tipo`, `descrizione`) VALUES (5, 'Nautica', 'Patente di guida tipo Nautica');
INSERT INTO `patente` (`id`, `tipo`, `descrizione`) VALUES (6, 'Elicottero', 'Patente di guida tipo Elicottero');
INSERT INTO `patente` (`id`, `tipo`, `descrizione`) VALUES (7, 'Speciale', 'Patente di guida tipo Speciale');
-- INSERT ADMIN
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `attivo`, `first_attempt`) VALUES (1, 'admin@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Super', 'Admin', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (1, 1);
-- INSERT OPERATORI
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (2, 'op2_marco.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Gialli', '2005-02-05', '3333869522', 'Via Roma 85, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (2, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (2, 8, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (2, 10, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (2, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (3, 'op3_stefano.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Rizzo', '1998-04-12', '3339424126', 'Via Roma 85, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (3, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (3, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (3, 8, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (3, 1, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (3, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (3);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (4, 'op4_anna.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Anna', 'De Luca', '2003-10-28', '3333192238', 'Via Roma 78, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (4, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (4, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (4);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (5, 'op5_giulia.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giulia', 'Ferrari', '1982-11-09', '3334993870', 'Via Roma 84, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (5, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (5, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (5, 11, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (5, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (5);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (6, 'op6_sara.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Colombo', '1992-08-04', '3336679511', 'Via Roma 47, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (6, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (6, 11, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (6, 4, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (6, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (6);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (7, 'op7_giovanni.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Gialli', '2005-10-28', '3338508055', 'Via Roma 50, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (7, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (7, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (7);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (8, 'op8_marco.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Esposito', '2001-11-20', '3338811098', 'Via Roma 64, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (8, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (8, 3, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (8, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (8);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (9, 'op9_giulia.romano@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giulia', 'Romano', '1983-09-19', '3335918083', 'Via Roma 9, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (9, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (9, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (9);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (10, 'op10_matteo.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Rizzo', '1981-09-27', '3332339417', 'Via Roma 88, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (10, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (10, 3, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (10, 11, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (10, 8, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (10, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (10);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (11, 'op11_alessandro.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'Rossi', '1983-02-05', '3333506063', 'Via Roma 40, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (11, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (11, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (11);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (12, 'op12_luigi.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Rossi', '1999-03-26', '3337601263', 'Via Roma 27, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (12, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (12, 6, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (12, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (12);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (13, 'op13_paolo.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Verdi', '2003-12-24', '3333983830', 'Via Roma 86, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (13, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (13, 7, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (13, 3, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (13, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (13);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (14, 'op14_matteo.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Bruno', '1997-09-03', '3338391378', 'Via Roma 92, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (14, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (14, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (14);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (15, 'op15_roberto.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Roberto', 'Costa', '1980-07-29', '3331386132', 'Via Roma 44, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (15, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (15, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (15, 7, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (15, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (15);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (16, 'op16_giovanni.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Verdi', '2006-02-26', '3338522448', 'Via Roma 33, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (16, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (16, 1, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (16, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (16);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (17, 'op17_federico.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Neri', '1992-02-06', '3339443674', 'Via Roma 76, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (17, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (17, 11, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (17, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (17, 4, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (17, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (17);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (18, 'op18_alessandro.fontana@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'Fontana', '1980-06-16', '3335917511', 'Via Roma 67, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (18, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (18, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (18, 5, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (18, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (18);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (19, 'op19_giovanni.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Ferrari', '1982-03-22', '3334948412', 'Via Roma 92, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (19, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (19, 6, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (19, 1, '2020-01-01', 'MCTC Roma');
INSERT INTO `caposquadra` (`user_id`) VALUES (19);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (20, 'op20_francesca.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'De Luca', '1992-03-01', '3336933917', 'Via Roma 33, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (20, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (20, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (20, 2, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (20, 6, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (21, 'op21_roberto.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Roberto', 'Rizzo', '2002-06-10', '3331551994', 'Via Roma 82, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (21, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (21, 2, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (22, 'op22_francesca.ricci@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Ricci', '1978-09-08', '3333891647', 'Via Roma 92, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (22, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (23, 'op23_francesca.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Gallo', '1989-06-09', '3331410745', 'Via Roma 49, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (23, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (23, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (23, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (23, 9, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (23, 6, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (24, 'op24_paolo.fontana@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Fontana', '1986-02-19', '3333294699', 'Via Roma 19, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (24, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (24, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (24, 7, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (25, 'op25_elena.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Gialli', '1977-12-03', '3336817576', 'Via Roma 25, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (25, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (25, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (25, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (25, 5, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (25, 7, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (26, 'op26_matteo.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Gallo', '1992-03-10', '3333229103', 'Via Roma 64, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (26, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (26, 11, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (26, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (26, 9, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (27, 'op27_elena.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Bruno', '1991-07-19', '3338957014', 'Via Roma 19, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (27, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (27, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (27, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (27, 5, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (28, 'op28_davide.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Davide', 'Esposito', '1980-11-02', '3339249484', 'Via Roma 65, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (28, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (28, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (28, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (29, 'op29_sara.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Gallo', '1981-03-28', '3335607990', 'Via Roma 98, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (29, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (29, 5, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (29, 4, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (30, 'op30_luca.fontana@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Fontana', '1985-12-09', '3337870045', 'Via Roma 39, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (30, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (30, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (30, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (31, 'op31_elena.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Ferrari', '1987-07-19', '3333788641', 'Via Roma 54, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (31, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (31, 9, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (32, 'op32_federico.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'De Luca', '1991-08-28', '3335676650', 'Via Roma 27, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (32, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (32, 10, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (33, 'op33_marco.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Bianchi', '1987-01-19', '3336114364', 'Via Roma 51, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (33, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (33, 3, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (33, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (33, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (34, 'op34_paolo.fontana@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Fontana', '1977-03-17', '3338929872', 'Via Roma 92, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (34, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (34, 10, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (35, 'op35_giulia.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giulia', 'Esposito', '1978-05-06', '3336121439', 'Via Roma 64, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (35, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (36, 'op36_davide.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Davide', 'Neri', '1988-11-18', '3334606570', 'Via Roma 59, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (36, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (36, 3, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (36, 8, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (37, 'op37_mario.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Gialli', '1993-06-14', '3336594637', 'Via Roma 12, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (37, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (38, 'op38_francesca.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Rossi', '2000-10-27', '3334365794', 'Via Roma 68, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (38, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (38, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (38, 10, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (39, 'op39_elena.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Verdi', '1990-08-23', '3332497858', 'Via Roma 62, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (39, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (39, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (39, 8, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (40, 'op40_stefano.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Rossi', '1992-08-30', '3334233018', 'Via Roma 96, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (40, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (40, 11, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (40, 6, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (40, 7, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (41, 'op41_roberto.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Roberto', 'Conti', '1994-11-28', '3338756706', 'Via Roma 72, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (41, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (41, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (41, 8, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (41, 3, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (42, 'op42_anna.ricci@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Anna', 'Ricci', '1980-09-30', '3331956254', 'Via Roma 45, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (42, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (42, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (42, 7, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (42, 1, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (43, 'op43_luigi.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Colombo', '2000-03-01', '3335071949', 'Via Roma 59, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (43, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (43, 5, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (44, 'op44_francesca.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Verdi', '1981-09-07', '3332444315', 'Via Roma 69, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (44, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (44, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (44, 11, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (44, 4, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (45, 'op45_giovanni.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Rossi', '1993-10-06', '3334341156', 'Via Roma 77, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (45, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (46, 'op46_federico.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Verdi', '1982-01-28', '3335330718', 'Via Roma 15, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (46, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (46, 10, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (46, 6, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (47, 'op47_davide.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Davide', 'Colombo', '1982-09-18', '3335055912', 'Via Roma 76, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (47, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (47, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (47, 13, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (47, 2, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (48, 'op48_marco.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Bruno', '1995-01-21', '3339447921', 'Via Roma 59, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (48, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (48, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (48, 1, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (49, 'op49_stefano.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Bianchi', '2002-06-05', '3331967508', 'Via Roma 44, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (49, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (49, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (49, 13, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (49, 4, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (50, 'op50_alessandro.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'De Luca', '2004-05-07', '3336686560', 'Via Roma 2, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (50, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (51, 'op51_luigi.fontana@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Fontana', '1976-10-31', '3337425446', 'Via Roma 18, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (51, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (52, 'op52_luca.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Gallo', '1980-08-20', '3331425596', 'Via Roma 3, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (52, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (52, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (52, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (52, 3, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (52, 6, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (53, 'op53_mario.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Conti', '1991-03-13', '3335129774', 'Via Roma 96, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (53, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (54, 'op54_elena.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Ferrari', '1983-06-19', '3339537395', 'Via Roma 82, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (54, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (54, 12, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (55, 'op55_luca.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Gialli', '1983-10-21', '3332454394', 'Via Roma 20, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (55, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (55, 7, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (55, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (55, 3, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (55, 3, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (56, 'op56_matteo.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Conti', '1977-01-15', '3332987592', 'Via Roma 54, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (56, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (56, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (56, 3, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (56, 1, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (56, 6, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (57, 'op57_marco.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Ferrari', '1980-08-24', '3338915474', 'Via Roma 85, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (57, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (57, 14, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (57, 2, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (58, 'op58_elena.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Verdi', '1988-04-07', '3339424248', 'Via Roma 38, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (58, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (58, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (58, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (58, 4, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (59, 'op59_alessandro.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'Bruno', '2003-04-02', '3333956879', 'Via Roma 62, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (59, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (59, 11, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (59, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (59, 6, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (60, 'op60_francesca.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Costa', '2001-05-07', '3337157727', 'Via Roma 18, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (60, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (60, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (60, 14, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (60, 5, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (61, 'op61_marco.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Bruno', '1977-11-26', '3335826682', 'Via Roma 56, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (61, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (62, 'op62_luigi.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Costa', '1978-06-29', '3332410459', 'Via Roma 55, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (62, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (62, 4, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (62, 4, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (63, 'op63_sara.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Rossi', '1977-09-26', '3336635985', 'Via Roma 67, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (63, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (64, 'op64_roberto.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Roberto', 'Verdi', '1986-11-07', '3339662764', 'Via Roma 5, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (64, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (64, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (65, 'op65_anna.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Anna', 'Conti', '1985-05-03', '3339142672', 'Via Roma 85, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (65, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (65, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (65, 8, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (65, 6, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (65, 3, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (66, 'op66_marco.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Bianchi', '1997-12-15', '3332508712', 'Via Roma 5, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (66, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (66, 7, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (66, 1, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (67, 'op67_elena.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Costa', '1984-09-10', '3335347044', 'Via Roma 96, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (67, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (67, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (67, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (67, 12, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (67, 2, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (68, 'op68_elena.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'De Luca', '1978-03-23', '3337572130', 'Via Roma 73, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (68, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (68, 10, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (69, 'op69_luca.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Costa', '1979-04-26', '3336403235', 'Via Roma 24, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (69, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (69, 1, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (70, 'op70_sara.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Colombo', '1985-10-26', '3337901377', 'Via Roma 64, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (70, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (70, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (71, 'op71_paolo.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Bianchi', '1981-04-10', '3337310522', 'Via Roma 60, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (71, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (71, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (71, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (71, 6, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (71, 5, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (72, 'op72_luca.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Gallo', '1998-07-06', '3336687809', 'Via Roma 65, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (72, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (72, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (72, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (72, 4, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (73, 'op73_anna.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Anna', 'Bruno', '2002-01-12', '3337672304', 'Via Roma 70, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (73, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (73, 10, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (74, 'op74_giovanni.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Verdi', '1986-12-29', '3339978618', 'Via Roma 9, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (74, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (74, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (74, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (74, 1, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (75, 'op75_giovanni.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Rizzo', '1995-10-16', '3332073433', 'Via Roma 46, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (75, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (76, 'op76_paolo.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Neri', '1986-12-08', '3334455307', 'Via Roma 7, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (76, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (77, 'op77_matteo.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Neri', '1978-11-18', '3335245113', 'Via Roma 43, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (77, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (77, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (77, 10, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (78, 'op78_stefano.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Conti', '2000-01-04', '3331463049', 'Via Roma 84, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (78, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (78, 11, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (78, 3, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (79, 'op79_sara.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Conti', '2002-08-02', '3333826489', 'Via Roma 89, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (79, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (79, 4, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (80, 'op80_matteo.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Esposito', '1998-11-14', '3332395126', 'Via Roma 29, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (80, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (80, 6, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (81, 'op81_federico.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Rizzo', '1979-03-03', '3339409715', 'Via Roma 20, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (81, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (81, 4, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (82, 'op82_paolo.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Bruno', '1996-05-31', '3338919201', 'Via Roma 17, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (82, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (83, 'op83_marco.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Esposito', '2006-04-03', '3339139671', 'Via Roma 89, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (83, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (84, 'op84_federico.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Neri', '1995-06-15', '3332385435', 'Via Roma 60, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (84, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (84, 2, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (85, 'op85_elena.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Esposito', '2001-10-21', '3335515236', 'Via Roma 88, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (85, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (85, 7, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (85, 6, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (86, 'op86_luca.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Gialli', '1992-11-28', '3334074749', 'Via Roma 5, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (86, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (87, 'op87_elena.ricci@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Ricci', '1993-12-01', '3338085079', 'Via Roma 33, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (87, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (88, 'op88_luca.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Esposito', '1977-03-03', '3336539392', 'Via Roma 19, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (88, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (89, 'op89_mario.ricci@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Ricci', '1988-04-27', '3338072066', 'Via Roma 84, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (89, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (89, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (89, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (89, 7, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (90, 'op90_paolo.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'De Luca', '2001-10-03', '3337765240', 'Via Roma 38, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (90, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (91, 'op91_roberto.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Roberto', 'Esposito', '1993-11-11', '3333947707', 'Via Roma 31, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (91, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (91, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (91, 11, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (91, 6, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (92, 'op92_giulia.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giulia', 'Verdi', '1988-06-05', '3332259510', 'Via Roma 77, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (92, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (92, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (92, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (93, 'op93_elena.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Verdi', '2005-08-24', '3337118914', 'Via Roma 13, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (93, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (93, 2, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (93, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (94, 'op94_federico.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Bruno', '2001-03-22', '3333649267', 'Via Roma 55, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (94, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (94, 1, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (95, 'op95_francesca.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Gialli', '1990-03-22', '3333132589', 'Via Roma 41, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (95, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (95, 8, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (95, 7, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (96, 'op96_luigi.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Gialli', '1977-06-22', '3339294330', 'Via Roma 57, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (96, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (96, 1, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (97, 'op97_federico.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Bianchi', '1996-02-29', '3335770535', 'Via Roma 48, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (97, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (97, 6, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (98, 'op98_luigi.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Gallo', '2002-05-29', '3337326195', 'Via Roma 63, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (98, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (98, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (98, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (98, 10, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (98, 4, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (99, 'op99_sara.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Rossi', '1977-01-20', '3339176973', 'Via Roma 47, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (99, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (99, 8, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (99, 9, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (100, 'op100_giovanni.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Rossi', '1979-03-24', '3332506284', 'Via Roma 75, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (100, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (100, 7, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (101, 'op101_matteo.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Gialli', '1991-09-06', '3333452791', 'Via Roma 69, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (101, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (101, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (101, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (101, 8, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (102, 'op102_mario.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Bianchi', '1989-02-02', '3339238362', 'Via Roma 56, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (102, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (102, 3, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (102, 5, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (102, 7, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (103, 'op103_sara.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Gialli', '1993-05-15', '3333114944', 'Via Roma 59, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (103, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (103, 12, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (104, 'op104_luigi.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Neri', '1984-02-17', '3339685972', 'Via Roma 24, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (104, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (104, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (104, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (104, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (105, 'op105_sara.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Costa', '2005-05-14', '3333829504', 'Via Roma 79, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (105, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (105, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (106, 'op106_alessandro.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'Gallo', '1997-01-17', '3332415621', 'Via Roma 46, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (106, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (106, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (106, 1, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (107, 'op107_anna.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Anna', 'Colombo', '1992-02-24', '3339982128', 'Via Roma 8, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (107, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (107, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (107, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (107, 10, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (107, 7, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (108, 'op108_giulia.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giulia', 'De Luca', '1982-02-09', '3332138144', 'Via Roma 15, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (108, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (108, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (108, 3, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (109, 'op109_giovanni.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Ferrari', '1984-04-22', '3338984955', 'Via Roma 78, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (109, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (109, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (109, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (110, 'op110_mario.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Rossi', '1978-07-16', '3332238650', 'Via Roma 71, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (110, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (110, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (110, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (110, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (111, 'op111_paolo.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Bianchi', '1991-04-30', '3338522142', 'Via Roma 11, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (111, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (111, 3, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (112, 'op112_federico.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Gallo', '2005-04-28', '3332405730', 'Via Roma 58, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (112, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (113, 'op113_alessandro.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'Gialli', '1988-04-29', '3334856797', 'Via Roma 70, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (113, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (113, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (113, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (114, 'op114_paolo.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Conti', '2006-06-14', '3337762106', 'Via Roma 21, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (114, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (115, 'op115_luca.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Esposito', '1997-03-26', '3331211200', 'Via Roma 35, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (115, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (115, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (116, 'op116_matteo.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Neri', '1993-12-31', '3334998753', 'Via Roma 39, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (116, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (116, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (116, 4, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (117, 'op117_elena.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Verdi', '2003-12-28', '3332541630', 'Via Roma 32, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (117, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (117, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (117, 4, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (117, 3, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (118, 'op118_alessandro.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'Colombo', '1987-08-05', '3335371675', 'Via Roma 72, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (118, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (118, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (118, 10, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (119, 'op119_roberto.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Roberto', 'Ferrari', '1999-10-23', '3338827372', 'Via Roma 60, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (119, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (119, 4, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (120, 'op120_elena.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Costa', '2006-01-05', '3336166962', 'Via Roma 43, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (120, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (120, 5, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (120, 1, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (121, 'op121_marco.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Esposito', '1985-05-13', '3337267328', 'Via Roma 12, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (121, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (121, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (121, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (121, 11, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (121, 7, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (122, 'op122_matteo.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Rizzo', '2004-06-29', '3335510833', 'Via Roma 89, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (122, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (122, 8, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (122, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (122, 3, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (123, 'op123_elena.fontana@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Fontana', '1985-11-02', '3339612068', 'Via Roma 19, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (123, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (123, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (123, 10, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (124, 'op124_francesca.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Colombo', '1998-08-03', '3331657988', 'Via Roma 66, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (124, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (124, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (124, 4, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (125, 'op125_matteo.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'De Luca', '1987-08-17', '3336069653', 'Via Roma 79, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (125, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (125, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (125, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (126, 'op126_giulia.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giulia', 'Rizzo', '1988-02-08', '3333270063', 'Via Roma 46, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (126, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (126, 7, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (127, 'op127_anna.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Anna', 'Colombo', '1981-07-19', '3333030037', 'Via Roma 82, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (127, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (127, 2, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (128, 'op128_alessandro.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'Neri', '1985-01-25', '3334619225', 'Via Roma 26, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (128, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (128, 2, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (129, 'op129_stefano.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Neri', '1980-11-11', '3337046138', 'Via Roma 8, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (129, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (129, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (129, 3, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (130, 'op130_giovanni.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Bianchi', '1996-12-13', '3332063706', 'Via Roma 39, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (130, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (130, 3, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (130, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (130, 7, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (131, 'op131_matteo.ricci@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Ricci', '1978-12-05', '3333505843', 'Via Roma 18, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (131, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (131, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (131, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (131, 3, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (132, 'op132_luca.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Rizzo', '1988-08-21', '3338881378', 'Via Roma 71, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (132, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (132, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (133, 'op133_davide.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Davide', 'Rizzo', '1983-11-12', '3334538245', 'Via Roma 28, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (133, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (133, 13, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (133, 5, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (134, 'op134_stefano.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Conti', '2002-04-05', '3335632087', 'Via Roma 96, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (134, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (134, 7, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (134, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (134, 1, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (135, 'op135_matteo.romano@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Romano', '1981-10-05', '3331094601', 'Via Roma 10, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (135, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (135, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (135, 12, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (136, 'op136_stefano.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Conti', '1991-03-29', '3339268077', 'Via Roma 86, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (136, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (136, 5, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (137, 'op137_anna.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Anna', 'Gialli', '1991-05-05', '3331037492', 'Via Roma 16, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (137, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (137, 5, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (137, 5, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (138, 'op138_federico.neri@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Neri', '1986-10-18', '3338098901', 'Via Roma 100, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (138, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (138, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (139, 'op139_federico.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Conti', '1977-02-10', '3335900799', 'Via Roma 23, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (139, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (139, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (139, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (139, 14, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (139, 3, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (140, 'op140_giovanni.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Esposito', '1985-06-30', '3339259618', 'Via Roma 26, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (140, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (140, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (140, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (140, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (141, 'op141_sara.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Costa', '1989-10-30', '3337396157', 'Via Roma 95, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (141, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (141, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (141, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (141, 12, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (141, 5, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (142, 'op142_mario.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'De Luca', '1993-09-06', '3335749334', 'Via Roma 7, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (142, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (143, 'op143_marco.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Verdi', '1999-09-25', '3339759004', 'Via Roma 64, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (143, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (143, 1, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (144, 'op144_luca.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Bruno', '2005-05-10', '3334002928', 'Via Roma 57, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (144, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (144, 6, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (145, 'op145_roberto.romano@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Roberto', 'Romano', '2002-01-26', '3335274469', 'Via Roma 15, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (145, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (146, 'op146_marco.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Rizzo', '2004-05-12', '3336327708', 'Via Roma 66, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (146, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (146, 4, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (147, 'op147_giovanni.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Colombo', '1978-05-06', '3338832475', 'Via Roma 7, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (147, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (147, 4, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (148, 'op148_sara.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Gallo', '1979-03-04', '3337727260', 'Via Roma 84, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (148, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (148, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (148, 2, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (148, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (149, 'op149_matteo.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Bruno', '1984-03-15', '3338449877', 'Via Roma 52, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (149, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (149, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (149, 2, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (149, 13, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (150, 'op150_marco.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Ferrari', '1994-04-23', '3336129939', 'Via Roma 52, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (150, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (150, 8, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (151, 'op151_alessandro.fontana@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'Fontana', '1991-03-07', '3332785092', 'Via Roma 21, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (151, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (152, 'op152_stefano.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Ferrari', '1983-08-27', '3334380949', 'Via Roma 13, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (152, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (152, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (152, 6, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (153, 'op153_elena.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Bianchi', '1986-02-08', '3337569873', 'Via Roma 47, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (153, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (153, 6, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (154, 'op154_anna.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Anna', 'Rossi', '1985-09-08', '3333688874', 'Via Roma 50, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (154, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (154, 2, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (154, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (154, 7, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (155, 'op155_matteo.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Costa', '1980-07-18', '3339293038', 'Via Roma 65, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (155, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (155, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (155, 3, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (155, 12, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (156, 'op156_elena.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'De Luca', '1995-12-11', '3339243727', 'Via Roma 49, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (156, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (157, 'op157_matteo.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Conti', '2001-10-16', '3336813764', 'Via Roma 67, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (157, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (157, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (158, 'op158_francesca.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Gallo', '1988-03-27', '3332980721', 'Via Roma 56, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (158, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (158, 2, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (158, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (159, 'op159_mario.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Colombo', '1993-09-10', '3337537166', 'Via Roma 100, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (159, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (159, 5, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (159, 1, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (160, 'op160_davide.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Davide', 'Colombo', '1980-06-23', '3338929383', 'Via Roma 49, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (160, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (160, 8, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (160, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (160, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (161, 'op161_matteo.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Gallo', '1986-03-28', '3333522446', 'Via Roma 79, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (161, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (161, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (161, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (161, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (162, 'op162_elena.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Costa', '1990-06-29', '3333811278', 'Via Roma 72, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (162, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (163, 'op163_mario.ricci@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Ricci', '1977-02-09', '3332390692', 'Via Roma 73, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (163, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (163, 2, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (163, 13, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (164, 'op164_elena.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Conti', '2006-02-11', '3338795834', 'Via Roma 84, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (164, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (164, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (164, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (164, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (165, 'op165_mario.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Rizzo', '2003-03-06', '3338033997', 'Via Roma 20, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (165, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (165, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (165, 11, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (165, 8, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (165, 1, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (166, 'op166_mario.de luca@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'De Luca', '1983-07-26', '3335610839', 'Via Roma 74, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (166, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (166, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (166, 7, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (167, 'op167_francesca.romano@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Romano', '1985-06-05', '3337943828', 'Via Roma 75, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (167, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (167, 7, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (167, 4, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (168, 'op168_giovanni.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giovanni', 'Verdi', '1999-06-03', '3333052309', 'Via Roma 78, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (168, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (169, 'op169_paolo.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Gallo', '2003-07-06', '3334599217', 'Via Roma 68, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (169, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (169, 12, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (169, 6, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (170, 'op170_sara.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Esposito', '1996-02-19', '3339511301', 'Via Roma 9, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (170, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (170, 14, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (170, 6, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (171, 'op171_stefano.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Costa', '2004-10-18', '3336513483', 'Via Roma 36, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (171, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (171, 1, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (171, 3, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (172, 'op172_mario.fontana@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Fontana', '1997-05-20', '3331353619', 'Via Roma 79, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (172, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (172, 7, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (172, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (172, 3, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (172, 5, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (173, 'op173_marco.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Esposito', '1983-12-09', '3335284322', 'Via Roma 11, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (173, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (173, 12, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (173, 3, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (174, 'op174_francesca.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Rossi', '1994-09-20', '3338368032', 'Via Roma 31, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (174, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (174, 2, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (174, 4, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (175, 'op175_stefano.fontana@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Stefano', 'Fontana', '1982-09-21', '3337732795', 'Via Roma 41, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (175, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (175, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (175, 3, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (175, 9, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (176, 'op176_luigi.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Conti', '1988-10-23', '3332259549', 'Via Roma 72, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (176, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (176, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (176, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (176, 8, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (176, 5, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (177, 'op177_alessandro.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Alessandro', 'Esposito', '1994-09-03', '3335232192', 'Via Roma 38, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (177, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (177, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (178, 'op178_elena.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Costa', '1985-02-14', '3331426672', 'Via Roma 56, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (178, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (178, 3, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (178, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (179, 'op179_anna.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Anna', 'Verdi', '2004-06-11', '3336199215', 'Via Roma 25, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (179, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (179, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (179, 13, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (180, 'op180_marco.gallo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Marco', 'Gallo', '2000-05-19', '3338737742', 'Via Roma 4, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (180, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (180, 7, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (180, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (180, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (181, 'op181_roberto.ricci@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Roberto', 'Ricci', '1982-08-19', '3332490812', 'Via Roma 9, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (181, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (181, 5, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (181, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (182, 'op182_luigi.rizzo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Rizzo', '2002-09-27', '3332810894', 'Via Roma 78, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (182, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (182, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (182, 2, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (182, 3, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (183, 'op183_paolo.ferrari@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Ferrari', '1992-08-15', '3339402276', 'Via Roma 67, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (183, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (183, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (183, 6, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (183, 4, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (184, 'op184_davide.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Davide', 'Bianchi', '2003-08-19', '3337192922', 'Via Roma 69, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (184, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (184, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (185, 'op185_sara.verdi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Sara', 'Verdi', '1996-03-07', '3336214210', 'Via Roma 55, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (185, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (185, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (186, 'op186_paolo.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Conti', '1991-01-26', '3338206730', 'Via Roma 85, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (186, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (186, 11, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (186, 4, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (187, 'op187_federico.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Federico', 'Esposito', '1995-07-31', '3339272405', 'Via Roma 51, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (187, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (187, 2, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (188, 'op188_giulia.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giulia', 'Gialli', '1983-09-09', '3334658305', 'Via Roma 68, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (188, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (188, 9, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (188, 1, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (189, 'op189_elena.romano@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Romano', '2001-05-21', '3339677576', 'Via Roma 97, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (189, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (189, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (189, 6, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (190, 'op190_paolo.esposito@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Esposito', '2005-05-30', '3333065407', 'Via Roma 85, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (190, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (190, 5, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (191, 'op191_paolo.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Paolo', 'Gialli', '1999-10-04', '3334436167', 'Via Roma 16, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (191, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (191, 1, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (191, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (191, 11, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (192, 'op192_mario.costa@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Mario', 'Costa', '2004-05-10', '3336432134', 'Via Roma 82, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (192, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (193, 'op193_luca.colombo@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Colombo', '1995-06-14', '3336151907', 'Via Roma 38, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (193, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (193, 8, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (193, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (193, 3, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (194, 'op194_luca.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luca', 'Conti', '1994-02-11', '3338336032', 'Via Roma 83, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (194, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (194, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (195, 'op195_luigi.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Luigi', 'Bianchi', '1988-07-08', '3331858622', 'Via Roma 6, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (195, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (195, 14, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (195, 10, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (195, 8, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (196, 'op196_giulia.romano@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giulia', 'Romano', '1988-10-01', '3331591769', 'Via Roma 85, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (196, 2);
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (197, 'op197_francesca.conti@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Francesca', 'Conti', '1995-12-02', '3334655495', 'Via Roma 62, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (197, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (197, 12, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (197, 4, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (197, 3, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (197, 1, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (198, 'op198_elena.gialli@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Elena', 'Gialli', '1990-04-01', '3332532442', 'Via Roma 70, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (198, 2);
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (198, 3, '2022-05-15', 'MCTC Milano');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (199, 'op199_davide.bianchi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Davide', 'Bianchi', '1990-06-30', '3332051585', 'Via Roma 46, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (199, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (199, 6, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (199, 7, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (200, 'op200_giulia.bruno@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Giulia', 'Bruno', '1999-07-26', '3335488807', 'Via Roma 66, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (200, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (200, 14, 'AVANZATO');
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `data_nascita`, `telefono`, `indirizzo`, `attivo`, `first_attempt`) VALUES (201, 'op201_matteo.rossi@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Matteo', 'Rossi', '1989-02-15', '3332754404', 'Via Roma 22, Roma', TRUE, FALSE);
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES (201, 2);
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (201, 13, 'AVANZATO');
INSERT INTO `user_abilita` (`user_id`, `abilita_id`, `livello`) VALUES (201, 1, 'AVANZATO');
INSERT INTO `user_patenti` (`user_id`, `patente_id`, `conseguita_il`, `rilasciata_da`) VALUES (201, 3, '2022-05-15', 'MCTC Milano');
-- INSERT MEZZI
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (1, 'ELICOTTERO 1', 'Mezzo operativo standard', 'ELICOTTERO', 'AB245CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (2, 'BATTISCOPA 2', 'Mezzo operativo standard', 'BATTISCOPA', 'AB835CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (3, 'AUTO_MEDICA 3', 'Mezzo operativo standard', 'AUTO_MEDICA', 'AB470CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (4, 'FURGONE 4', 'Mezzo operativo standard', 'FURGONE', 'AB467CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (5, 'AUTO_MEDICA 5', 'Mezzo operativo standard', 'AUTO_MEDICA', 'AB435CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (6, 'ELICOTTERO 6', 'Mezzo operativo standard', 'ELICOTTERO', 'AB814CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (7, 'ELICOTTERO 7', 'Mezzo operativo standard', 'ELICOTTERO', 'AB692CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (8, 'AUTOPOMPA 8', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB146CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (9, 'ELICOTTERO 9', 'Mezzo operativo standard', 'ELICOTTERO', 'AB974CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (10, 'AMBULANZA 10', 'Mezzo operativo standard', 'AMBULANZA', 'AB186CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (11, 'ELICOTTERO 11', 'Mezzo operativo standard', 'ELICOTTERO', 'AB401CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (12, 'BATTISCOPA 12', 'Mezzo operativo standard', 'BATTISCOPA', 'AB264CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (13, 'AUTOPOMPA 13', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB822CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (14, 'AUTO_MEDICA 14', 'Mezzo operativo standard', 'AUTO_MEDICA', 'AB527CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (15, 'AUTOPOMPA 15', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB596CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (16, 'FURGONE 16', 'Mezzo operativo standard', 'FURGONE', 'AB392CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (17, 'AUTOPOMPA 17', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB531CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (18, 'AUTOPOMPA 18', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB270CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (19, 'AUTOPOMPA 19', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB978CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (20, 'AUTO_MEDICA 20', 'Mezzo operativo standard', 'AUTO_MEDICA', 'AB363CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (21, 'AUTOPOMPA 21', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB294CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (22, 'ELICOTTERO 22', 'Mezzo operativo standard', 'ELICOTTERO', 'AB678CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (23, 'AMBULANZA 23', 'Mezzo operativo standard', 'AMBULANZA', 'AB738CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (24, 'AUTOPOMPA 24', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB827CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (25, 'BATTISCOPA 25', 'Mezzo operativo standard', 'BATTISCOPA', 'AB227CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (26, 'ELICOTTERO 26', 'Mezzo operativo standard', 'ELICOTTERO', 'AB180CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (27, 'AUTOPOMPA 27', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB154CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (28, 'ELICOTTERO 28', 'Mezzo operativo standard', 'ELICOTTERO', 'AB173CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (29, 'BATTISCOPA 29', 'Mezzo operativo standard', 'BATTISCOPA', 'AB871CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (30, 'AUTO_MEDICA 30', 'Mezzo operativo standard', 'AUTO_MEDICA', 'AB477CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (31, 'ELICOTTERO 31', 'Mezzo operativo standard', 'ELICOTTERO', 'AB156CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (32, 'BATTISCOPA 32', 'Mezzo operativo standard', 'BATTISCOPA', 'AB268CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (33, 'AUTO_MEDICA 33', 'Mezzo operativo standard', 'AUTO_MEDICA', 'AB243CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (34, 'AMBULANZA 34', 'Mezzo operativo standard', 'AMBULANZA', 'AB939CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (35, 'FURGONE 35', 'Mezzo operativo standard', 'FURGONE', 'AB877CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (36, 'AUTO_MEDICA 36', 'Mezzo operativo standard', 'AUTO_MEDICA', 'AB974CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (37, 'BATTISCOPA 37', 'Mezzo operativo standard', 'BATTISCOPA', 'AB838CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (38, 'AMBULANZA 38', 'Mezzo operativo standard', 'AMBULANZA', 'AB844CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (39, 'AUTOPOMPA 39', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB857CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (40, 'ELICOTTERO 40', 'Mezzo operativo standard', 'ELICOTTERO', 'AB138CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (41, 'AMBULANZA 41', 'Mezzo operativo standard', 'AMBULANZA', 'AB897CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (42, 'BATTISCOPA 42', 'Mezzo operativo standard', 'BATTISCOPA', 'AB221CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (43, 'AUTO_MEDICA 43', 'Mezzo operativo standard', 'AUTO_MEDICA', 'AB774CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (44, 'BATTISCOPA 44', 'Mezzo operativo standard', 'BATTISCOPA', 'AB926CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (45, 'BATTISCOPA 45', 'Mezzo operativo standard', 'BATTISCOPA', 'AB367CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (46, 'AMBULANZA 46', 'Mezzo operativo standard', 'AMBULANZA', 'AB707CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (47, 'BATTISCOPA 47', 'Mezzo operativo standard', 'BATTISCOPA', 'AB197CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (48, 'AUTOPOMPA 48', 'Mezzo operativo standard', 'AUTOPOMPA', 'AB808CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (49, 'ELICOTTERO 49', 'Mezzo operativo standard', 'ELICOTTERO', 'AB668CD', TRUE);
INSERT INTO `mezzo` (`id`, `nome`, `descrizione`, `tipo`, `targa`, `disponibile`) VALUES (50, 'AUTO_MEDICA 50', 'Mezzo operativo standard', 'AUTO_MEDICA', 'AB255CD', TRUE);
-- INSERT MATERIALI
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (1, 'Bende', 'Materiale standard Bende', 'MEDICO', 338, TRUE);
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (2, 'Defibrillatore', 'Materiale standard Defibrillatore', 'MEDICO', 290, TRUE);
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (3, 'Estintore', 'Materiale standard Estintore', 'LOGISTICO', 338, TRUE);
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (4, 'Torcia', 'Materiale standard Torcia', 'TECNICO', 402, TRUE);
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (5, 'Radio', 'Materiale standard Radio', 'MEDICO', 498, TRUE);
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (6, 'Tenda', 'Materiale standard Tenda', 'TECNICO', 220, TRUE);
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (7, 'Generatore', 'Materiale standard Generatore', 'LOGISTICO', 398, TRUE);
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (8, 'Corda', 'Materiale standard Corda', 'MEDICO', 362, TRUE);
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (9, 'Barella', 'Materiale standard Barella', 'MEDICO', 157, TRUE);
INSERT INTO `materiale` (`id`, `nome`, `descrizione`, `tipo`, `quantita`, `disponibile`) VALUES (10, 'Ossigeno', 'Materiale standard Ossigeno', 'TECNICO', 255, TRUE);
-- INSERT RICHIESTE E MISSIONI
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (1, 'Emergenza #1 - Incidente simulato', 'Via Test 1, Roma', 41.86010162882025, 12.468144392351467, 'Mario Rossi', 'mario1@test.com', '3331234567', 'CHIUSA', 'TOK1');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (1, 1, 12, 'Gestione emergenza #1', 'Via Test 1, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (1, 112, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (1, 48, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (1, 132, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (2, 'Emergenza #2 - Incidente simulato', 'Via Test 2, Roma', 41.91733604678153, 12.557142255523486, 'Mario Rossi', 'mario2@test.com', '3331234567', 'CHIUSA', 'TOK2');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (2, 2, 7, 'Gestione emergenza #2', 'Via Test 2, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (2, 26, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (2, 47, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (2, 197, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (2, 49);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (3, 'Emergenza #3 - Incidente simulato', 'Via Test 3, Roma', 41.914784023626865, 12.53324420679414, 'Mario Rossi', 'mario3@test.com', '3331234567', 'IN_CORSO', 'TOK3');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (3, 3, 3, 'Gestione emergenza #3', 'Via Test 3, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (3, 25, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (3, 176, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (3, 105, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (3, 178, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (3, 5);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (4, 'Emergenza #4 - Incidente simulato', 'Via Test 4, Roma', 41.9028693394287, 12.586305322605375, 'Mario Rossi', 'mario4@test.com', '3331234567', 'IGNORATA', 'TOK4');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (5, 'Emergenza #5 - Incidente simulato', 'Via Test 5, Roma', 41.945936445138905, 12.510418024357746, 'Mario Rossi', 'mario5@test.com', '3331234567', 'ATTIVA', 'TOK5');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (6, 'Emergenza #6 - Incidente simulato', 'Via Test 6, Roma', 41.98603698934969, 12.523156623091152, 'Mario Rossi', 'mario6@test.com', '3331234567', 'IGNORATA', 'TOK6');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (7, 'Emergenza #7 - Incidente simulato', 'Via Test 7, Roma', 42.00027600636112, 12.418228573964852, 'Mario Rossi', 'mario7@test.com', '3331234567', 'IGNORATA', 'TOK7');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (8, 'Emergenza #8 - Incidente simulato', 'Via Test 8, Roma', 41.88800000267299, 12.562633033410135, 'Mario Rossi', 'mario8@test.com', '3331234567', 'ATTIVA', 'TOK8');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (9, 'Emergenza #9 - Incidente simulato', 'Via Test 9, Roma', 41.95776956008636, 12.513769063498831, 'Mario Rossi', 'mario9@test.com', '3331234567', 'IN_CORSO', 'TOK9');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (4, 9, 7, 'Gestione emergenza #9', 'Via Test 9, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (4, 166, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (4, 103, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (4, 136, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (10, 'Emergenza #10 - Incidente simulato', 'Via Test 10, Roma', 41.84634802117037, 12.452849879262589, 'Mario Rossi', 'mario10@test.com', '3331234567', 'IGNORATA', 'TOK10');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (11, 'Emergenza #11 - Incidente simulato', 'Via Test 11, Roma', 41.9934874672206, 12.465544231076201, 'Mario Rossi', 'mario11@test.com', '3331234567', 'IN_CORSO', 'TOK11');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (5, 11, 5, 'Gestione emergenza #11', 'Via Test 11, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (5, 23, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (5, 66, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (12, 'Emergenza #12 - Incidente simulato', 'Via Test 12, Roma', 41.92009328595586, 12.51271900504746, 'Mario Rossi', 'mario12@test.com', '3331234567', 'ATTIVA', 'TOK12');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (13, 'Emergenza #13 - Incidente simulato', 'Via Test 13, Roma', 41.83245131369741, 12.497543665431841, 'Mario Rossi', 'mario13@test.com', '3331234567', 'IGNORATA', 'TOK13');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (14, 'Emergenza #14 - Incidente simulato', 'Via Test 14, Roma', 41.83609975192065, 12.471880084923292, 'Mario Rossi', 'mario14@test.com', '3331234567', 'IN_CORSO', 'TOK14');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (6, 14, 3, 'Gestione emergenza #14', 'Via Test 14, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (6, 173, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (6, 79, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (6, 60, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (6, 30, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (6, 48);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (15, 'Emergenza #15 - Incidente simulato', 'Via Test 15, Roma', 41.89541064886073, 12.568659052647554, 'Mario Rossi', 'mario15@test.com', '3331234567', 'IGNORATA', 'TOK15');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (16, 'Emergenza #16 - Incidente simulato', 'Via Test 16, Roma', 41.98657435444174, 12.47727523810404, 'Mario Rossi', 'mario16@test.com', '3331234567', 'CHIUSA', 'TOK16');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (7, 16, 11, 'Gestione emergenza #16', 'Via Test 16, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (7, 121, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (7, 66, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (7, 38, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (17, 'Emergenza #17 - Incidente simulato', 'Via Test 17, Roma', 41.90654835564973, 12.57923744549497, 'Mario Rossi', 'mario17@test.com', '3331234567', 'CHIUSA', 'TOK17');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (8, 17, 8, 'Gestione emergenza #17', 'Via Test 17, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (8, 107, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (8, 43, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (8, 22, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (8, 65, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (8, 167, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (8, 19);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (18, 'Emergenza #18 - Incidente simulato', 'Via Test 18, Roma', 41.91169105254002, 12.507732136617685, 'Mario Rossi', 'mario18@test.com', '3331234567', 'ATTIVA', 'TOK18');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (19, 'Emergenza #19 - Incidente simulato', 'Via Test 19, Roma', 41.85315584674377, 12.496952296808162, 'Mario Rossi', 'mario19@test.com', '3331234567', 'IGNORATA', 'TOK19');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (20, 'Emergenza #20 - Incidente simulato', 'Via Test 20, Roma', 41.92982131029687, 12.559247158343288, 'Mario Rossi', 'mario20@test.com', '3331234567', 'ATTIVA', 'TOK20');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (21, 'Emergenza #21 - Incidente simulato', 'Via Test 21, Roma', 41.87630789215107, 12.502976901913796, 'Mario Rossi', 'mario21@test.com', '3331234567', 'CHIUSA', 'TOK21');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (9, 21, 1, 'Gestione emergenza #21', 'Via Test 21, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (9, 168, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (9, 112, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (9, 29, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (9, 10);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (22, 'Emergenza #22 - Incidente simulato', 'Via Test 22, Roma', 41.82566560917079, 12.459285754379842, 'Mario Rossi', 'mario22@test.com', '3331234567', 'CHIUSA', 'TOK22');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (10, 22, 15, 'Gestione emergenza #22', 'Via Test 22, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (10, 71, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (10, 170, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (10, 67, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (10, 11);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (23, 'Emergenza #23 - Incidente simulato', 'Via Test 23, Roma', 41.94472628313498, 12.586460173070467, 'Mario Rossi', 'mario23@test.com', '3331234567', 'CHIUSA', 'TOK23');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (11, 23, 7, 'Gestione emergenza #23', 'Via Test 23, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (11, 68, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (11, 32, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (11, 11);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (24, 'Emergenza #24 - Incidente simulato', 'Via Test 24, Roma', 41.97120327248375, 12.47280807185841, 'Mario Rossi', 'mario24@test.com', '3331234567', 'IGNORATA', 'TOK24');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (25, 'Emergenza #25 - Incidente simulato', 'Via Test 25, Roma', 41.873501504421014, 12.468841257799786, 'Mario Rossi', 'mario25@test.com', '3331234567', 'IGNORATA', 'TOK25');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (26, 'Emergenza #26 - Incidente simulato', 'Via Test 26, Roma', 41.915378232746306, 12.572774850082835, 'Mario Rossi', 'mario26@test.com', '3331234567', 'IN_CORSO', 'TOK26');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (12, 26, 9, 'Gestione emergenza #26', 'Via Test 26, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (12, 194, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (12, 61, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (27, 'Emergenza #27 - Incidente simulato', 'Via Test 27, Roma', 41.99706071464692, 12.424766496157002, 'Mario Rossi', 'mario27@test.com', '3331234567', 'ATTIVA', 'TOK27');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (28, 'Emergenza #28 - Incidente simulato', 'Via Test 28, Roma', 41.90159285625967, 12.459709639456415, 'Mario Rossi', 'mario28@test.com', '3331234567', 'ATTIVA', 'TOK28');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (29, 'Emergenza #29 - Incidente simulato', 'Via Test 29, Roma', 41.92117044894074, 12.478862390054683, 'Mario Rossi', 'mario29@test.com', '3331234567', 'IN_CORSO', 'TOK29');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (13, 29, 11, 'Gestione emergenza #29', 'Via Test 29, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (13, 167, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (13, 76, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (30, 'Emergenza #30 - Incidente simulato', 'Via Test 30, Roma', 41.856946957415346, 12.583152081242957, 'Mario Rossi', 'mario30@test.com', '3331234567', 'IGNORATA', 'TOK30');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (31, 'Emergenza #31 - Incidente simulato', 'Via Test 31, Roma', 41.97898603423088, 12.425962881628843, 'Mario Rossi', 'mario31@test.com', '3331234567', 'CHIUSA', 'TOK31');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (14, 31, 7, 'Gestione emergenza #31', 'Via Test 31, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (14, 115, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (14, 168, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (14, 73, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (14, 116, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (14, 70, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (14, 40);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (32, 'Emergenza #32 - Incidente simulato', 'Via Test 32, Roma', 41.977675881300236, 12.463400151544691, 'Mario Rossi', 'mario32@test.com', '3331234567', 'ATTIVA', 'TOK32');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (33, 'Emergenza #33 - Incidente simulato', 'Via Test 33, Roma', 41.97889249410159, 12.42505877582975, 'Mario Rossi', 'mario33@test.com', '3331234567', 'ATTIVA', 'TOK33');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (34, 'Emergenza #34 - Incidente simulato', 'Via Test 34, Roma', 41.90335691912713, 12.499186235998085, 'Mario Rossi', 'mario34@test.com', '3331234567', 'IGNORATA', 'TOK34');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (35, 'Emergenza #35 - Incidente simulato', 'Via Test 35, Roma', 41.843106291994715, 12.587301993631774, 'Mario Rossi', 'mario35@test.com', '3331234567', 'CHIUSA', 'TOK35');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (15, 35, 13, 'Gestione emergenza #35', 'Via Test 35, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (15, 151, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (15, 192, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (36, 'Emergenza #36 - Incidente simulato', 'Via Test 36, Roma', 41.86321341185291, 12.472329982379039, 'Mario Rossi', 'mario36@test.com', '3331234567', 'IN_CORSO', 'TOK36');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (16, 36, 11, 'Gestione emergenza #36', 'Via Test 36, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (16, 131, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (16, 107, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (16, 55, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (16, 159, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (37, 'Emergenza #37 - Incidente simulato', 'Via Test 37, Roma', 41.96068430749748, 12.568174084913666, 'Mario Rossi', 'mario37@test.com', '3331234567', 'IGNORATA', 'TOK37');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (38, 'Emergenza #38 - Incidente simulato', 'Via Test 38, Roma', 41.85095144718979, 12.591168795839156, 'Mario Rossi', 'mario38@test.com', '3331234567', 'ATTIVA', 'TOK38');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (39, 'Emergenza #39 - Incidente simulato', 'Via Test 39, Roma', 41.904479356576616, 12.430552703728093, 'Mario Rossi', 'mario39@test.com', '3331234567', 'IN_CORSO', 'TOK39');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (17, 39, 11, 'Gestione emergenza #39', 'Via Test 39, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (17, 181, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (17, 47, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (17, 4);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (40, 'Emergenza #40 - Incidente simulato', 'Via Test 40, Roma', 41.82310275377007, 12.436651956736142, 'Mario Rossi', 'mario40@test.com', '3331234567', 'IGNORATA', 'TOK40');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (41, 'Emergenza #41 - Incidente simulato', 'Via Test 41, Roma', 41.85496640467892, 12.498007421469202, 'Mario Rossi', 'mario41@test.com', '3331234567', 'IN_CORSO', 'TOK41');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (18, 41, 15, 'Gestione emergenza #41', 'Via Test 41, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (18, 85, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (18, 45, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (18, 195, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (18, 50);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (42, 'Emergenza #42 - Incidente simulato', 'Via Test 42, Roma', 41.91534882649212, 12.54895253599103, 'Mario Rossi', 'mario42@test.com', '3331234567', 'IGNORATA', 'TOK42');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (43, 'Emergenza #43 - Incidente simulato', 'Via Test 43, Roma', 41.97537371813036, 12.434873168435724, 'Mario Rossi', 'mario43@test.com', '3331234567', 'IN_CORSO', 'TOK43');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (19, 43, 9, 'Gestione emergenza #43', 'Via Test 43, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (19, 112, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (19, 64, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (19, 155, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (19, 121, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (44, 'Emergenza #44 - Incidente simulato', 'Via Test 44, Roma', 41.89376378923782, 12.46951060124066, 'Mario Rossi', 'mario44@test.com', '3331234567', 'IN_CORSO', 'TOK44');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (20, 44, 10, 'Gestione emergenza #44', 'Via Test 44, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (20, 136, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (20, 149, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (45, 'Emergenza #45 - Incidente simulato', 'Via Test 45, Roma', 41.83832942306405, 12.58429984220753, 'Mario Rossi', 'mario45@test.com', '3331234567', 'CHIUSA', 'TOK45');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (21, 45, 1, 'Gestione emergenza #45', 'Via Test 45, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (21, 145, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (21, 169, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (21, 109, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (21, 86, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (21, 58, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (46, 'Emergenza #46 - Incidente simulato', 'Via Test 46, Roma', 41.99783346441614, 12.414876837809436, 'Mario Rossi', 'mario46@test.com', '3331234567', 'CHIUSA', 'TOK46');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (22, 46, 13, 'Gestione emergenza #46', 'Via Test 46, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (22, 108, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (22, 44, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (47, 'Emergenza #47 - Incidente simulato', 'Via Test 47, Roma', 41.813855960777694, 12.503134417077858, 'Mario Rossi', 'mario47@test.com', '3331234567', 'IGNORATA', 'TOK47');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (48, 'Emergenza #48 - Incidente simulato', 'Via Test 48, Roma', 41.888500358658106, 12.498031001046655, 'Mario Rossi', 'mario48@test.com', '3331234567', 'IGNORATA', 'TOK48');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (49, 'Emergenza #49 - Incidente simulato', 'Via Test 49, Roma', 41.887402204459015, 12.50534956239975, 'Mario Rossi', 'mario49@test.com', '3331234567', 'IGNORATA', 'TOK49');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (50, 'Emergenza #50 - Incidente simulato', 'Via Test 50, Roma', 41.846127633728045, 12.517061915554862, 'Mario Rossi', 'mario50@test.com', '3331234567', 'ATTIVA', 'TOK50');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (51, 'Emergenza #51 - Incidente simulato', 'Via Test 51, Roma', 41.90261611514122, 12.490743072549224, 'Mario Rossi', 'mario51@test.com', '3331234567', 'IGNORATA', 'TOK51');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (52, 'Emergenza #52 - Incidente simulato', 'Via Test 52, Roma', 41.84919158661161, 12.396636901013695, 'Mario Rossi', 'mario52@test.com', '3331234567', 'CHIUSA', 'TOK52');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (23, 52, 7, 'Gestione emergenza #52', 'Via Test 52, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (23, 169, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (23, 43, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (23, 188, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (53, 'Emergenza #53 - Incidente simulato', 'Via Test 53, Roma', 41.949804799797285, 12.468504853345681, 'Mario Rossi', 'mario53@test.com', '3331234567', 'ATTIVA', 'TOK53');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (54, 'Emergenza #54 - Incidente simulato', 'Via Test 54, Roma', 41.80917439078595, 12.524903600912962, 'Mario Rossi', 'mario54@test.com', '3331234567', 'IGNORATA', 'TOK54');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (55, 'Emergenza #55 - Incidente simulato', 'Via Test 55, Roma', 41.86976252371881, 12.558036233626545, 'Mario Rossi', 'mario55@test.com', '3331234567', 'CHIUSA', 'TOK55');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (24, 55, 15, 'Gestione emergenza #55', 'Via Test 55, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (24, 147, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (24, 186, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (56, 'Emergenza #56 - Incidente simulato', 'Via Test 56, Roma', 41.817818566549306, 12.474911265074525, 'Mario Rossi', 'mario56@test.com', '3331234567', 'IGNORATA', 'TOK56');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (57, 'Emergenza #57 - Incidente simulato', 'Via Test 57, Roma', 41.81533239200944, 12.470031894271944, 'Mario Rossi', 'mario57@test.com', '3331234567', 'IN_CORSO', 'TOK57');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (25, 57, 15, 'Gestione emergenza #57', 'Via Test 57, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (25, 83, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (25, 108, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (58, 'Emergenza #58 - Incidente simulato', 'Via Test 58, Roma', 41.85272585825152, 12.465587307688029, 'Mario Rossi', 'mario58@test.com', '3331234567', 'IN_CORSO', 'TOK58');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (26, 58, 14, 'Gestione emergenza #58', 'Via Test 58, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (26, 112, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (26, 114, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (26, 27);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (59, 'Emergenza #59 - Incidente simulato', 'Via Test 59, Roma', 41.996794821662746, 12.559107616475902, 'Mario Rossi', 'mario59@test.com', '3331234567', 'CHIUSA', 'TOK59');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (27, 59, 9, 'Gestione emergenza #59', 'Via Test 59, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (27, 111, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (27, 170, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (27, 99, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (60, 'Emergenza #60 - Incidente simulato', 'Via Test 60, Roma', 41.805843636919676, 12.454605862887476, 'Mario Rossi', 'mario60@test.com', '3331234567', 'CHIUSA', 'TOK60');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (28, 60, 3, 'Gestione emergenza #60', 'Via Test 60, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (28, 163, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (28, 147, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (28, 149, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (28, 60, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (61, 'Emergenza #61 - Incidente simulato', 'Via Test 61, Roma', 41.92353822493908, 12.492939413603743, 'Mario Rossi', 'mario61@test.com', '3331234567', 'CHIUSA', 'TOK61');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (29, 61, 12, 'Gestione emergenza #61', 'Via Test 61, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (29, 170, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (29, 61, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (29, 177, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (29, 31);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (62, 'Emergenza #62 - Incidente simulato', 'Via Test 62, Roma', 41.89710696306321, 12.584833085730354, 'Mario Rossi', 'mario62@test.com', '3331234567', 'IN_CORSO', 'TOK62');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (30, 62, 9, 'Gestione emergenza #62', 'Via Test 62, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (30, 102, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (30, 59, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (30, 41);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (63, 'Emergenza #63 - Incidente simulato', 'Via Test 63, Roma', 41.83237737811841, 12.432117338891475, 'Mario Rossi', 'mario63@test.com', '3331234567', 'CHIUSA', 'TOK63');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (31, 63, 9, 'Gestione emergenza #63', 'Via Test 63, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (31, 60, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (31, 160, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (31, 149, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (31, 41, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (64, 'Emergenza #64 - Incidente simulato', 'Via Test 64, Roma', 41.808560591939916, 12.481464843189508, 'Mario Rossi', 'mario64@test.com', '3331234567', 'CHIUSA', 'TOK64');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (32, 64, 14, 'Gestione emergenza #64', 'Via Test 64, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (32, 179, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (32, 141, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (32, 10);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (65, 'Emergenza #65 - Incidente simulato', 'Via Test 65, Roma', 41.818403214166224, 12.444960917883053, 'Mario Rossi', 'mario65@test.com', '3331234567', 'IN_CORSO', 'TOK65');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (33, 65, 15, 'Gestione emergenza #65', 'Via Test 65, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (33, 100, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (33, 134, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (66, 'Emergenza #66 - Incidente simulato', 'Via Test 66, Roma', 41.96714972093858, 12.45899923875732, 'Mario Rossi', 'mario66@test.com', '3331234567', 'CHIUSA', 'TOK66');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (34, 66, 13, 'Gestione emergenza #66', 'Via Test 66, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (34, 137, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (34, 193, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (34, 52, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (34, 35);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (67, 'Emergenza #67 - Incidente simulato', 'Via Test 67, Roma', 41.84176706360468, 12.542187073037198, 'Mario Rossi', 'mario67@test.com', '3331234567', 'ATTIVA', 'TOK67');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (68, 'Emergenza #68 - Incidente simulato', 'Via Test 68, Roma', 41.88606953751696, 12.436603168438296, 'Mario Rossi', 'mario68@test.com', '3331234567', 'ATTIVA', 'TOK68');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (69, 'Emergenza #69 - Incidente simulato', 'Via Test 69, Roma', 41.90302514207987, 12.580321375572641, 'Mario Rossi', 'mario69@test.com', '3331234567', 'IGNORATA', 'TOK69');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (70, 'Emergenza #70 - Incidente simulato', 'Via Test 70, Roma', 41.89727009044288, 12.411839479605241, 'Mario Rossi', 'mario70@test.com', '3331234567', 'CHIUSA', 'TOK70');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (35, 70, 10, 'Gestione emergenza #70', 'Via Test 70, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (35, 40, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (35, 94, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (35, 47);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (71, 'Emergenza #71 - Incidente simulato', 'Via Test 71, Roma', 41.86788533529142, 12.44257792388089, 'Mario Rossi', 'mario71@test.com', '3331234567', 'CHIUSA', 'TOK71');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (36, 71, 11, 'Gestione emergenza #71', 'Via Test 71, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (36, 182, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (36, 101, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (36, 126, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (36, 181, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (72, 'Emergenza #72 - Incidente simulato', 'Via Test 72, Roma', 41.93568306712273, 12.502708432580754, 'Mario Rossi', 'mario72@test.com', '3331234567', 'IN_CORSO', 'TOK72');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (37, 72, 4, 'Gestione emergenza #72', 'Via Test 72, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (37, 57, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (37, 46, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (37, 179, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (37, 21);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (73, 'Emergenza #73 - Incidente simulato', 'Via Test 73, Roma', 41.903221333320914, 12.426093371965527, 'Mario Rossi', 'mario73@test.com', '3331234567', 'ATTIVA', 'TOK73');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (74, 'Emergenza #74 - Incidente simulato', 'Via Test 74, Roma', 41.98740748611697, 12.535414448690863, 'Mario Rossi', 'mario74@test.com', '3331234567', 'ATTIVA', 'TOK74');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (75, 'Emergenza #75 - Incidente simulato', 'Via Test 75, Roma', 41.885442533251464, 12.532740196804548, 'Mario Rossi', 'mario75@test.com', '3331234567', 'ATTIVA', 'TOK75');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (76, 'Emergenza #76 - Incidente simulato', 'Via Test 76, Roma', 41.99305012262336, 12.569423789613502, 'Mario Rossi', 'mario76@test.com', '3331234567', 'IGNORATA', 'TOK76');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (77, 'Emergenza #77 - Incidente simulato', 'Via Test 77, Roma', 41.90017625045867, 12.41722114049479, 'Mario Rossi', 'mario77@test.com', '3331234567', 'IN_CORSO', 'TOK77');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (38, 77, 5, 'Gestione emergenza #77', 'Via Test 77, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (38, 139, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (38, 38, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (78, 'Emergenza #78 - Incidente simulato', 'Via Test 78, Roma', 42.001369003103974, 12.454121065692515, 'Mario Rossi', 'mario78@test.com', '3331234567', 'IGNORATA', 'TOK78');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (79, 'Emergenza #79 - Incidente simulato', 'Via Test 79, Roma', 41.95231560833949, 12.505462104814034, 'Mario Rossi', 'mario79@test.com', '3331234567', 'IN_CORSO', 'TOK79');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (39, 79, 3, 'Gestione emergenza #79', 'Via Test 79, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (39, 191, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (39, 121, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (39, 61, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (39, 93, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (39, 51, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (80, 'Emergenza #80 - Incidente simulato', 'Via Test 80, Roma', 41.922099505586154, 12.448546232168075, 'Mario Rossi', 'mario80@test.com', '3331234567', 'IN_CORSO', 'TOK80');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (40, 80, 14, 'Gestione emergenza #80', 'Via Test 80, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (40, 71, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (40, 95, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (81, 'Emergenza #81 - Incidente simulato', 'Via Test 81, Roma', 41.89022439829894, 12.509496352790945, 'Mario Rossi', 'mario81@test.com', '3331234567', 'CHIUSA', 'TOK81');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (41, 81, 10, 'Gestione emergenza #81', 'Via Test 81, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (41, 173, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (41, 32, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (41, 41);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (82, 'Emergenza #82 - Incidente simulato', 'Via Test 82, Roma', 41.80478857836345, 12.42608043905282, 'Mario Rossi', 'mario82@test.com', '3331234567', 'IN_CORSO', 'TOK82');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (42, 82, 6, 'Gestione emergenza #82', 'Via Test 82, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (42, 196, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (42, 32, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (42, 76, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (83, 'Emergenza #83 - Incidente simulato', 'Via Test 83, Roma', 41.85578693136822, 12.590214875019752, 'Mario Rossi', 'mario83@test.com', '3331234567', 'CHIUSA', 'TOK83');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (43, 83, 7, 'Gestione emergenza #83', 'Via Test 83, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (43, 94, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (43, 160, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (43, 150, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (43, 55, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (43, 102, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (84, 'Emergenza #84 - Incidente simulato', 'Via Test 84, Roma', 41.833985379100916, 12.53915339050275, 'Mario Rossi', 'mario84@test.com', '3331234567', 'CHIUSA', 'TOK84');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (44, 84, 11, 'Gestione emergenza #84', 'Via Test 84, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (44, 33, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (44, 85, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (44, 44, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (44, 23, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (44, 48);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (85, 'Emergenza #85 - Incidente simulato', 'Via Test 85, Roma', 41.94441238813094, 12.447422346893319, 'Mario Rossi', 'mario85@test.com', '3331234567', 'IN_CORSO', 'TOK85');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (45, 85, 11, 'Gestione emergenza #85', 'Via Test 85, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (45, 170, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (45, 152, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (45, 21, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (45, 1);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (86, 'Emergenza #86 - Incidente simulato', 'Via Test 86, Roma', 41.99037360170309, 12.592277905286418, 'Mario Rossi', 'mario86@test.com', '3331234567', 'ATTIVA', 'TOK86');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (87, 'Emergenza #87 - Incidente simulato', 'Via Test 87, Roma', 41.85115962442541, 12.455412694161028, 'Mario Rossi', 'mario87@test.com', '3331234567', 'ATTIVA', 'TOK87');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (88, 'Emergenza #88 - Incidente simulato', 'Via Test 88, Roma', 41.83607582941526, 12.445633839733524, 'Mario Rossi', 'mario88@test.com', '3331234567', 'IGNORATA', 'TOK88');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (89, 'Emergenza #89 - Incidente simulato', 'Via Test 89, Roma', 41.9648533276132, 12.46736372181073, 'Mario Rossi', 'mario89@test.com', '3331234567', 'ATTIVA', 'TOK89');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (90, 'Emergenza #90 - Incidente simulato', 'Via Test 90, Roma', 41.94276171399271, 12.451494222084916, 'Mario Rossi', 'mario90@test.com', '3331234567', 'IN_CORSO', 'TOK90');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (46, 90, 2, 'Gestione emergenza #90', 'Via Test 90, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (46, 99, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (46, 183, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (46, 94, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (46, 120, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (46, 50);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (91, 'Emergenza #91 - Incidente simulato', 'Via Test 91, Roma', 41.967308101326196, 12.515476165930254, 'Mario Rossi', 'mario91@test.com', '3331234567', 'CHIUSA', 'TOK91');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (47, 91, 10, 'Gestione emergenza #91', 'Via Test 91, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (47, 138, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (47, 162, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (47, 188, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (47, 64, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (92, 'Emergenza #92 - Incidente simulato', 'Via Test 92, Roma', 41.83104267196181, 12.467491548704023, 'Mario Rossi', 'mario92@test.com', '3331234567', 'CHIUSA', 'TOK92');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (48, 92, 4, 'Gestione emergenza #92', 'Via Test 92, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (48, 162, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (48, 124, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (48, 23);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (93, 'Emergenza #93 - Incidente simulato', 'Via Test 93, Roma', 41.98649962946722, 12.400671481668667, 'Mario Rossi', 'mario93@test.com', '3331234567', 'IGNORATA', 'TOK93');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (94, 'Emergenza #94 - Incidente simulato', 'Via Test 94, Roma', 41.86573436938141, 12.565294407232617, 'Mario Rossi', 'mario94@test.com', '3331234567', 'CHIUSA', 'TOK94');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (49, 94, 9, 'Gestione emergenza #94', 'Via Test 94, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (49, 76, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (49, 62, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (49, 99, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (95, 'Emergenza #95 - Incidente simulato', 'Via Test 95, Roma', 41.89471199729954, 12.454590664329086, 'Mario Rossi', 'mario95@test.com', '3331234567', 'IN_CORSO', 'TOK95');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (50, 95, 3, 'Gestione emergenza #95', 'Via Test 95, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (50, 131, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (50, 113, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (50, 193, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (50, 144, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (50, 28, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (96, 'Emergenza #96 - Incidente simulato', 'Via Test 96, Roma', 41.9376785798063, 12.567902313755376, 'Mario Rossi', 'mario96@test.com', '3331234567', 'IN_CORSO', 'TOK96');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (51, 96, 1, 'Gestione emergenza #96', 'Via Test 96, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (51, 102, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (51, 66, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (51, 171, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (51, 161, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (51, 70, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (51, 42);
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (97, 'Emergenza #97 - Incidente simulato', 'Via Test 97, Roma', 41.9425109340884, 12.551694758087901, 'Mario Rossi', 'mario97@test.com', '3331234567', 'IN_CORSO', 'TOK97');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (52, 97, 10, 'Gestione emergenza #97', 'Via Test 97, Roma', 'IN_CORSO', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (52, 194, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (52, 196, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (52, 51, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (52, 161, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (52, 115, NOW());
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (98, 'Emergenza #98 - Incidente simulato', 'Via Test 98, Roma', 41.949594186166095, 12.480279327274316, 'Mario Rossi', 'mario98@test.com', '3331234567', 'ATTIVA', 'TOK98');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (99, 'Emergenza #99 - Incidente simulato', 'Via Test 99, Roma', 41.993690210939285, 12.468183317738912, 'Mario Rossi', 'mario99@test.com', '3331234567', 'IGNORATA', 'TOK99');
INSERT INTO `richiesta_soccorso` (`id`, `descrizione`, `indirizzo`, `latitudine`, `longitudine`, `nome_segnalante`, `email_segnalante`, `telefono_segnalante`, `stato`, `token_convalida`) VALUES (100, 'Emergenza #100 - Incidente simulato', 'Via Test 100, Roma', 41.96354595757508, 12.484263750789586, 'Mario Rossi', 'mario100@test.com', '3331234567', 'CHIUSA', 'TOK100');
INSERT INTO `missione` (`id`, `richiesta_id`, `caposquadra_id`, `obiettivo`, `posizione`, `stato`, `inizio_at`) VALUES (53, 100, 15, 'Gestione emergenza #100', 'Via Test 100, Roma', 'CHIUSA', NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (53, 86, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (53, 191, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (53, 130, NOW());
INSERT INTO `missione_operatori` (`missione_id`, `operatore_id`, `assegnato_at`) VALUES (53, 134, NOW());
INSERT INTO `missione_mezzi` (`missione_id`, `mezzo_id`) VALUES (53, 8);
SET FOREIGN_KEY_CHECKS = 1;