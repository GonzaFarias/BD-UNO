/*------------------Inicio script -----------------------------------------
--
Set Schema 'public'; 
Show search_path;
--
-- Drops:
Drop View IF EXISTS Finales_Sist_Aprobados;
Drop View IF EXISTS Alumnos_Con_BD;
Drop View IF EXISTS Promedio_2008_2009;
Drop View IF EXISTS Promedio_ConBD_2008_2009;
Drop View IF EXISTS Alum_BD_con_Aplazo;
Drop View IF EXISTS Alum_BD_sin_Aplazo;
Drop View IF EXISTS Alum_BD;


drop view if exists finales_sist_aprobados;
Drop Table If Exists Finales;
Drop Table If Exists Alumnos;
Drop Table If Exists Materias;
Drop Table If Exists Carreras;
Drop Table If Exists Inscripciones;
Drop Table If Exists Cursos;
Drop Table If Exists Profesores;
--
--
-- CREAR LA TABLA CARRERAS(*ID,NOM)
--   -> id es un char de 4 bytes y > ' '
--   -> NOM es de 40 caracteres como maximo
--
--
Create table carreras 
(id     char(4) primary key,
 nom    varchar(40),
CONSTRAINT CHK_Carreras_id CHECK (id > ' '));
--
-- CREAR LA TABLA MATERIAS(*MAT,NOMBRE)
--   -> mat > 0
--
--
Create table materias 
(mat    integer,
 nombre varchar(20),
CONSTRAINT CHK_Materias_mat CHECK (mat >  0));
--
ALTER TABLE materias ADD CONSTRAINT Pk_Materias PRIMARY KEY(mat);
--
-- 
-- CREAR LA TABLA ALUMNOS(*LEG,NOM,APE,CUOTA,MATR,ID_CARR,LOCALIDAD)
--   -> legajo > 50
--   -> valor default para apellido = 'Desconocido'
--   -> Indicar FKs
--   -> ASIGNAR LAS OPCIONES ON UPDATE + ON DELETE
--      (Cascade, Set Null, Set Default ó No Action)
--
--
Create table alumnos 
(leg    int,
 nom    varchar(20),
 ape    varchar(20) not null default 'Desconocido',
 cuota  decimal(9,2),
 matr   decimal(9,2),
 id_carr char(4),
 localidad varchar(20) );
--
ALTER TABLE Alumnos ADD CONSTRAINT Pk_Alumnos PRIMARY KEY(leg);
ALTER TABLE Alumnos ADD CONSTRAINT CHK_Alumnos_leg CHECK (leg > 50);
--ALTER TABLE Alumnos ADD CONSTRAINT FK_Alumnos_id_carr FOREIGN KEY (id_carr)
--            REFERENCES carreras  ON UPDATE CASCADE ON DELETE Set Null;
--
--
ALTER TABLE Alumnos ADD CONSTRAINT FK_Alumnos_id_carr FOREIGN KEY (id_carr)
            REFERENCES carreras  ON UPDATE set null ON DELETE set default;
--
--
-- CREAR LA TABLA FINALES(*FEC,*MAT(FK),*LEG(FK),NOTA) 
-- CONSIDERAR:
--   -> VALIDAR NOTAS
--   -> VALIDAR FECHA >= A 1-ENE-2000
--   -> Indicar FKs
--   -> ASIGNAR LAS OPCIONES ON UPDATE + ON DELETE
--       
--
--
Create table finales 
(fec    date,
 mat    int,
 leg    int,
 nota   int,
 CONSTRAINT CHK_NOTA  CHECK (nota >=0 AND nota <= 10),
 CONSTRAINT CHK_FECHA CHECK (fec >= '2000-01-01'),
 PRIMARY KEY (fec, mat, leg),
 FOREIGN KEY (mat) REFERENCES materias ON UPDATE CASCADE ON DELETE NO ACTION,
 FOREIGN KEY (leg) REFERENCES alumnos  ON UPDATE CASCADE ON DELETE Set Default);
--
-- ejecutar para poblar las tablas
--
BEGIN TRANSACTION;
INSERT INTO CARRERAS VALUES ('SIST','LICENCIATURA DE SISTEMAS');
INSERT INTO CARRERAS VALUES ('ADMN','LICENCIATURA DE ADMIN. DE EMPRESA');
INSERT INTO CARRERAS VALUES ('BOGA','ABOGACIA');
COMMIT;
--
--
--
BEGIN TRANSACTION;
INSERT INTO ALUMNOS VALUES (69,'Juan','Martinez',500,700,'SIST','Merlo');
INSERT INTO ALUMNOS VALUES (109,'Pedro','Garcia',550,600,'SIST','Moron');
INSERT INTO ALUMNOS VALUES (138,'Pablo','Perez',550,700,'BOGA','Merlo');
INSERT INTO ALUMNOS VALUES (160,'Silvana','Gomez',600,600,'ADMN','Ramos');
INSERT INTO ALUMNOS VALUES (179,'Natalia','Lopez',500,550,'BOGA','Merlo');
INSERT INTO ALUMNOS VALUES (194,'Pamela','Gil',550,700,'BOGA','Moron');
INSERT INTO ALUMNOS VALUES (207,'Juan Pablo','Santos',500,600,'SIST','Ramos');
INSERT INTO ALUMNOS VALUES (210,'Gaston','Sanchez',200,600,'SIST','Ramos');
INSERT INTO ALUMNOS (leg, nom, localidad) VALUES (400,'Pablo','Merlo');
INSERT INTO ALUMNOS (leg, localidad) VALUES (51,'Merlo');
COMMIT;	
--
--
--
BEGIN TRANSACTION;
INSERT INTO MATERIAS VALUES (1000,'??');
INSERT INTO MATERIAS VALUES (1001,'BD I');
INSERT INTO MATERIAS VALUES (1002,'BD II');
INSERT INTO MATERIAS VALUES (1003,'LEGALES');
INSERT INTO MATERIAS VALUES (1004,'PROG I');
INSERT INTO MATERIAS VALUES (1005,'PROG II');
INSERT INTO MATERIAS VALUES (1006,'REDES I');
INSERT INTO MATERIAS VALUES (1007,'REDES II');
INSERT INTO MATERIAS VALUES (1008,'ADMIN EMPRESA');
--
-- 'Materia mal asignada'
---
--INSERT INTO MATERIAS (mat) VALUES (5000);
COMMIT;	
--
BEGIN TRANSACTION;
INSERT INTO FINALES VALUES ('2008/12/10',1000,69,8);
INSERT INTO FINALES VALUES ('2008/12/10',1001,69,8);
INSERT INTO FINALES VALUES ('2008/12/13',1002,69,7);
INSERT INTO FINALES VALUES ('2008/12/15',1003,69,5);
INSERT INTO FINALES VALUES ('2009/03/21',1004,69,6);
INSERT INTO FINALES VALUES ('2008/12/10',1005,69,6);
INSERT INTO FINALES VALUES ('2008/12/10',1006,69,6);
INSERT INTO FINALES VALUES ('2008/12/10',1007,69,9);
INSERT INTO FINALES VALUES ('2008/12/10',1008,69,6);

INSERT INTO FINALES VALUES ('2008/12/10',1000,109,6);
INSERT INTO FINALES VALUES ('2008/12/10',1001,109,6);
INSERT INTO FINALES VALUES ('2008/12/13',1002,109,2);
INSERT INTO FINALES VALUES ('2008/12/15',1003,109,5);
INSERT INTO FINALES VALUES ('2009/03/21',1004,109,6);

INSERT INTO FINALES VALUES ('2008/12/10',1001,138,4);
INSERT INTO FINALES VALUES ('2008/03/22',1002,138,2);
INSERT INTO FINALES VALUES ('2008/06/11',1002,138,2);
INSERT INTO FINALES VALUES ('2008/12/13',1002,138,2);
INSERT INTO FINALES VALUES ('2009/03/21',1002,138,6);
INSERT INTO FINALES VALUES ('2008/12/15',1003,138,4);
INSERT INTO FINALES VALUES ('2009/03/21',1000,138,5);
INSERT INTO FINALES VALUES ('2008/12/15',1004,138,4);
INSERT INTO FINALES VALUES ('2009/2/15',1005,138,4);
INSERT INTO FINALES VALUES ('2009/3/15',1006,138,4);
INSERT INTO FINALES VALUES ('2009/6/15',1007,138,4);
INSERT INTO FINALES VALUES ('2009/7/15',1008,138,4);

INSERT INTO FINALES VALUES ('2008/12/10',1000,160,8);
INSERT INTO FINALES VALUES ('2008/12/13',1008,160,7);
INSERT INTO FINALES VALUES ('2008/12/15',1003,160,10);

INSERT INTO FINALES VALUES ('2008/12/10',1000,179,4);
INSERT INTO FINALES VALUES ('2008/12/10',1006,179,4);
INSERT INTO FINALES VALUES ('2009/03/21',1007,179,2);
INSERT INTO FINALES VALUES ('2008/12/13',1007,179,2);
INSERT INTO FINALES VALUES ('2009/02/11',1003,179,4);

INSERT INTO FINALES VALUES ('2008/12/10',1000,207,3);
INSERT INTO FINALES VALUES ('2008/12/10',1001,207,4);
INSERT INTO FINALES VALUES ('2008/12/13',1002,207,2);
INSERT INTO FINALES VALUES ('2008/03/21',1002,207,6);
INSERT INTO FINALES VALUES ('2009/02/11',1003,207,2);
INSERT INTO FINALES VALUES ('2009/05/11',1003,207,2);
INSERT INTO FINALES VALUES ('2009/03/21',1003,207,6);

INSERT INTO FINALES VALUES ('2008/12/13',1002,51,2);
INSERT INTO FINALES VALUES ('2008/12/13',1003,51,2);
INSERT INTO FINALES VALUES ('2009/03/21',1004,51,7);

INSERT INTO FINALES VALUES ('2008/12/10',1000,210,8);
INSERT INTO FINALES VALUES ('2008/12/10',1001,210,6);
INSERT INTO FINALES VALUES ('2008/12/13',1002,210,2);
INSERT INTO FINALES VALUES ('2008/12/15',1003,210,5);
INSERT INTO FINALES VALUES ('2009/03/21',1004,210,6);
INSERT INTO FINALES VALUES ('2008/12/10',1005,210,3);
COMMIT;	
----------------------------------------------------------------------------
--
-- Tablas adicionales
--
--
-- Crear las tablas Profesores, Cursos e Inscripciones
--
Create table Profesores (prof int, nya varchar(30));
Insert into Profesores Values (   1, 'Juan Garcia');
Insert into Profesores Values (   2, 'Jose Perez');
--
Create table Cursos(mat int, anio int, prof int);
Insert into Cursos Values (1001, 2008, 1);
Insert into Cursos Values (1001, 2009, 3);
Insert into Cursos Values (1002, 2008, 1);
Insert into Cursos Values (1002, 2009, 1);
Insert into Cursos Values (1003, 2008, 2);
Insert into Cursos Values (1003, 2009, 1);
Insert into Cursos Values (1009, 2008, 2);
--
Create table Inscripciones(mat int, anio int, leg int);
Insert into Inscripciones Values (1001, 2008,  69);
Insert into Inscripciones Values (1001, 2008, 109);
Insert into Inscripciones Values (1001, 2008, 138);
Insert into Inscripciones Values (1001, 2009, 160);
Insert into Inscripciones Values (1001, 2009, 179);
Insert into Inscripciones Values (1001, 2009, 400);
Insert into Inscripciones Values (1001, 2009, 111);
Insert into Inscripciones Values (1002, 2008,  69);
Insert into Inscripciones Values (1002, 2008, 160);
Insert into Inscripciones Values (1008, 2008,  69);
Insert into Inscripciones Values (1002, 2009, 138);
--
------------------Fin script ----------------------------------------------*/

