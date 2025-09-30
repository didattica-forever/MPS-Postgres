DROP TABLE IF EXISTS clienti;

create table clienti ( 
		id_cliente int primary key,
		nome varchar(50),
		cognome varchar(50),
		email varchar(50),
		indirizzo varchar(100),
		citta varchar(50),
		provincia varchar(4),
		cap char(5) 
	);

ALTER TABLE clienti ADD COLUMN enabled boolean NOT NULL DEFAULT true;
ALTER TABLE clienti ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT NOW();
ALTER TABLE clienti ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT NOW();


-- Tabella 2: Log per registrare le azioni del trigger
DROP TABLE IF EXISTS logsistema;
CREATE TABLE LogSistema (
    ID SERIAL PRIMARY KEY,
    TimestampOperazione TIMESTAMP DEFAULT NOW(),
    Messaggio TEXT NOT NULL
);

-- Tabella 3: Log storico che copia tutti i campi della tabella Clienti
DROP TABLE IF EXISTS Log_Clienti;
CREATE TABLE Log_Clienti (
    ID SERIAL PRIMARY KEY,
    DataModifica TIMESTAMP DEFAULT NOW(),
    Operazione VARCHAR(10) NOT NULL, -- I, U, o D

    -- Campi copiati dalla tabella Clienti
    id_cliente INT NOT NULL,
    Nome VARCHAR(100),
    cognome varchar(50),
    Email VARCHAR(100),
    indirizzo varchar(100),
	 citta varchar(50),
	 provincia varchar(4),
	 cap char(5) 
);

ALTER TABLE Log_Clienti ADD COLUMN enabled boolean NOT NULL DEFAULT true;
ALTER TABLE Log_Clienti ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT NOW();
ALTER TABLE Log_Clienti ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT NOW();

insert into clienti VALUES (1,'Giuseppe','Verdi','gverdi@aol.com','Roncole Verdi','Busseto','PR','43011');
insert into clienti VALUES (2,'Gioacchino','Rossini','gioacchino@libero.it','Via del Duomo','Pesaro','PU','61122');
insert into clienti VALUES (3,'Giacomo','Puccini','gpuccini@gmail.com','Corte San Lorenzo, 9 ','Lucca','LU','55100');
insert into clienti VALUES (4,'Gaetano','Donizetti','gaetano@walla.com','Via Don Luigi Palazzolo, 88','Bergamo','BG','24122');
insert into clienti VALUES (5,'Vincenzo','Bellini','bellini@bellini.org','Piazza San Francesco d�Assisi, 3','Catania','CT','95100');


SELECT * FROM clienti;


UPDATE clienti SET citta = 'Parma', updated_at = NOW() WHERE id_cliente = 1;

SELECT * FROM clienti
WHERE created_at <> updated_at
;

DELIMITER // -- cambio delimiter a causa di HeidiSQL
CREATE OR REPLACE FUNCTION update_clienti_timestamp()
RETURNS trigger AS $$
DECLARE
	
BEGIN
	raise notice 'update_clienti_timestamp() started';
	
	raise notice 'Trigger attivato su istruzione %', TG_OP;
	raise notice 'Vecchio Timestamp %', OLD.updated_at;
	NEW.updated_at := NOW();
	raise notice 'Nuovo Timestamp %', NEW.updated_at;
	
	raise notice 'update_clienti_timestamp() ended';
	RETURN NEW;
END
$$ LANGUAGE plpgsql;
//

CREATE OR REPLACE TRIGGER trig_clienti_timestamp_update
AFTER UPDATE ON clienti
FOR EACH ROW

EXECUTE FUNCTION update_clienti_timestamp()
;
//

DELIMITER // -- cambio delimiter a causa di HeidiSQL
-- se cambia il flag abilitato devo attivare un trigger
-- che blocchi tutti gli ordini di quel cliente
CREATE OR REPLACE FUNCTION disabilita_riabilita_ordini()
RETURNS trigger AS $$
DECLARE
	
