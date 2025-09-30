/*
Creare un nuovo UUID (Universally Unique Identifier) in PostgreSQL è un'operazione comune 
e molto semplice, ma richiede  l'estensione standard uuid-ossp, che fornisce diverse funzioni 
per la creazione di questi identificativi.

https://en.wikipedia.org/wiki/Universally_unique_identifier
*/
 
CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- lavoro da DBA

SELECT uuid_generate_v4();

/*
La funzione generate_series(1,10) restituisce un set di 10 righe, 
che deve avere un nome di tabella e un nome di colonna per essere 
utilizzato nella clausola SELECT ==> t(i) ==> tabella t colonna i.

La sintassi AS t(i) è un modo conciso in PostgreSQL 
(e in altri SQL come Oracle e SQL Server) per assegnare 
un alias a un risultato temporaneo, in particolare a una Tabella Derivata 
come quella creata da una funzione.
 */
SELECT
    i AS Numero,
    uuid_generate_v4() AS NuovoUUID
FROM
    generate_series(1, 5) AS t(i);

drop table if exists ProdottiAziendali;

CREATE TABLE ProdottiAziendali (
    ProdottoID UUID PRIMARY KEY -- La chiave prima
        DEFAULT uuid_generate_v4(), -- Imposta la funzione di generazione casuale (V4) come valore predefinito
    NomeProdotto VARCHAR(100) NOT NULL,
    Prezzo DECIMAL(10, 2)
);


-- Inserimento di due nuovi prodotti, lasciando che il DB generi l'UUID
INSERT INTO ProdottiAziendali (NomeProdotto, Prezzo)
VALUES
('Server Blade X5', 5500.00),
('Licenza Software Pro', 299.99);

-- Visualizzazione dei risultati
SELECT * FROM ProdottiAziendali;
