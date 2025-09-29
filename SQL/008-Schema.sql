-- schema

SELECT id, nome
FROM regioni;

SELECT regioni.id, regioni.nome
FROM regioni;


SELECT regioni.id, regioni.nome
FROM public.regioni;


CREATE SCHEMA prova;

DROP table IF EXISTS prova.clienti;

CREATE TABLE prova.clienti ( -- vecchio modo
    id SERIAL PRIMARY KEY,
    nome VARCHAR (100)
);

INSERT INTO prova.clienti (nome) VALUES ('Amerigo'), ('Attilio'), ('Oreste');
INSERT INTO prova.clienti values (100, 'Ugo');
INSERT INTO prova.clienti (nome) VALUES ('Luisa'), ('Caterina'), ('Angela'), ('Margherita');

SELECT * FROM prova.clienti;
SELECT * FROM public.clienti;

SELECT * FROM prova.clienti
UNION -- sopprime le righe doppie
SELECT * FROM PUBLIC.clienti;

SELECT * FROM prova.clienti
UNION ALL -- non sopprime le righe doppie
SELECT * FROM PUBLIC.clienti
ORDER BY 1;


SELECT 
(SELECT COUNT(*) FROM PUBLIC.clienti) AS "Public CLienti Count",
(SELECT COUNT(*) FROM Prova.clienti) AS "Prova CLienti Count",
(SELECT COUNT(*) FROM PUBLIC.clienti) * (SELECT COUNT(*) FROM Prova.clienti) AS "Prodotto Cartesiano Count";

-- prodotto cartesiano tra le tabelle dei 2 schema
SELECT *
FROM PUBLIC.clienti, prova.clienti
;

SELECT a.id, a.nome, b.id, b.nome
FROM PUBLIC.clienti a, prova.clienti b
;

-- vecchio esempio di JOIN (THETA JOIN - EQUI)
SELECT a.id, a.nome, b.id, b.nome
FROM PUBLIC.clienti a, prova.clienti b
WHERE a.id = b.id
;

-- vecchio esempio di JOIN (THETA JOIN - NON EQUI)
SELECT a.id, a.nome, b.id, b.nome
FROM PUBLIC.clienti a, prova.clienti b
WHERE a.id != b.id
;

-- join moderna
SELECT a.id, a.nome, b.id, b.nome
FROM PUBLIC.clienti a -- tabella di sinistra
inner join prova.clienti  b -- tabella di destra
on a.id = b.id -- criterio di abbinamento












