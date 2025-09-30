/*
La funzione calcola un numero casuale di giorni all'interno dell'intervallo specificato e aggiunge tale valore alla data minima,
garantendo che la data risultante sia compresa tra i due estremi.
DATE: per garantire che la funzione lavori esclusivamente con date (senza informazioni sull'ora).
IMMUTABLE: perché la funzione restituisce sempre lo stesso risultato per gli stessi argomenti in un contesto di transazione, rendendola ottimizzata per l'indicizzazione e la cache.

A VOLATILE function can do anything, including modifying the database. 
It can return different results on successive calls with the same arguments. 
The optimizer makes no assumptions about the behavior of such functions. 
A query using a volatile function will re-evaluate the function at every row where its value is needed.

A STABLE function cannot modify the database and is guaranteed to return the same results given the same arguments for all rows within a single statement. 
This category allows the optimizer to optimize multiple calls of the function to a single call. 
In particular, it is safe to use an expression containing such a function in an index scan condition. 
(Since an index scan will evaluate the comparison value only once, not once at each row, it is not valid to use a VOLATILE function in an index scan condition.)

An IMMUTABLE function cannot modify the database and is guaranteed to return the same results given the same arguments forever. 
This category allows the optimizer to pre-evaluate the function when a query calls it with constant arguments. 
For example, a query like SELECT ... WHERE x = 2 + 2 can be simplified on sight to SELECT ... WHERE x = 4, because the function underlying the integer addition operator is marked IMMUTABLE.

*/
CREATE OR REPLACE FUNCTION generate_random_date(
    min_date DATE,
    max_date DATE
)
RETURNS DATE AS $$
DECLARE
    -- Variabile per memorizzare l'intervallo totale di giorni
    date_range INTEGER;
    -- Variabile per memorizzare i giorni casuali da aggiungere
    random_days INTEGER;
BEGIN
    -- 1. Verifica che la data minima non sia maggiore della massima
    IF min_date > max_date THEN
        RAISE EXCEPTION 'La data minima (%) non può essere successiva alla data massima (%)', min_date, max_date;
    END IF;

    -- 2. Calcola il numero totale di giorni nell'intervallo (differenza tra le date)
    date_range := max_date - min_date;

    -- 3. Genera un numero casuale di giorni all'interno di quell'intervallo (da 0 a date_range)
    random_days := FLOOR(RANDOM() * (date_range + 1)); -- +1 per includere max_date

    -- 4. Restituisce la data di inizio più i giorni casuali
    RETURN min_date + random_days;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

--
-- esempi di utilizzo
--
SELECT generate_random_date('2020-01-01'::DATE, CURRENT_DATE);
SELECT generate_random_date('2025-12-31', '2015-05-01' );

SELECT generate_random_date('2015-05-01', '2025-12-31') -- genera 10 date casuali
FROM generate_series(1, 10);

SELECT RANDOM();

/*
Funzione in PL/pgSQL che accetta min_dt e max_dt come TIMESTAMP WITH TIME ZONE (il tipo più robusto per data/ora)
e assegna loro valori predefiniti se omessi:
TIMESTAMP WITH TIME ZONE: Questo tipo di dato è usato per la massima precisione e per gestire correttamente i fusi orari.
EXTRACT(EPOCH FROM ...): Convertire le date in secondi trascorsi dall'epoca (1970-01-01) tramite EXTRACT(EPOCH), manipolare i numeri interi (che è più facile e veloce per RANDOM()), e riconvertire il risultato in un timestamp con TO_TIMESTAMP().
VOLATILE: La funzione è VOLATILE perché NOW() e RANDOM() cambiano ad ogni esecuzione, impedendo a PostgreSQL di ottimizzare le chiamate memorizzando nella cache il risultato.
*/

CREATE OR REPLACE FUNCTION random_date_time(
    min_dt TIMESTAMP WITH TIME ZONE DEFAULT '2000-01-01 00:00:00+00'::TIMESTAMP WITH TIME ZONE,
    max_dt TIMESTAMP WITH TIME ZONE DEFAULT NOW()
)
RETURNS TIMESTAMP WITH TIME ZONE AS $$
DECLARE
    -- Variabili per memorizzare i timestamp in secondi (epoch)
    min_epoch BIGINT;
    max_epoch BIGINT;
    random_epoch BIGINT;
    range_seconds NUMERIC;
BEGIN
    -- 1. Conversione dei timestamp in secondi (epoch time)
    min_epoch := EXTRACT(EPOCH FROM min_dt);
    max_epoch := EXTRACT(EPOCH FROM max_dt);

    -- 2. Gestione degli errori (data minima > data massima)
    IF min_epoch > max_epoch THEN
        RAISE EXCEPTION 'La data/ora minima (%) non può essere successiva alla data/ora massima (%)', min_dt, max_dt;
    END IF;

    -- 3. Calcolo dell'intervallo in secondi
    range_seconds := max_epoch - min_epoch;

    -- 4. Generazione del timestamp casuale (in secondi)
    -- Moltiplica RANDOM() per l'intervallo e aggiunge il risultato al minimo
    random_epoch := min_epoch + FLOOR(RANDOM() * range_seconds);

    -- 5. Conversione del risultato da secondi (epoch) a TIMESTAMP WITH TIME ZONE
    RETURN TO_TIMESTAMP(random_epoch);
END;
$$ LANGUAGE plpgsql VOLATILE;


/*
genera un integer tra due valori upper bound escluso
*/
CREATE OR REPLACE FUNCTION random_int(minvalue integer, maxvalue integer)
RETURNS INTeger AS $$
DECLARE
	randomnumber INTEGER;
BEGIN
	randomnumber := floor(RANDOM() * (maxvalue - MINVALUE /*+ 1*/)) + minvalue;
	RETURN randomnumber;
END
$$ LANGUAGE plpgsql volatile;


SELECT random_int(0, 100)
FROM generate_series(1, 20);
SELECT random_int(0, 100);
--
-- Esempi di utilizzo
--
-- Chiamata	Risultato
SELECT random_date_time();	-- Restituisce un TIMESTAMP casuale tra l'inizio del 2000 e l'ora attuale.
SELECT random_date_time('2023-01-01');	-- Restituisce un TIMESTAMP casuale tra '2023-01-01 00:00:00' e l'ora attuale.
SELECT random_date_time(NULL, '2025-01-01');	-- Restituisce un TIMESTAMP casuale tra l'inizio del 2000 e '2025-01-01 00:00:00'.
SELECT random_date_time('2024-06-01', '2024-06-30');	-- Restituisce un TIMESTAMP casuale entro il giugno 2024.
