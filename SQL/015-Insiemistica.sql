-- Tabella 1: Impiegati_A
drop table if exists Impiegati_A;
drop table if exists Impiegati_B;

CREATE TABLE Impiegati_A (
    ID INT PRIMARY KEY,
    Nome VARCHAR(50),
    Reparto VARCHAR(50)
);

INSERT INTO Impiegati_A (ID, Nome, Reparto) VALUES
(101, 'Mario Rossi', 'Vendite'),
(102, 'Luca Bianchi', 'IT'),
(103, 'Anna Verdi', 'HR');

-- Tabella 2: Impiegati_B
CREATE TABLE Impiegati_B (
    ID INT PRIMARY KEY,
    Nome VARCHAR(50),
    Reparto VARCHAR(50)
);

INSERT INTO Impiegati_B (ID, Nome, Reparto) VALUES
(102, 'Luca Bianchi', 'IT'), -- Presente in entrambe
(104, 'Giorgia Neri', 'Marketing'),
(105, 'Paolo Gialli', 'Vendite');

-- unisce 2 select senza sopprimere i doppi
SELECT 'A',Nome, Reparto FROM Impiegati_A
UNION ALL -- unione senza soppressione dei doppi
SELECT 'B',Nome, Reparto FROM Impiegati_B
ORDER BY Nome;

-- unisce 2 select con soppressione i doppi
SELECT Nome AS "xxx", Reparto FROM Impiegati_A
UNION -- con soppressione dei doppi
SELECT Nome AS "yyy", Reparto FROM Impiegati_B
ORDER BY 1;

-- estrae solo le righe che appartengono ad entrambe le select
SELECT ID, Nome, Reparto FROM Impiegati_A
INTERSECT
SELECT ID, Nome, Reparto FROM Impiegati_B
ORDER BY Nome;

-- nella EXCEPT l'ordine di specifica delle select è importante
-- estrae solo le righe di A che non appartengono a B
SELECT ID, Nome, Reparto FROM Impiegati_A
EXCEPT -- MINUS in Oracle
SELECT ID, Nome, Reparto FROM Impiegati_B
ORDER BY Nome;

-- estrae solo le righe di B che non appartengono a A
SELECT ID, Nome, Reparto FROM Impiegati_B
EXCEPT
SELECT ID, Nome, Reparto FROM Impiegati_A
ORDER BY Nome;


---
-- Prodotto cartesiano
-- tra due tabelle combina tutte le righe di u na tabella con le righe dell'altra
---
DROP table IF EXISTS TA;
DROP table IF EXISTS TB;

CREATE TABLE TA(x CHAR(1));
INSERT INTO TA (x) VALUES ('A'),('B'),('C'),('D');

CREATE TABLE TB(x CHAR(1));
INSERT INTO TB (x) VALUES ('1'),('2'),('3'),('4');

SELECT * FROM TA;
SELECT * FROM TB;

SELECT a.x AS "a", b.x AS "b"
FROM TA a, Tb b;

SELECT a.x AS "a", b.x AS "b"
FROM TA a, TA b;

-- Theta join start
SELECT a.x AS "a", b.x AS "b"
FROM TA a, TA b
WHERE a.x = b.x; -- theta clause

SELECT a.x AS "a", b.x AS "b"
FROM TA a, TA b
WHERE a.x <> b.x;
-- Theta join end


SELECT a.x AS "a", b.x AS "b"
FROM TA a
cross join TA b;


drop table if exists Squadre;
CREATE TABLE Squadre (
    ID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NomeSquadra VARCHAR(50)
);

INSERT INTO Squadre (NomeSquadra) values
('Siena'),
('Juventus'),
('Milan'),
('Inter'),
('Napoli');

-- tutti contro tutti
-- 5*5=25 rows
SELECT
    A.NomeSquadra AS SquadraCasa,
    B.NomeSquadra AS SquadraOspite
FROM
    Squadre AS A, Squadre AS B
ORDER BY
    A.ID, B.ID;

-- ognuno non può giocare contro se stesso
-- 5*4=20 rows ovvero 5*5 - 5 = 20
SELECT
    A.NomeSquadra AS SquadraCasa,
    B.NomeSquadra AS SquadraOspite
