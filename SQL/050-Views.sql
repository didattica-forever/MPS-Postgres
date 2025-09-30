-- views
-- una view è una select compilata, pianificata e memorizzata nel Data Dictionary
--
DROP view IF EXISTS italia;

CREATE VIEW italia as
SELECT 
	r.id AS id_regione, 
	r.nome AS Regione, 
	p.id AS id_provincia, 
	p.nome AS provincia, 
	p.sigla_automobilistica AS targa, 
	c.id AS id_comune, 
	c.nome AS comune,
	c.codice_catastale AS catasto
FROM regioni r
INNER JOIN province p
ON p.id_regione = r.id
INNER JOIN comuni c
ON c.id_Provincia = p.id
;


-- uso della viewpg_views
SELECT provincia, comune
FROM italia
WHERE regione IN ('Toscana')
ORDER BY 1, 2;


SELECT definition
FROM pg_views
WHERE schemaname = 'public' AND viewname = 'italia'
;

/* query di creazione view italia prelevata dai metadata
 SELECT r.id AS id_regione,
    r.nome AS regione,
    p.id AS id_provincia,
    p.nome AS provincia,
    p.sigla_automobilistica AS targa,
    c.id AS id_comune,
    c.nome AS comune,
    c.codice_catastale AS catasto
   FROM ((regioni r
     JOIN province p ON ((p.id_regione = r.id)))
     JOIN comuni c ON ((c.id_provincia = p.id)));
*/