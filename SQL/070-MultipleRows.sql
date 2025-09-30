-- funzioni multiple row

DROP TABLE IF EXISTS vendite;

CREATE TABLE Vendite (
    ID SERIAL PRIMARY KEY,
    DataVendita DATE NOT NULL,
    DipendenteID INT NOT NULL,
    Prodotto VARCHAR(50) NOT NULL,
    Dipartimento VARCHAR(50) NOT NULL,
    Quantita INT NOT NULL,
    PrezzoUnitario DECIMAL(10, 2) NOT NULL,
    CostoTotale DECIMAL(10, 2) GENERATED ALWAYS AS (Quantita * PrezzoUnitario)
);

INSERT INTO Vendite (DataVendita, DipendenteID, Prodotto, Dipartimento, Quantita, PrezzoUnitario)
SELECT 
	generate_random_date(to_date('2023/01/01', 'YYYY-MM-DD'), CURRENT_DATE) AS DataVendita,
	random_int(0, 1000) DipendenteID, -- id dipendente
	-- Prodotto: Scelta casuale tra 5 prodotti
    CASE ( random_int(0, 5)::int )
        WHEN 0 THEN 'Laptop'
        WHEN 1 THEN 'Smartphone'
        WHEN 2 THEN 'Tablet'
        WHEN 3 THEN 'Accessorio'
        ELSE 'Monitor'
    END AS Prodotto,
    -- Dipartimento: Scelta casuale tra 3 dipartimenti
    CASE ( random_int(0, 5)::INT )
        WHEN 0 THEN 'Elettronica'
        WHEN 1 THEN 'Software'
        ELSE 'Servizi'
    END AS Dipartimento,
    random_int(5, 20) AS Quantita, -- quantità
    random_int(50, 1500)::DECIMAL(10, 2) AS PrezzoUnitario
FROM 
	GENERATE_SERIES(1, 5000)
;

SELECT COUNT(*) FROM vendite;


-- funzioni di aggregazione

-- quante vendite per dipendente ordinate per numero desc
SELECT
DipendenteID, SUM(CostoTotale)
FROM vendite
GROUP BY DipendenteID
ORDER BY 2 DESC;


-- quante vendite >= 120000 per dipendente ordinate per numero desc
SELECT
DipendenteID, SUM(CostoTotale)
FROM vendite
GROUP BY DipendenteID
HAVING SUM(CostoTotale) >= 120000
ORDER BY 2 DESC;

-- quante vendite per dipendente ordinate per numero desc
SELECT
Dipartimento, Prodotto, SUM(CostoTotale)
FROM vendite
GROUP BY Dipartimento, Prodotto
ORDER BY 3 DESC;


-- quante vendite per dipendente ordinate per numero desc
SELECT
Dipartimento, Prodotto, CAST (DATE_PART('year', DataVendita) as VARCHAR), SUM(CostoTotale)
FROM vendite
GROUP BY Dipartimento, Prodotto, DATE_PART('year', DataVendita)
ORDER BY 3 DESC;

