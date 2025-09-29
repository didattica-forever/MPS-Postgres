/*
    per prima cosa collegarsi con il database:
        psql -h localhost -W -U postgres

*/
-- 1. Creazione del Database
CREATE DATABASE corsodb;

-- 2. Creazione dell'Utente
CREATE ROLE mpsuser WITH
    LOGIN
    PASSWORD 'LaTuaPasswordSicura!'
    NOSUPERUSER
    NOCREATEDB;

-- 3. Assegnazione dei Permessi (Database)
GRANT CONNECT, CREATE ON DATABASE corsodb TO mpsuser;

-- 4. Assegnazione dei Permessi (Schema 'public')
GRANT ALL ON SCHEMA public TO mpsuser;

-- 5. Assegnazione dei Permessi (Oggetti attuali nello schema public)
GRANT ALL ON ALL TABLES IN SCHEMA public TO mpsuser;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO mpsuser;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO mpsuser;

-- 6. Assegnazione dei Permessi (Oggetti futuri)
ALTER DEFAULT PRIVILEGES FOR ROLE mpsuser IN SCHEMA public
    GRANT ALL ON TABLES TO mpsuser;
ALTER DEFAULT PRIVILEGES FOR ROLE mpsuser IN SCHEMA public
    GRANT ALL ON SEQUENCES TO mpsuser;
ALTER DEFAULT PRIVILEGES FOR ROLE mpsuser IN SCHEMA public
    GRANT ALL ON FUNCTIONS TO mpsuser;
