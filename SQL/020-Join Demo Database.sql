drop table if exists clienti;

create table clienti ( 
		id_cliente int primary key,
		nome varchar(50),
		cognome varchar(50),
		email varchar(50),
		indirizzo varchar(100),
		citta varchar(50),
		provincia varchar(4),
		cap char(5) );
	
insert into clienti VALUES (1,'Giuseppe','Verdi','gverdi@aol.com','Roncole Verdi','Busseto','PR','43011');
insert into clienti VALUES (2,'Gioacchino','Rossini','gioacchino@libero.it','Via del Duomo','Pesaro','PU','61122');
insert into clienti VALUES (3,'Giacomo','Puccini','gpuccini@gmail.com','Corte San Lorenzo, 9 ','Lucca','LU','55100');
insert into clienti VALUES (4,'Gaetano','Donizetti','gaetano@walla.com','Via Don Luigi Palazzolo, 88','Bergamo','BG','24122');
insert into clienti VALUES (5,'Vincenzo','Bellini','bellini@bellini.org','Piazza San Francesco d�Assisi, 3','Catania','CT','95100');
		
drop table if exists ordini;
create table ordini (
	id_ordine int primary key, 
	data date,
	valore decimal(10,2),
	id_cliente int);

insert into ordini values (1, to_date('10/10/2018', 'DD/MM/YYYY') ,345.67,   1);
insert into ordini values (2, to_date('31/12/2017', 'DD/MM/YYYY') ,176.00,   3);
insert into ordini values (3, to_date('01/01/2019', 'DD/MM/YYYY') ,33.88,    2);
insert into ordini values (4, to_date('24/11/2018', 'DD/MM/YYYY') ,4589.00,  3);
insert into ordini values (5, to_date('13/07/2018', 'DD/MM/YYYY') ,230.00,  10);
insert into ordini values (6, to_date('01/06/2018', 'DD/MM/YYYY') ,144.00,   9);

-- tabella clienti
SELECT * FROM clienti;

-- tabella ordini
SELECT * FROM ordini;


-- abbinamento INNER THETA JOIN tra clenti ordini
SELECT * 
from clienti c, ordini o
WHERE c.id_cliente = o.id_cliente; -- theta clause è FILTRO IN USCITA AL PRODOTTO CARTESIANO

SELECT * 
from clienti C
cross join ordini o
WHERE c.id_cliente = o.id_cliente; -- theta clause è FILTRO IN USCITA AL PRODOTTO CARTESIANO



-- 
-- Inner Join DEMO
--

SELECT * 
from clienti a 
inner join ordini b 
on a.id_cliente = b.id_cliente -- on è la clausola di match della join
;

SELECT * 
from clienti a 
inner join ordini b 
on a.id_cliente = b.id_cliente -- on è la clausola di match della join
WHERE a.provincia = 'LU'
;

SELECT * 
from clienti a 
inner join ordini b 
on a.id_cliente = b.id_cliente and a.provincia = 'LU' -- il filtro viene incorporato nella clausola on
;

SELECT * 
from clienti a 
inner join ordini b 
on a.id_cliente = b.id_cliente and a.provincia != 'LU' -- il filtro viene incorporato nella clausola on
;

--
-- Left Join
--
SELECT *
from clienti a 
left join ordini b
on a.id_cliente = b.id_cliente;

-- Left with exclusion
SELECT *
from clienti a 
left join ordini b
on a.id_cliente = b.id_cliente
WHERE id_ordine IS NULL;

-- inner by Left join
SELECT *
from clienti a 
left join ordini b
on a.id_cliente = b.id_cliente
WHERE id_ordine IS NOT NULL;


--
-- Right join
--
SELECT *
from clienti a 
right join ordini b
on a.id_cliente = b.id_cliente;

-- Right with exclusion
SELECT *
from clienti a 
right join ordini b
on a.id_cliente = b.id_cliente
WHERE a.id_cliente IS NULL;

-- Inner by Right join
SELECT *
from clienti a 
right join ordini b
on a.id_cliente = b.id_cliente
WHERE a.id_cliente IS not NULL;

-- Right by Left join
SELECT * 
from ordini b  
left join clienti a 
on a.id_cliente = b.id_cliente;


--
-- Full Join
--
SELECT *
from clienti a 
full join ordini b
on a.id_cliente = b.id_cliente;

-- elaborazione su null
SELECT *
from clienti a 
full join ordini b
on a.id_cliente = b.id_cliente
WHERE a.id_cliente IS NULL OR b.id_ordine IS null;

-- Full by Left & Right union
SELECT *
from clienti a 
left join ordini b
on a.id_cliente = b.id_cliente
UNION
SELECT *
from clienti a 
right join ordini b
on a.id_cliente = b.id_cliente;

-- Full by Left & Left invertita union
-- select * viola le regole della union
SELECT a.id_cliente, a.nome, b.id_ordine, b.valore
from clienti a 
left join ordini b
on a.id_cliente = b.id_cliente
UNION
SELECT a.id_cliente, a.nome, b.id_ordine, b.valore
from ordini b 
left join clienti a
on a.id_cliente = b.id_cliente;