--Pruebas de Select
Select * from alumnos where id_carr = 'SIST'; 

Select Fec, Mat, Leg, Nota From FINALES;
Select * From FINALES; -- Es lo mismo que hacer un select de lo puesto arriba

Select Fec as FECHA, Mat MATERIA, Leg From FINALES Where Mat = 1003;

--Between se utiliza para indicar entre ciertos valores
Select Mat, Leg From FINALES Where Mat = 1003 And Fec Between '2008/06/01' AND '2009/03/30';
--Esta seria la forma de hacerlo sin Between
Select Mat, Leg From FINALES Where Mat = 1003 And Fec >= '2008/06/01' AND Fec <= '2009/03/30';

--Se utiliza para eliminar las filas iguales
Select DISTINCT Mat, Leg From FINALES Where Mat = 1003 And Fec Between '2008/06/01' AND '2009/03/30';

--El like se utiliza para mostrar los valores que finalizan con el indicado
Select Leg, Nom, Ape From Alumnos Where Nom Like '%Juan';
Select * From Alumnos Where Nom Like '%Juan';


--El Ilike muestra los valores que sean iguales al indicado, transformando la primer y ultima letra en mayus
Select Leg, Nom, Ape From Alumnos Where Nom iLike '%Juan%';


--Current_Date muestra el dia de hoy, date_part transforma a int
Select date_part('year',Fec) Anio,date_part('month',Fec) Mes, date_part('day',Fec) Dia,
Fec, Current_Date, Current_Time, Current_timestamp, Mat, Leg From FINALES Where date_part('year',Fec) between 2008 and 2009;


 /*select distinct f1.leg, aa.*
from finales f1, finales f2, alumnos aa
where f1.leg = f2.leg and f1.nota >=4 and f2.nota >=4 and f1.mat <> f2.mat and f1.leg = aa.leg */

