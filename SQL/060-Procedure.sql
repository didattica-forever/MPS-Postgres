--
-- stored procedure
--
DELIMITER //
CREATE OR REPLACE PROCEDURE DISABILITA_CLIENTE(p_cliente_id INT)
LANGUAGE plpgsql
AS $label$
DECLARE
    v_rows_affected INT;
    v_nome_cliente TEXT;
BEGIN
    -- 1. Tenta di aggiornare il cliente
    UPDATE Clienti
    	SET enabled = FALSE
    WHERE id_cliente = p_cliente_id
    RETURNING Nome INTO v_nome_cliente; -- Recupera il nome del cliente modificato

    -- Recupera il numero di righe modificate
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;

    -- 2. Logica Condizionale
    IF v_rows_affected = 0 THEN
        -- Se nessuna riga è stata modificata (ID non trovato), annulla l'operazione.
        -- Non è necessario un ROLLBACK esplicito qui, ma lo usiamo per dimostrazione.
        RAISE NOTICE 'ERRORE: Cliente ID % non trovato. Nessuna azione eseguita.', p_cliente_id;

    ELSE
        -- Se l'aggiornamento ha avuto successo (e il trigger ha già fatto il suo lavoro)

        -- 3. Inserimento nel LogSistema per tracciare l'esecuzione della SP
        INSERT INTO LogSistema (Messaggio)
        VALUES ('PROCEDURE: Cliente ' || v_nome_cliente || ' (ID ' || p_cliente_id || ') disabilitato tramite SP.');

        -- 4. RAISE NOTICE per feedback immediato
        RAISE NOTICE 'SUCCESSO: Cancellazione logica completata per cliente: %', v_nome_cliente;

        -- 5. Commit Esplicito (OPZIONALE ma dimostrativo della Stored Procedure)
        -- COMMIT;
        -- Nota: Di solito si lascia la gestione del COMMIT/ROLLBACK al chiamante,
        -- ma la possibilità di usarlo è ciò che distingue la PROCEDURE dalla FUNCTION.

    END IF;

END;
$label$;
//


DELIMITER ;

CALL disabilita_cliente(3);
CALL disabilita_cliente(99);

SELECT * FROM LogSistema ORDER BY ID DESC;