-- data formato gg/mm/aaaa

DROP TABLE IF EXISTS prova_data;

CREATE TABLE prova_data (
	d date
	);
	
INSERT INTO prova_data (d) VALUES ('2025/09/20'), ('2024/01/01'), ('2023-05-22');

INSERT INTO prova_data VALUES( TO_DATE('30/07/2025', 'DD-MM-YYYY' ));

INSERT INTO prova_data VALUES( CURRENT_DATE );

SELECT * FROM prova_data;

SELECT NOW();
SELECT CURRENT_DATE;


SELECT date_part('year', d)::varchar FROM prova_data; -- old style

SELECT cast(date_part('year', d) as VARCHAR) FROM prova_data; -- iso style

SELECT cast(date_part('month', d) as VARCHAR) FROM prova_data;

SELECT EXTRACT(year FROM DATE '2025-01-01 AD');

SELECT EXTRACT(MONTH FROM d) FROM prova_data;



-- funzioni string
SELECT
    'Postgre' || 'SQL' AS Concat_Operatore, -- Usa l'operatore standard ||
    CONCAT('Postgre', 'SQL', ' 18') AS Concat_Funzione,
    UPPER('ciao mondo') AS Maiuscolo, -- Converte in maiuscolo
    LOWER('CIAO MONDO') AS Minuscolo, -- Converte in minuscolo
    LENGTH('esempio') AS Lunghezza,  -- Lunghezza della stringa in caratteri
    SUBSTRING('PostgreSQL' FROM 6 FOR 4) AS Sottostringa, -- Estrae 'SQL'
    TRIM(BOTH ' ' FROM '   spazi   ') AS Taglia_Spazi, -- Rimuove gli spazi iniziali e finali
    TRIM(BOTH '*' FROM '**asterischi****') AS Taglia_Asterischi, -- Rimuove gli asterischi iniziali e finali
    REPLACE('SQLServer', 'Server', 'Postgres') AS Sostituisci -- Sostituisce 'Server' con 'Postgres'
   ;
    
    
-- funzioni matematiche
SELECT
    ROUND(12.345, 2) AS Arrotonda_Due_Decimali, -- Arrotonda a 2 decimali (risultato: 12.35)
    FLOOR(12.9) AS Arrotonda_Giù, -- Arrotonda all'intero inferiore (risultato: 12)
    CEIL(12.1) AS Arrotonda_Su, -- Arrotonda all'intero superiore (risultato: 13)
    ABS(-150) AS Valore_Assoluto, -- Valore assoluto (risultato: 150)
    POWER(5, 3) AS Potenza, -- 5 elevato alla 3 (risultato: 125)
    SQRT(144) AS Radice_Quadrata; -- Radice quadrata (risultato: 12)
    ;