Select * from alumnos where leg in (select * from finales f1, finales f2 where f1.leg = f2.leg
and f1.mat > f2.mat and f1.nota >= 4 and f2.nota >= 4 and f1.mat 
in (select m.mat from materias m where m.nombre ilike 'bd%')) order by leg;

/*select f.*, m.*, a.* from finales f, materias m, alumnos a
where f.mat = m.mat
and f.leg = a.leg
and fec between '2009/02/01' and '2009/03/31'
order by f.leg;
*/

/*Select f.*, m.* from finales f inner join materias m on f.mat = m.mat /*Otro tipo de notacion*/
where fec between '2009/02/01' and '2009/03/31'
order by f.leg; */


--forma estandar de inner join 
Select f.*, nombre, a.nom, ape, c.nom from finales f inner join materias m on f.mat = m.mat
inner join alumnos a on f.leg = a.leg
inner join carreras c on c.id = a.id_carr
where fec between '2009/02/01' and '2009/03/31' and c.nom ilike '%SISTEMAS%'
order by f.leg; 


Select * from cursos c inner join inscripciones i on c.mat = i.mat and c.anio = i.anio
order by c.mat, c.anio


/*El leftjoin es lo del innerjoin sumado los datos de la primer tabla*/
Select * from cursos c left join inscripciones i on c.mat = i.mat and c.anio = i.anio
order by c.mat, c.anio