BEGIN
	raise notice 'disabilita_riabilita_ordini() started';
	
	IF OLD.enabled IS DISTINCT from NEW.enabled then
		IF NEW.enabled = true then
			raise notice 'record cliente % abilitato', OLD.id_cliente;
		ELSE 
			raise notice 'record cliente % disabilitato', OLD.id_cliente;
		END IF;
		-- eseguire l'update degli ordini
	END IF;
	
	raise notice 'disabilita_riabilita_ordini() ended';
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
//

CREATE OR REPLACE TRIGGER trig_clienti_enable_disabòe
AFTER UPDATE ON clienti
FOR EACH ROW

EXECUTE FUNCTION disabilita_riabilita_ordini()
;
//
DELIMITER // -- cambio delimiter a causa di HeidiSQL
CREATE OR REPLACE FUNCTION log_history_clienti()
RETURNS TRIGGER AS $$
DECLARE
    v_operazione_tipo TEXT;
    v_record_to_log RECORD; -- Variabile per tenere il record da loggare
BEGIN
	raise notice 'log_history_clienti() started';
	
    -- Determina il tipo di operazione e il record da loggare
    IF TG_OP = 'INSERT' THEN
        v_operazione_tipo := 'INSERT';
        v_record_to_log := NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        v_operazione_tipo := 'UPDATE';
        v_record_to_log := NEW; -- Si logga il nuovo stato
    ELSIF TG_OP = 'DELETE' THEN
        v_operazione_tipo := 'DELETE';
        v_record_to_log := OLD; -- Si logga l'ultimo stato prima della cancellazione
    ELSE
        -- Gestione di un caso non previsto
        RETURN NULL;
    END IF;

    -- 1. Registrazione in Log_Clienti
    INSERT INTO Log_Clienti (Operazione, id_cliente, Nome, Cognome, Email, indirizzo, citta, provincia, cap, enabled, created_at, updated_at)
    VALUES (
        v_operazione_tipo,
        v_record_to_log.id_cliente,
        v_record_to_log.Nome,
        v_record_to_log.Cognome,
        v_record_to_log.Email,
        v_record_to_log.Indirizzo,
        v_record_to_log.Citta,
        v_record_to_log.Provincia,
        v_record_to_log.Cap,
        v_record_to_log.enabled,
        v_record_to_log.created_at,
        v_record_to_log.updated_at
    );

    -- 2. Registrazione in LogSistema (messaggi)
    INSERT INTO LogSistema (Messaggio)
    VALUES (
        'LOG STORICO: Registrata operazione ' || v_operazione_tipo ||
        ' per Cliente ID ' || v_record_to_log.id_cliente || '. Stato Abilitato: ' || v_record_to_log.enabled
    );

    -- 3. Stampa della RAISE NOTICE
    RAISE NOTICE 'AUDIT: Operazione % completata per Cliente ID %.', v_operazione_tipo, v_record_to_log.id_cliente;

    -- I trigger AFTER devono sempre restituire NULL
	raise notice 'log_history_clienti() ended';
   RETURN NULL;
END;
$$ LANGUAGE plpgsql;
//

CREATE or replace TRIGGER trigger_clienti_history
AFTER INSERT OR UPDATE OR DELETE ON Clienti
FOR EACH ROW
EXECUTE FUNCTION log_history_clienti();
//

DELIMITER // -- cambio delimiter a causa di HeidiSQL
CREATE OR REPLACE FUNCTION prova_function_call_02()
RETURNS integer AS $$
DECLARE
BEGIN
	raise notice 'prova_function_call_02() started';
	raise notice 'prova_function_call_02() ended';
   RETURN 100;
END;
$$ LANGUAGE plpgsql;
//


DELIMITER // -- cambio delimiter a causa di HeidiSQL
CREATE OR REPLACE FUNCTION prova_function_call_01()
RETURNS TRIGGER AS $$
DECLARE
	variabile INTEGER;
BEGIN
	raise notice 'prova_function_call_01() started';
	variabile := prova_function_call_02();
	raise notice 'prova_function_call_01() ended';
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;
//



CREATE or replace TRIGGER trigger_prova_data
AFTER INSERT OR UPDATE OR DELETE ON prova_data
FOR EACH ROW
EXECUTE FUNCTION prova_function_call_01();
//