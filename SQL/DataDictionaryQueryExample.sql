-- elenca le tabelle negli schema di proprietà dell'utente
SELECT 
    schemaname as schema,
    tablename as tabella,
    tableowner as proprietario
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename;

-- elenca le colonne di una tabella
SELECT 
    column_name as colonna,
    data_type as tipo_dato,
    character_maximum_length as lunghezza_max,
    is_nullable as nullable,
    column_default as valore_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'comuni'
ORDER BY ordinal_position;