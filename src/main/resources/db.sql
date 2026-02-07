-- ==============================================================================
-- Script Database SoccorsoWeb - MySQL / MariaDB
-- Generato dalle Entity JPA del progetto
-- ==============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS `railway`;
CREATE DATABASE `railway` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `railway`;

-- ==============================================================================
-- CREAZIONE TABELLE
-- ==============================================================================

-- Tabella Role
CREATE TABLE `role` (
                        `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
                        `name` VARCHAR(50) NOT NULL UNIQUE,
                        INDEX `idx_role_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella User
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
                        `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        INDEX `idx_email` (`email`),
                        INDEX `idx_attivo` (`attivo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella User_Role (Many-to-Many) - nome singolare come da entity
CREATE TABLE `user_role` (
                             `user_id` BIGINT NOT NULL,
                             `role_id` BIGINT NOT NULL,
                             PRIMARY KEY (`user_id`, `role_id`),
                             FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
                             FOREIGN KEY (`role_id`) REFERENCES `role`(`id`) ON DELETE CASCADE,
                             INDEX `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Patente
CREATE TABLE `patente` (
                           `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
                           `tipo` VARCHAR(50) NOT NULL UNIQUE,
                           `descrizione` TEXT NULL,
                           INDEX `idx_tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella User_Patenti (Many-to-Many)
CREATE TABLE `user_patenti` (
                                `user_id` BIGINT NOT NULL,
                                `patente_id` BIGINT NOT NULL,
                                `conseguita_il` DATE NULL,
                                PRIMARY KEY (`user_id`, `patente_id`),
                                FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
                                FOREIGN KEY (`patente_id`) REFERENCES `patente`(`id`) ON DELETE CASCADE,
                                INDEX `idx_patente_id` (`patente_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Abilita
CREATE TABLE `abilita` (
                           `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
                           `nome` VARCHAR(100) NOT NULL UNIQUE,
                           `descrizione` TEXT NULL,
                           INDEX `idx_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella User_Abilita (Many-to-Many)
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
CREATE TABLE `caposquadra` (
                               `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
                               `user_id` BIGINT NOT NULL UNIQUE,
                               FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE RESTRICT,
                               INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Squadra
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
                                      `stato` ENUM('ATTIVA', 'IN_CORSO', 'CHIUSA', 'IGNORATA'),
                                      `convalidata_at` TIMESTAMP NULL,
                                      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                      INDEX `idx_stato` (`stato`),
                                      INDEX `idx_email_segnalante` (`email_segnalante`),
                                      INDEX `idx_token` (`token_convalida`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabella Mezzo
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
INSERT INTO `role` (`id`, `name`) VALUES
                                      (1, 'ADMIN'),
                                      (2, 'OPERATORE');

-- Inserimento utente Admin
-- Credenziali: admin / admin
-- Password hashata con BCrypt (strength 10)
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `attivo`) VALUES
    (1, 'admin@soccorsoweb.it', '$2a$12$VQE1lW.rgc4Y877S5/d1qu5.ESFJtxqqDUQklcoYwW0yRn6K77dgS', 'Admin', 'Admin', TRUE);

-- Assegnazione ruolo ADMIN all'utente admin
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES
    (1, 1);

-- Inserimento utente Operatore
-- Credenziali: operatore@soccorsoweb.it / operatore
-- Password hashata con BCrypt (strength 10)
INSERT INTO `user` (`id`, `email`, `password`, `nome`, `cognome`, `attivo`) VALUES
    (2, 'operatore@soccorsoweb.it', '$2a$12$CuHtzbebRbw5ID24JQ1hV.qBKBuQzyeEVXvPmILEoHtyEufaALXlS', 'Operatore', 'Operatore', TRUE);

-- Assegnazione ruolo OPERATORE all'utente operatore
INSERT INTO `user_role` (`user_id`, `role_id`) VALUES
    (2, 2);

-- ==============================================================================
-- FINE SCRIPT
-- ==============================================================================