FROM
    Squadre AS A, Squadre AS B
WHERE
    A.ID <> B.ID -- 1. Esclude le partite contro se stessi (A.ID <> B.ID)
ORDER BY
    A.ID, B.ID;

-- girone di andata
-- A.ID < B.ID
-- 5*4/2=10 rows
SELECT
    A.NomeSquadra AS SquadraCasa,
    B.NomeSquadra AS SquadraOspite
FROM
    Squadre AS A, Squadre AS B
WHERE
    A.ID < B.ID -- 1. Esclude le partite contro se stessi (A.ID <> B.ID)
                -- 2. Esclude anche i duplicati (A.ID < B.ID garantisce solo l'andata)
ORDER BY
    A.ID, B.ID;


-- girone di ritorno
-- A.ID > B.ID
-- 5*4/2=10 rows
SELECT
    A.NomeSquadra AS SquadraCasa,
    B.NomeSquadra AS SquadraOspite
FROM
    Squadre AS A, Squadre AS B
WHERE
    A.ID > B.ID -- 1. Esclude le partite contro se stessi (A.ID <> B.ID)
                -- 2. Esclude anche i duplicati (A.ID > B.ID garantisce solo il ritorno)
ORDER BY
    A.ID, B.ID;

-- calendario completo 
-- 5*4=20 rows
select
	CASE WHEN A.ID < B.ID THEN 'ANDATA' ELSE 'RITORNO' end as Girone, -- IIF(A.ID <> B.ID, 'ANDATA', 'RITORNO') as "Girone",
    A.NomeSquadra AS SquadraCasa,
    B.NomeSquadra AS SquadraOspite
FROM
    Squadre AS A, Squadre AS B
WHERE
    A.ID <> B.ID -- Esclude solo (A vs A), mantiene (A vs B) e (B vs A)
ORDER BY
    1, A.NomeSquadra, B.NomeSquadra;

-- calendario completo realizzato tramite una cross join
-- 5*4=20 rows
SELECT
    case -- Assegna 'ANDATA' quando A.ID è minore di B.ID
        WHEN A.ID < B.ID THEN 'ANDATA'
        ELSE 'RITORNO'
    END AS Girone,
    A.NomeSquadra AS SquadraCasa,
    B.NomeSquadra AS SquadraOspite
FROM
    Squadre AS A
CROSS JOIN -- Sintassi corretta per il Prodotto Cartesiano
    Squadre AS B
WHERE
    A.ID <> B.ID -- Filtro: escludi le partite contro se stessi (es. Juventus vs Juventus)
ORDER BY 1;


-- calendario completo realizzato tramite una cross join
-- 5*4=20 rows
SELECT
    case -- Assegna 'ANDATA' quando A.ID è minore di B.ID
        WHEN A.ID < B.ID THEN 'ANDATA'
        ELSE 'RITORNO'
    END AS Girone,
    uuid_generate_v4(),
    A.NomeSquadra AS SquadraCasa,
    B.NomeSquadra AS SquadraOspite
FROM
    Squadre AS A
CROSS JOIN -- Sintassi corretta per il Prodotto Cartesiano
    Squadre AS B
WHERE
    A.ID <> B.ID -- Filtro: escludi le partite contro se stessi (es. Juventus vs Juventus)
ORDER BY 1, 2, A.NomeSquadra, B.NomeSquadra;

-- calendario completo realizzato tramite una cross join
-- 5*4=20 rows
SELECT
    case -- Assegna 'ANDATA' quando A.ID è minore di B.ID
        WHEN A.ID < B.ID THEN 'ANDATA'
        ELSE 'RITORNO'
    END AS Girone,
    A.NomeSquadra AS SquadraCasa,
    B.NomeSquadra AS SquadraOspite
FROM
    Squadre AS A
CROSS JOIN -- Sintassi corretta per il Prodotto Cartesiano
    Squadre AS B
WHERE
    A.ID <> B.ID -- Filtro: escludi le partite contro se stessi (es. Juventus vs Juventus)
ORDER BY 1, uuid_generate_v4(), A.NomeSquadra, B.NomeSquadra;

