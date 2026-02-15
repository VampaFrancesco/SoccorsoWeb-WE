-- ==============================================================================
-- Script Database SoccorsoWeb - MySQL / MariaDB
-- Aggiornato con correzioni per entità User e integrità referenziale
-- ==============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Opzionale: Creazione DB se non esiste (decommentare se necessario)
-- DROP DATABASE IF EXISTS `soccorsodb_we`;
-- CREATE DATABASE `soccorsodb_we` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE `soccorsodb_we`;

-- ==============================================================================
-- CREAZIONE TABELLE
-- ==============================================================================

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
    `ruolo` VARCHAR(20) DEFAULT 'OPERATORE',
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

SET FOREIGN_KEY_CHECKS = 1;

-- ==============================================================================
-- POPOLAMENTO DATI INIZIALI
-- ==============================================================================

-- Inserimento ruoli
INSERT IGNORE INTO `role` (`id`, `name`) VALUES (1, 'ADMIN');
INSERT IGNORE INTO `role` (`id`, `name`) VALUES (2, 'OPERATORE');

-- Inserimento utente Admin (first_attempt=FALSE per test immediato)
-- Credenziali: admin@soccorsoweb.it / admin
INSERT IGNORE INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `attivo`, `first_attempt`) 
VALUES (1, 'admin@soccorsoweb.it', '$2a$10$k3nvKx6t4V.bb1iF2r2v0.RNkEyb0Qqbjoa0Sf/C7mqyBchzoCcQC', 'Admin', 'Admin', TRUE, FALSE);

-- Inserimento utente Operatore (first_attempt=FALSE per test immediato)
-- Credenziali: operatore@soccorsoweb.it / operatore
INSERT IGNORE INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `attivo`, `first_attempt`) 
VALUES (2, 'operatore@soccorsoweb.it', '$2a$10$C619opCvLBWfhxGnAoNGmeMllTvDEGYt6Hd.U4vZ0VJQUOhsYSA4G', 'Operatore', 'Operatore', TRUE, FALSE);

-- Assegnazione ruoli
INSERT IGNORE INTO `user_role` (`user_id`, `role_id`) VALUES (1, 1);
INSERT IGNORE INTO `user_role` (`user_id`, `role_id`) VALUES (2, 2);

-- Popolamento Abilità Base
INSERT IGNORE INTO `abilita` (`id`, `nome`, `descrizione`) VALUES
(1, 'Primo Soccorso', 'Certificazione BLS e primo soccorso'),
(2, 'Guida Mezzi Pesanti', 'Patente C/D e abilitazione mezzi speciali'),
(3, 'Soccorso Alpino', 'Specializzazione in recupero montano'),
(4, 'Sommozzatore', 'Abilitazione recupero acquatico');

-- Popolamento Mezzi Base
INSERT IGNORE INTO `mezzo` (`id`, `nome`, `tipo`, `targa`, `disponibile`) VALUES
(1, 'Ambulanza 01', 'AMBULANZA', 'AA000BB', TRUE),
(2, 'Autopompa 01', 'AUTOPOMPA', 'VF123XX', TRUE),
(3, 'Elicottero H1', 'ELICOTTERO', 'I-RESC', TRUE);
