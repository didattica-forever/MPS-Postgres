drop table if exists MotherChild;
drop table if exists FatherChild;
drop table if exists Person;


create table MotherChild (mother varchar(20) , child varchar(20) );
insert into MotherChild values('Lisa', 'Mary');
insert into MotherChild values('Lisa', 'Greg');
insert into MotherChild values('Anne', 'Kim');
insert into MotherChild values('Anne', 'Phil');
insert into MotherChild values('Mary', 'Andy');
insert into MotherChild values('Mary', 'Rob');


create table FatherChild ( father varchar(20), child varchar(20) );
insert into FatherChild values('Steve', 'Frank');
insert into FatherChild values('Greg', 'Kim');
insert into FatherChild values('Greg', 'Phil');
insert into FatherChild values('Frank', 'Andy');
insert into FatherChild values('Frank', 'Rob');


create table Person (name varchar(20) , age int , income int );
insert into Person values('Andy', 27, 21000);
insert into Person values('Rob', 25, 15000);
insert into Person values('Mary', 55, 42000);
insert into Person values('Anne', 50, 35000);
insert into Person values('Phil', 26, 30000);
insert into Person values('Greg', 50, 40000);
insert into Person values('Frank', 60, 20000);
insert into Person values('Kim', 30, 41000);
insert into Person values('Mike', 85, 35000);
insert into Person values('Lisa', 75, 87000);



