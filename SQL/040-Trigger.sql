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



CREATE OR REPLACE FUNCTION update_clienti_timestamp()
RETURNS trigger AS $$
DECLARE
	
BEGIN
	
END
$$ LANGUAGE plpgsql;


