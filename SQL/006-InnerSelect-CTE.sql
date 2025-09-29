
SELECT id, nome, latitudine, longitudine FROM regioni;



SELECT id, nome, latitudine, longitudine 
FROM regioni
WHERE nome LIKE '%Tosc%' or nome like '%Piem%';


SELECT id_regione, id, nome
FROM province
WHERE id_regione IN (
	SELECT id -- risultato intermedio, inner select
	FROM regioni
	WHERE (nome LIKE '%Tosc%' or nome like '%Piem%') AND id < 21
);

--
-- Inner Query
--
SELECT id_regione, id, nome
FROM province
WHERE id_regione IN (
	SELECT id -- risultato intermedio, inner select
	FROM regioni
	WHERE (nome LIKE '%Tosc%' or nome like '%Piem%') AND id < 21 -- versione dinamica di in (1, 9)
)
ORDER BY 1, 3 DESC;

--
-- CTE Commont Table Expression
--
WITH selezione_regioni AS (
	SELECT id, nome -- risultato intermedio, inner select
	FROM regioni
	WHERE (nome LIKE '%Tosc%' or nome like '%Piem%') AND id < 21
)
SELECT id_regione, id, nome
FROM province
WHERE id_regione IN (SELECT id FROM selezione_regioni);


SELECT id, nome
FROM province
WHERE id BETWEEN 47 AND 52 AND id_regione = (
	SELECT id FROM regioni WHERE nome = 'Toscana'
);


SELECT id, nome
FROM comuni
WHERE id_provincia IN (	SELECT id
	FROM province
	WHERE id_regione IN (
		SELECT id 
		FROM regioni
		WHERE (nome LIKE '%Tosc%' or nome like '%Piem%') AND id < 21
	)
);

--
-- CTE Commont Table Expression
--
WITH selezione_regioni AS (
	SELECT id, nome -- risultato intermedio, inner select
	FROM regioni
	WHERE (nome LIKE '%Tosc%' or nome like '%Piem%') AND id < 21
),
selezione_province AS (
	SELECT id
	FROM province
	WHERE id_regione IN (
	SELECT id FROM selezione_regioni
	)
)
SELECT id, nome
FROM comuni
WHERE id_provincia IN (
	SELECT id FROM selezione_province
)
ORDER BY nome desc
;


--
-- usare una table come table "virtuale"
--
SELECT c.id, c.nome AS "Comune", c.capoluogo_provincia AS Capoluogo, c.codice_catastale AS "Catasto" -- proiezione+ridenominazione
FROM comuni C -- ridenominazione vale per lo scope della query (aliasing di tabella)
where c.capoluogo_provincia = 1
;

SELECT id, "Comune", CapoluogO, "Catasto" FROM (
	-- utilizzata come tabella virtuale
	SELECT c.id, c.nome AS "Comune", c.capoluogo_provincia AS Capoluogo, c.codice_catastale AS "Catasto" -- proiezione+ridenominazione
	FROM comuni C -- ridenominazione vale per lo scope della query (aliasing di tabella)
	where c.capoluogo_provincia = 1) abc
WHERE "Catasto" LIKE 'A%'
;


SELECT id, "Comune", Capoluogo_provincia, "Catasto" FROM (
	-- utilizzata come tabella virtuale
	SELECT c.id, c.nome AS "Comune", c.capoluogo_provincia, c.codice_catastale AS "Catasto" -- proiezione+ridenominazione
	FROM comuni C -- ridenominazione vale per lo scope della query (aliasing di tabella)
	where c.capoluogo_provincia = 1) abc
WHERE "Catasto" LIKE 'A%'
;

-- operatore insiemistico "UNION"
SELECT 'Comuni', count(*) FROM Comuni
union
SELECT 'Province', count(*) FROM Province
union
SELECT 'Regioni', count(*) FROM Regioni;

SELECT 
(SELECT count(*) FROM Comuni) AS Comuni,
(SELECT count(*) FROM Province) AS Province,
(SELECT count(*) FROM Regioni) AS regioni;


-- count
SELECT COUNT(id) FROM province;

SELECT COUNT(codice_citta_metropolitana) FROM province;

SELECT id, nome, COALESCE(  /* codice_citta_metropolitana::VARCHAR */ cast(codice_citta_metropolitana AS VARCHAR), ' ') -- converto un numero in una stringa e se null esco con space
FROM province;

SELECT id, nome, COALESCE( codice_citta_metropolitana, 0) -- converto un numero in una stringa e se null esco con space
FROM province;
