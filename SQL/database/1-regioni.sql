
DROP TABLE IF EXISTS regioni;

drop table if exists regioni;

CREATE TABLE regioni (
  id int NOT NULL,
  nome varchar(100) NOT NULL,
  latitudine decimal(9,6) NOT NULL,
  longitudine decimal(9,6) NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO regioni VALUES (1,'Piemonte',45.066667,7.700000);
INSERT INTO regioni VALUES (2,'Valle d''Aosta/Vallée d''Aoste',45.737222,7.320556);
INSERT INTO regioni VALUES (3,'Lombardia',45.464161,9.190336);
INSERT INTO regioni VALUES (4,'Trentino-Alto Adige/Südtirol',46.066667,11.116667);
INSERT INTO regioni VALUES (5,'Veneto',45.439722,12.331944);
INSERT INTO regioni VALUES (6,'Friuli-Venezia Giulia',45.636111,13.804167);
INSERT INTO regioni VALUES (7,'Liguria',44.411156,8.932661);
INSERT INTO regioni VALUES (8,'Emilia-Romagna',44.493889,11.342778);
INSERT INTO regioni VALUES (9,'Toscana',43.771389,11.254167);
INSERT INTO regioni VALUES (10,'Umbria',43.112100,12.388800);
INSERT INTO regioni VALUES (11,'Marche',43.616667,13.516667);
INSERT INTO regioni VALUES (12,'Lazio',41.893056,12.482778);
INSERT INTO regioni VALUES (13,'Abruzzo',42.354008,13.391992);
INSERT INTO regioni VALUES (14,'Molise',41.561000,14.668400);
INSERT INTO regioni VALUES (15,'Campania',40.833333,14.250000);
INSERT INTO regioni VALUES (16,'Puglia',41.125278,16.866667);
INSERT INTO regioni VALUES (17,'Basilicata',40.633333,15.800000);
INSERT INTO regioni VALUES (18,'Calabria',38.910000,16.587500);
INSERT INTO regioni VALUES (19,'Sicilia',38.115556,13.361389);
INSERT INTO regioni VALUES (20,'Sardegna',39.216667,9.116667);

select * from regioni;