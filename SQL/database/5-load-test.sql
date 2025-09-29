select 'Regioni:', count(*) from regioni as totali
union
select 'Province:', count(*) from province
union
select 'Comuni:', count(*) from comuni
;