/*El rigthjoin son todos los datos del inner join sumado los datos que quedan de la tabla derecha*/
Select * from cursos c right join inscripciones i on c.mat = i.mat and c.anio = i.anio
order by c.mat, c.anio

/*El fulljoin son todos los datos*/
Select * from cursos c full join inscripciones i on c.mat = i.mat and c.anio = i.anio
order by c.mat, c.anio

/*Set datestyle = iso; setea el estilo de dato fecha en dia-mes-año*/


/*Alumnos que no aplazaron ningun final*/
Select * from alumnos a
where leg NOT IN (select leg from finales where nota < 4)
order by leg;
/*Otra forma con not in, */
Select * from alumnos a
where leg NOT IN (select leg from finales f where f.leg = a.leg and nota < 4)
order by leg;


/*Alumnos que aprobaron finales*/
Select * from alumnos a, finales f
where a.leg = f.leg and nota >= 4


/*Not exist mismo resultado que not in, en desventaja debe estar siempre correlacionado*/
Select * from alumnos a
where not exists (Select leg from finales f
where f.leg = a.leg and nota < 4)

Select * from alumnos a
where not exists
(Select * from finales f where f.leg = a.leg and nota < 4);


 /*El count es la cantidad de filas y avg el promedio*/
Select count(*), avg(nota) Promedio, min(nota) Menor_Nota, max(nota), sum (nota) from finales
where mat = 1003 and date_part('year', fec) = 2008;


