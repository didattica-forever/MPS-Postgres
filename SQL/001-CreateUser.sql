-- *** FASE DI PULIZIA (CLEANUP) ***

-- 1. Connettiti al database 'postgres' (o template1) per iniziare la pulizia.
-- Questo è necessario per poter eliminare il database 'corsodb' in seguito.
-- -- \c postgres

-- 2. Rimuovi le dipendenze degli oggetti futuri del ruolo 'mpsuser'.
--    Queste definizioni sono globali all'utente ma devono essere rimosse
--    mentre l'utente *esiste*.
DROP DATABASE IF EXISTS corsodb;
DROP ROLE IF EXISTS mpsuser;


-- Ricreazione del ruolo mpsuser (necessario per ALTER DEFAULT PRIVILEGES,
-- che non accetta "IF EXISTS" ed è specifico per utente)
CREATE ROLE mpsuser WITH
    LOGIN
    PASSWORD 'manager!'
    NOSUPERUSER
    NOCREATEDB;

-- 3. Crea il database 'corsodb'
CREATE DATABASE corsodb;

-- 4. Rimuovi le dipendenze che il ruolo 'postgres' avrebbe potuto definire su 'mpsuser'
--    per evitare conflitti nella riassegnazione dei permessi (nel caso esista un vecchio utente 'postgres')
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    REVOKE ALL ON TABLES FROM mpsuser;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    REVOKE ALL ON SEQUENCES FROM mpsuser;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    REVOKE ALL ON FUNCTIONS FROM mpsuser;

-- 5. Riassegna la proprietà degli eventuali oggetti creati da mpsuser al superuser (se mpsuser esisteva)
REASSIGN OWNED BY mpsuser TO postgres;

-- (Il DROP ROLE è stato spostato sopra per semplicità, se necessario riposizionarlo qui)
DROP ROLE IF EXISTS mpsuser;

-- Ricreazione definitiva del ruolo
CREATE ROLE mpsuser WITH
    LOGIN
    PASSWORD 'manager!'
    NOSUPERUSER
    NOCREATEDB;

-- *** FASE DI CONFIGURAZIONE DEI PERMESSI ***

-- 6. Connettiti al database 'corsodb' per assegnare i permessi al suo interno.
-- -- \c corsodb

-- 7. Assegnazione dei permessi al nuovo ruolo 'mpsuser'

-- Permessi sul database (connessione, creazione temporanea)
GRANT ALL PRIVILEGES ON DATABASE corsodb TO mpsuser;

-- Permessi sullo schema 'public' (necessario per CREATE TABLE)
GRANT ALL PRIVILEGES ON SCHEMA public TO mpsuser;
GRANT USAGE ON SCHEMA public TO mpsuser;


-- Permessi sugli Oggetti Attuali (essenziali se il DB non è vuoto)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO mpsuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO mpsuser;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO mpsuser;


-- Permessi sugli Oggetti Futuri (Fondamentale per il controllo totale)

-- a) Oggetti futuri creati dal superuser ('postgres')
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    GRANT ALL PRIVILEGES ON TABLES TO mpsuser;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    GRANT ALL PRIVILEGES ON SEQUENCES TO mpsuser;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    GRANT ALL PRIVILEGES ON FUNCTIONS TO mpsuser;

-- b) Oggetti futuri creati da 'mpsuser' stesso (per il pieno controllo)
ALTER DEFAULT PRIVILEGES FOR ROLE mpsuser IN SCHEMA public
    GRANT ALL PRIVILEGES ON TABLES TO mpsuser;

-- 8. Ritorna al database 'postgres' per concludere lo script
-- -- \c postgres