/*Agrupacion por materia y fecha*/
Select mat, fec, count(*), avg(nota) Promedio, min(nota) Menor_Nota, max(nota), sum (nota) from finales
where date_part('year', fec) = 2008
group by mat, fec;


Select count(*), avg(nota) Promedio, min(nota) Menor_Nota, max(nota), sum (nota) from finales
where date_part('year', fec) = 2008;

/*Cantidad de materias que tuvieron finales en el año 2008*/
Select count(distinct mat) from finales where date_part('year', fec) = 2008


/*Agrupa por materias y ordena por promedio de nota*/
Select mat, count(*), avg(nota), min(nota), max(nota), sum(nota) from finales
where date_part('year', fec) = 2008
group by mat
order by avg(nota);

/*HAVING funciona sobre la tabla resultante, en este se pueden usar funciones de agrupacion, en el WHERE no.
No se pueden usar funciones de fecha*/
Select mat, count(*), avg(nota), min(nota), max(nota), sum(nota) from finales
where date_part('year', fec) = 2008
group by mat
having count(*) > 3
order by avg(nota);

/*Ejemplo más complejo*/
Select mat, count(*), avg(nota), min(nota), max(nota), sum(nota) from finales
where date_part('year', fec) = 2008
group by mat
having count(*) > 3 and avg(nota) >=4
order by 3 asc, 1 desc;

/**/
Select date_part('year', fec) as anio, f.mat, m.nombre
from finales f, materias m
where f.mat = m.mat
group by f.mat, anio, m.nombre
having count(*) > 3 and avg(nota) >=4
order by 3 asc, anio desc;


/*Devuelve los finales con notas superiores o iguales al promedio*/
select * from finales f, materias m
where f.mat = m.mat
and nota > (select avg(nota) from finales ff where ff.leg = f.leg and date_part('year', ff.fec) = 2008)

Select mat, count(*), avg(nota), min(nota), max(nota), sum(nota) from finales
where date_part('year', fec) = 2008
group by mat
having count(*) > 3 and avg(nota) >=4
order by 3 asc, 1 desc;

--Listar los datos de los alumnos y su carrera. Seleccionar solo aquellos que pagan la matricula más cara.
--Y los alumnos que pagan la cuota más alta.

Select * from alumnos a, carreras c where a.id_carr = c.id
and (cuota = (select max(cuota) from alumnos)
or matr = (select max(matr) from alumnos));

--Lista leg, nom, apellido y carrera de los datos de los alumnos de sistema y su nota promedio del año 2008/2009

Select a.leg, a.nom, a.ape, c.nom, (Select avg(nota) from finales f
where f.leg = a.leg and date_part('year', fec) = 2008) prom_2008,
(Select avg(nota) from finales f
where f.leg = a.leg and date_part('year', fec) = 2009) prom_2009
from alumnos a, carreras c where a.id_carr = c.id and c.nom ilike '%SISTEMAS%';

--Lista los alumnos que aprobaron todas las materias de %SISTEMAS%

Select * from alumnos a, carreras c where a.id_Carr = c.id and c.nom ilike '%SISTEMAS%'
and leg NOT IN (select leg from finales where nota < 4)


select * from alumnos a where id_carr in (select id from carreras where nom ilike '%SISTEMAS%')
and not exists (select mat from materias m where not exists (select leg, mat from finales f
where f.leg = a.leg
and f.mat = m.mat
and nota >= 4));

select * from alumnos a where id_carr in (select id from carreras where nom ilike '%SISTEMAS')
and (select count(*) from materias) = (select count(*) from finales f where nota >= 4
and a.leg = f.leg);

select * from alumnos a where id_carr in (select id from carreras where nom ilike '%SISTEMAS')
and (select count(*) from materias) = (select count(*) from finales f where nota >= 4
and a.leg = f.leg);

--Tipejos que aprobaron BD
select * from alumnos a where id_carr in (select id from carreras where nom ilike '%SISTEMAS')
and (select count(*) from materias where nombre ilike '%BD%') =
(select count(*) from finales f where nota >= 4 and a.leg = f.leg
and f.mat in (select mat from materias where nombre ilike '%BD%'));


------------------------VIEW-----------------------------
--Finales aprobados de los alum de la carrera de sistemas

Create view finales_sist_aprobados as select * from finales f
where nota >=4 and exists (select 1 from alumnos a, carreras c
where a.id_carr = c.id and a.leg = f.leg
and c.nom ilike '%SISTEMAS%');
select * from finales_sist_aprobados


Create view promedios_anio(anio,promedio,maximo) as select date_part('year', fec),avg(nota), max(nota) from finales group by date_part('year', fec);

select mat, max(nota), avg(nota) from finales_sist_aprobados group by mat


------------------------------- SCRIPT CLIENTES Y FABRICAS -------------------------------
/*
CREATE TABLE CLIENTES
(NRO_CLIENTE INTEGER,
NOMBRE VARCHAR(20),
SALDO DECIMAL(9,2),
LOCALIDAD VARCHAR(20));
ALTER TABLE Clientes ADD CONSTRAINT Pk_Clientes PRIMARY KEY(NRO_CLIENTE);

INSERT INTO CLIENTES VALUES (10, 'juan', 20, null);
INSERT INTO CLIENTES VALUES(20, 'pablo', 40, null);
INSERT INTO CLIENTES VALUES(30, 'ana', null, 'Mar del Plata');

CREATE TABLE FABRICAS
(NRO_FABRICA INTEGER,
NOMBRE VARCHAR(20),
LOCALIDAD VARCHAR(20));
ALTER TABLE Fabricas ADD CONSTRAINT Pk_Fabricas PRIMARY KEY(NRO_FABRICA);

INSERT INTO FABRICAS VALUES (1, 'x','Mar del Plata');
INSERT INTO FABRICAS VALUES (2, 'j',null);
*/
SELECT count(saldo),max(saldo),min(saldo),avg(saldo)promedio;

SELECT saldo from CLIENTES order by saldo desc;

select * from clientes where saldo = 40;

select * from clientes where localidad ILIKE '%mar del plata%';

--Une a ana con otros de mar del plata pero al ser nulls solo aparece ella
select * from clientes where localidad ILIKE 'mar del plata' UNION select * from clientes
where localidad NOT ILIKE 'mar del plata' ;

--
select * from clientes where saldo not in (10,20) ;
select * from clientes where saldo in (10,20) ;


select * from clientes c where not exists (select * from fabricas f where c.localidad = f.localidad) ;
select * from clientes c where localidad not in (select localidad from fabricas f ) ;



select * from clientes c where localidad not in (null ,'Mar del Plata' ) ;



