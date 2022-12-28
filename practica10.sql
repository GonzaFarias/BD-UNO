------------------Inicio script -----------------------------------------
--
--  set datestyle = postgres  (dd-mm-yyyy)
--  set datestyle = iso       (yyyy-mm-dd). El insert acepta dd-mm-yyyy
-------------------------------------------------------------------------
--
--
DROP TABLE IF EXISTS DETALLES;
DROP TABLE IF EXISTS FACTURAS;
DROP TABLE IF EXISTS ARTICULOS;
DROP TABLE IF EXISTS RUBROS;
DROP TABLE IF EXISTS CLIENTES;
--
CREATE TABLE CLIENTES
(NROCLI     INTEGER     NOT NULL,
 NYAPE      VARCHAR(20) NOT NULL,
 DOMICILIO  VARCHAR(30),
 LOCALIDAD  VARCHAR(20),
 SALDOCLI   DECIMAL(9,2) DEFAULT 0);
ALTER TABLE Clientes ADD CONSTRAINT Pk_Clientes PRIMARY KEY(nrocli);

CREATE TABLE RUBROS
(COD_RUBRO        INTEGER,
 DESCRIPCION      VARCHAR(30),
 CONSTRAINT PK_RUBROS PRIMARY KEY (COD_RUBRO) );

CREATE TABLE ARTICULOS
(NROARTIC         INTEGER NOT NULL,
 DESCRIPCION      VARCHAR(30) NOT NULL,
 RUBRO            INTEGER,
 STOCK            INTEGER NOT NULL DEFAULT 0 ,
 PTO_REPOSICION   INTEGER NOT NULL DEFAULT 0 ,
 PRECIO           DECIMAL(8,2) DEFAULT 0 ,
 CONSTRAINT PK_ARTICULOS PRIMARY KEY (NROARTIC),
 CONSTRAINT FK_ARTICULOS_RUBROS FOREIGN KEY (RUBRO) REFERENCES RUBROS(COD_RUBRO) ON DELETE NO ACTION);

CREATE TABLE FACTURAS
(NROFACTURA  INTEGER NOT NULL,
 CLIENTE     INTEGER NOT NULL,
 FECHA       TIMESTAMP NOT NULL DEFAULT NOW(),
 CONSTRAINT PK_FACTURAS PRIMARY KEY (NROFACTURA),
 CONSTRAINT FK_FACTURAS_CLIENTES FOREIGN KEY (CLIENTE) REFERENCES CLIENTES(NROCLI)
 ON DELETE NO ACTION
 ON UPDATE CASCADE);

--
-- PRECIOUNI SIN "NOT NULL" Y SIN DEFAULT... SINO PROBLEMAS EN UPDATE
--
CREATE TABLE DETALLES
(NROFACTURA  INTEGER NOT NULL CHECK(NROFACTURA > 0),
 RENGLON     CHAR(3) NOT NULL,
 ARTICULO    INTEGER NOT NULL,
 CANTIDAD    INTEGER NOT NULL,
 PRECIOUNI   DECIMAL(8,2), 
 PRIMARY KEY (NROFACTURA, RENGLON),
--CONSTRAINT Chk_Detalles_Cantidad CHECK (CANTIDAD > 0 AND PRECIOUNI >= 0)
CONSTRAINT FK_DETALLES_FACTURAS FOREIGN KEY (NROFACTURA) REFERENCES FACTURAS(NROFACTURA) ON DELETE CASCADE);
--CONSTRAINT FK_DETALLES_FACTURAS FOREIGN KEY (ARTICULO)   REFERENCES ARTICULOS(NROARTIC)  ON DELETE NO ACTION);
--
--
-- INSERT INTO de Datos
--
BEGIN TRANSACTION;
INSERT INTO CLIENTES VALUES (69,'Juan Martinez','Maipu 123','Capital Federal',-28.00);
INSERT INTO CLIENTES VALUES (109,'Pedro Garcia','Rosales 346','Capital Federal',-121.00);
INSERT INTO CLIENTES VALUES (138,'Isela Perez','Alsina 399','Carapachay',-39.67);
INSERT INTO CLIENTES VALUES (160,'Silvana Zabala','Medrano 32','Capital Federal',-45.67);
INSERT INTO CLIENTES VALUES (179,'Natalia Lopéz','Chacabuco 476','Morón',57.67);
INSERT INTO CLIENTES VALUES (194,'Patricio Blanco','Belgrano 22','Capital Federal',132.00);
INSERT INTO CLIENTES VALUES (207,'Cecilia Nieto','Av. Rivadavia 13520','Carapachay',-48.67);
INSERT INTO CLIENTES VALUES (219,'Karina Pierro','Av. De Mayo 11','Capital Federal',-131.00);
INSERT INTO CLIENTES VALUES (230,'Lautaro Gonzalez','Alvarado 793','Morón',92.67);
INSERT INTO CLIENTES VALUES (239,'Julio Gomez','Quintana 522','Capital Federal',79.67);
INSERT INTO CLIENTES VALUES (248,'Fernando Pereira','Fuertes 88','Capital Federal',64.33);
INSERT INTO CLIENTES VALUES (256,'Claudio Ramirez','Laprida 397','Carapachay',-118.33);
INSERT INTO CLIENTES VALUES (263,'Die-- Díaz','Juncal 77','Capital Federal',21.33);
INSERT INTO CLIENTES VALUES (270,'Maria Dominguez','Moreno 435','Morón',-68.00);
INSERT INTO CLIENTES VALUES (277,'Florencia Sastre','Alvear 32','Capital Federal',-94.00);
INSERT INTO CLIENTES VALUES (283,'Victoria Colombres','Alsina 123','Carapachay',-85.67);
INSERT INTO CLIENTES VALUES (289,'Carlos Alvarez','Belgrano 632','Capital Federal',-76.67);
INSERT INTO CLIENTES VALUES (294,'Antonio Fernandez','Corrientes 480','Capital Federal',-128.33);
INSERT INTO CLIENTES VALUES (299,'Belen Silva','Cordoba 56','Morón',96.67);
INSERT INTO CLIENTES VALUES (304,'Matias Fuentes','Mitre 134','Capital Federal',-47.00);
COMMIT;	

BEGIN TRANSACTION;
INSERT INTO RUBROS VALUES (1,'Herramienta');
INSERT INTO RUBROS VALUES (2,'Tornillos');
INSERT INTO RUBROS VALUES (3,'Clavos');
INSERT INTO RUBROS VALUES (4,'Herramienta Electrica');
INSERT INTO RUBROS VALUES (5,'Articulos de Electricidad');
INSERT INTO RUBROS VALUES (0,'Sin asignar');
COMMIT;

BEGIN TRANSACTION;
INSERT INTO ARTICULOS VALUES ('4000','Destornillador',1,855,111,3.00);
INSERT INTO ARTICULOS VALUES ('4010','Pinza',1,878,222,7.00);
INSERT INTO ARTICULOS VALUES ('4020','Tenaza',1,234,333,10.00);
INSERT INTO ARTICULOS VALUES ('4030','Martillo',1,253,44,10.00);
INSERT INTO ARTICULOS VALUES ('4040','Moladora',4,123,555,3.00);
INSERT INTO ARTICULOS VALUES ('4050','Clavo',3,317,666,8.00);
INSERT INTO ARTICULOS VALUES ('4060','Tuerca',2,45,777,7.00);
INSERT INTO ARTICULOS VALUES ('4070','Tornillo',2,200,88,10.00);
INSERT INTO ARTICULOS VALUES ('4080','Soldador',4,623,999,9.00);
INSERT INTO ARTICULOS VALUES ('4090','Enchufe',5,960,123,4.00);
INSERT INTO ARTICULOS VALUES ('4100','Cable',5,458,456,7.00);
INSERT INTO ARTICULOS VALUES ('4110','Clavo en L',3,30,78,5.00);
INSERT INTO ARTICULOS (NROARTIC, DESCRIPCION, STOCK, PTO_REPOSICION, PRECIO)
               VALUES ('5110','Plancha',3,8,75.00);
COMMIT;

BEGIN TRANSACTION;
INSERT INTO FACTURAS VALUES (1001,69,'2/2/2010');
INSERT INTO FACTURAS VALUES (1002,109,'2/2/2010');
INSERT INTO FACTURAS VALUES (1003,138,'4/2/2010');
INSERT INTO FACTURAS VALUES (1004,160,'4/2/2010');
INSERT INTO FACTURAS VALUES (1005,179,'6/2/2010');
INSERT INTO FACTURAS VALUES (1006,194,'6/2/2010');
INSERT INTO FACTURAS VALUES (1007,207,'8/2/2010');
INSERT INTO FACTURAS VALUES (1008,219,'8/2/2010');
INSERT INTO FACTURAS VALUES (1009,230,'10/2/2010');
INSERT INTO FACTURAS VALUES (1010,239,'10/2/2010');
INSERT INTO FACTURAS VALUES (1011,248,'12/3/2010');
INSERT INTO FACTURAS VALUES (1012,256,'12/3/2010');
INSERT INTO FACTURAS VALUES (1013,263,'14/3/2010');
INSERT INTO FACTURAS VALUES (1014,109,'14/3/2010');
INSERT INTO FACTURAS VALUES (1015,277,'15/3/2010');
INSERT INTO FACTURAS VALUES (1016,283,'15/3/2010');
INSERT INTO FACTURAS VALUES (1017,109,'17/3/2010');
INSERT INTO FACTURAS VALUES (1018,294,'17/3/2010');
INSERT INTO FACTURAS VALUES (1019,299,'19/3/2010');
INSERT INTO FACTURAS VALUES (1020,304,'19/3/2010');
INSERT INTO FACTURAS VALUES (1021,109,'7/4/2010');
INSERT INTO FACTURAS VALUES (1022,160,'7/4/2010');
INSERT INTO FACTURAS VALUES (1023,256,'9/4/2010');
INSERT INTO FACTURAS VALUES (1024,239,'9/4/2010');
INSERT INTO FACTURAS VALUES (1025,138,'11/4/2010');
INSERT INTO FACTURAS VALUES (1026,239,'11/4/2010');
INSERT INTO FACTURAS VALUES (1027,138,'13/4/2010');
INSERT INTO FACTURAS VALUES (1028,160,'13/4/2010');
INSERT INTO FACTURAS VALUES (1029,230,'15/4/2010');
INSERT INTO FACTURAS VALUES (1030,109,'15/4/2010');
INSERT INTO FACTURAS VALUES (1031,138,'2/5/2010');
INSERT INTO FACTURAS VALUES (1032,160,'2/5/2010');
INSERT INTO FACTURAS VALUES (1033,179,'4/5/2010');
INSERT INTO FACTURAS VALUES (1034,194,'5/5/2010');
INSERT INTO FACTURAS VALUES (1035,207,'6/5/2010');
INSERT INTO FACTURAS VALUES (1036,219,'7/5/2010');
INSERT INTO FACTURAS VALUES (1037,230,'8/5/2010');
INSERT INTO FACTURAS VALUES (1038,239,'9/5/2010');
INSERT INTO FACTURAS VALUES (1039,248,'10/5/2010');
INSERT INTO FACTURAS VALUES (1040,256,'11/6/2010');
INSERT INTO FACTURAS VALUES (1041,263,'12/6/2010');
INSERT INTO FACTURAS VALUES (1042,270,'13/6/2010');
INSERT INTO FACTURAS VALUES (1043,277,'14/6/2010');
INSERT INTO FACTURAS VALUES (1044,283,'15/6/2010');
INSERT INTO FACTURAS VALUES (1045,289,'1/6/2010');
INSERT INTO FACTURAS VALUES (1046,294,'2/6/2010');
INSERT INTO FACTURAS VALUES (1047,299,'3/6/2010');
INSERT INTO FACTURAS VALUES (1048,304,'4/6/2010');
INSERT INTO FACTURAS VALUES (1049,160,'5/6/2010');
INSERT INTO FACTURAS VALUES (1050,179,'6/7/2010');
COMMIT;

BEGIN TRANSACTION;
INSERT INTO DETALLES VALUES(1001,1,4060,6.00,0.00);
INSERT INTO DETALLES VALUES(1002,1,4070,5.00,0.00);
INSERT INTO DETALLES VALUES(1003,1,4080,1.00,0.00);
INSERT INTO DETALLES VALUES(1003,2,4090,3.00,0.00);
INSERT INTO DETALLES VALUES(1004,1,4090,2.00,0.00);
INSERT INTO DETALLES VALUES(1004,2,4100,2.00,0.00);
INSERT INTO DETALLES VALUES(1004,3,4110,2.00,0.00);
INSERT INTO DETALLES VALUES(1005,1,4100,3.00,0.00);
INSERT INTO DETALLES VALUES(1005,2,4110,3.00,0.00);
INSERT INTO DETALLES VALUES(1005,3,4000,1.00,0.00);
INSERT INTO DETALLES VALUES(1005,4,4010,1.00,0.00);
INSERT INTO DETALLES VALUES(1005,5,4020,2.00,0.00);
INSERT INTO DETALLES VALUES(1005,6,4030,6.00,0.00);
INSERT INTO DETALLES VALUES(1005,7,4040,1.00,0.00);
INSERT INTO DETALLES VALUES(1005,8,4050,1.00,0.00);
INSERT INTO DETALLES VALUES(1005,9,4060,5.00,0.00);
INSERT INTO DETALLES VALUES(1005,10,4070,3.00,0.00);
INSERT INTO DETALLES VALUES(1006,1,4110,5.00,0.00);
INSERT INTO DETALLES VALUES(1007,1,4000,2.00,0.00);
INSERT INTO DETALLES VALUES(1008,1,4010,6.00,0.00);
INSERT INTO DETALLES VALUES(1008,2,4020,3.00,0.00);
INSERT INTO DETALLES VALUES(1009,1,4020,1.00,0.00);
INSERT INTO DETALLES VALUES(1010,1,4030,2.00,0.00);
INSERT INTO DETALLES VALUES(1010,2,4040,3.00,0.00);
INSERT INTO DETALLES VALUES(1011,1,4040,5.00,0.00);
INSERT INTO DETALLES VALUES(1012,1,4050,2.00,0.00);
INSERT INTO DETALLES VALUES(1012,2,4060,3.00,0.00);
INSERT INTO DETALLES VALUES(1013,1,4060,1.00,0.00);
INSERT INTO DETALLES VALUES(1014,1,4070,5.00,0.00);
INSERT INTO DETALLES VALUES(1014,2,4080,3.00,0.00);
INSERT INTO DETALLES VALUES(1014,3,4090,3.00,0.00);
INSERT INTO DETALLES VALUES(1014,4,4100,3.00,0.00);
INSERT INTO DETALLES VALUES(1014,5,4110,5.00,0.00);
INSERT INTO DETALLES VALUES(1014,6,4000,1.00,0.00);
INSERT INTO DETALLES VALUES(1014,7,4050,2.00,0.00);
INSERT INTO DETALLES VALUES(1015,1,4080,2.00,0.00);
INSERT INTO DETALLES VALUES(1015,2,4090,6.00,0.00);
INSERT INTO DETALLES VALUES(1016,1,4090,3.00,0.00);
INSERT INTO DETALLES VALUES(1016,2,4100,6.00,0.00);
INSERT INTO DETALLES VALUES(1016,3,4110,4.00,0.00);
INSERT INTO DETALLES VALUES(1017,1,4100,5.00,0.00);
INSERT INTO DETALLES VALUES(1017,2,5110,2.00,0.00);
INSERT INTO DETALLES VALUES(1018,1,4110,2.00,0.00);
INSERT INTO DETALLES VALUES(1018,2,4000,6.00,0.00);
INSERT INTO DETALLES VALUES(1018,3,4010,4.00,0.00);
INSERT INTO DETALLES VALUES(1018,4,4020,2.00,0.00);
INSERT INTO DETALLES VALUES(1018,5,4030,5.00,0.00);
INSERT INTO DETALLES VALUES(1018,6,4040,3.00,0.00);
INSERT INTO DETALLES VALUES(1018,7,4050,3.00,0.00);
INSERT INTO DETALLES VALUES(1018,8,4060,5.00,0.00);
INSERT INTO DETALLES VALUES(1018,9,4070,5.00,0.00);
INSERT INTO DETALLES VALUES(1019,1,4000,3.00,0.00);
INSERT INTO DETALLES VALUES(1019,2,4010,6.00,0.00);
INSERT INTO DETALLES VALUES(1019,3,4020,1.00,0.00);
INSERT INTO DETALLES VALUES(1019,4,4030,6.00,0.00);
INSERT INTO DETALLES VALUES(1020,1,4010,2.00,0.00);
INSERT INTO DETALLES VALUES(1021,1,4020,4.00,0.00);
INSERT INTO DETALLES VALUES(1021,2,4030,4.00,0.00);
INSERT INTO DETALLES VALUES(1021,3,4040,2.00,0.00);
INSERT INTO DETALLES VALUES(1021,4,4050,6.00,0.00);
INSERT INTO DETALLES VALUES(1021,5,4060,6.00,0.00);
INSERT INTO DETALLES VALUES(1022,1,4030,3.00,0.00);
INSERT INTO DETALLES VALUES(1022,2,4040,2.00,0.00);
INSERT INTO DETALLES VALUES(1023,1,4040,4.00,0.00);
INSERT INTO DETALLES VALUES(1023,2,4050,6.00,0.00);
INSERT INTO DETALLES VALUES(1023,3,4060,6.00,0.00);
INSERT INTO DETALLES VALUES(1023,4,4070,2.00,0.00);
INSERT INTO DETALLES VALUES(1023,5,4080,5.00,0.00);
INSERT INTO DETALLES VALUES(1024,1,4050,3.00,0.00);
INSERT INTO DETALLES VALUES(1024,2,4060,3.00,0.00);
INSERT INTO DETALLES VALUES(1024,3,4070,6.00,0.00);
INSERT INTO DETALLES VALUES(1025,1,4060,3.00,0.00);
INSERT INTO DETALLES VALUES(1025,2,4070,1.00,0.00);
INSERT INTO DETALLES VALUES(1025,3,4080,1.00,0.00);
INSERT INTO DETALLES VALUES(1026,1,4070,6.00,0.00);
INSERT INTO DETALLES VALUES(1026,2,4080,5.00,0.00);
INSERT INTO DETALLES VALUES(1027,1,4080,3.00,0.00);
INSERT INTO DETALLES VALUES(1027,2,4090,2.00,0.00);
INSERT INTO DETALLES VALUES(1028,1,4090,2.00,0.00);
INSERT INTO DETALLES VALUES(1028,2,4100,2.00,0.00);
INSERT INTO DETALLES VALUES(1028,3,4110,4.00,0.00);
INSERT INTO DETALLES VALUES(1029,1,4100,1.00,0.00);
INSERT INTO DETALLES VALUES(1029,2,4110,3.00,0.00);
INSERT INTO DETALLES VALUES(1030,1,4110,4.00,0.00);
INSERT INTO DETALLES VALUES(1030,2,4000,4.00,0.00);
INSERT INTO DETALLES VALUES(1030,3,4010,2.00,0.00);
INSERT INTO DETALLES VALUES(1030,4,4020,3.00,0.00);
INSERT INTO DETALLES VALUES(1031,1,4000,2.00,0.00);
INSERT INTO DETALLES VALUES(1031,2,4010,3.00,0.00);
INSERT INTO DETALLES VALUES(1032,1,4010,3.00,0.00);
INSERT INTO DETALLES VALUES(1032,2,4020,2.00,0.00);
INSERT INTO DETALLES VALUES(1032,3,4030,3.00,0.00);
INSERT INTO DETALLES VALUES(1032,4,4040,3.00,0.00);
INSERT INTO DETALLES VALUES(1032,5,4050,5.00,0.00);
INSERT INTO DETALLES VALUES(1032,6,4060,6.00,0.00);
INSERT INTO DETALLES VALUES(1033,1,4020,6.00,0.00);
INSERT INTO DETALLES VALUES(1033,2,4030,6.00,0.00);
INSERT INTO DETALLES VALUES(1033,3,4040,6.00,0.00);
INSERT INTO DETALLES VALUES(1033,4,4050,3.00,0.00);
INSERT INTO DETALLES VALUES(1033,5,4060,2.00,0.00);
INSERT INTO DETALLES VALUES(1033,6,4070,1.00,0.00);
INSERT INTO DETALLES VALUES(1033,7,4080,5.00,0.00);
INSERT INTO DETALLES VALUES(1033,8,4090,6.00,0.00);
INSERT INTO DETALLES VALUES(1034,1,4030,1.00,0.00);
INSERT INTO DETALLES VALUES(1035,1,4040,3.00,0.00);
INSERT INTO DETALLES VALUES(1035,2,4050,5.00,0.00);
INSERT INTO DETALLES VALUES(1036,1,4050,2.00,0.00);
INSERT INTO DETALLES VALUES(1037,1,4060,1.00,0.00);
INSERT INTO DETALLES VALUES(1037,2,4070,1.00,0.00);
INSERT INTO DETALLES VALUES(1037,3,4080,2.00,0.00);
INSERT INTO DETALLES VALUES(1037,4,4090,2.00,0.00);
INSERT INTO DETALLES VALUES(1037,5,4100,3.00,0.00);
INSERT INTO DETALLES VALUES(1037,6,4110,4.00,0.00);
INSERT INTO DETALLES VALUES(1037,7,4000,3.00,0.00);
INSERT INTO DETALLES VALUES(1037,8,4010,5.00,0.00);
INSERT INTO DETALLES VALUES(1038,1,4070,5.00,0.00);
INSERT INTO DETALLES VALUES(1038,2,4080,5.00,0.00);
INSERT INTO DETALLES VALUES(1038,3,4090,2.00,0.00);
INSERT INTO DETALLES VALUES(1038,4,4100,5.00,0.00);
INSERT INTO DETALLES VALUES(1038,5,4110,5.00,0.00);
INSERT INTO DETALLES VALUES(1038,6,4000,1.00,0.00);
INSERT INTO DETALLES VALUES(1038,7,4010,2.00,0.00);
INSERT INTO DETALLES VALUES(1039,1,4080,5.00,0.00);
INSERT INTO DETALLES VALUES(1039,2,4090,3.00,0.00);
INSERT INTO DETALLES VALUES(1039,3,4100,3.00,0.00);
INSERT INTO DETALLES VALUES(1039,4,4110,1.00,0.00);
INSERT INTO DETALLES VALUES(1039,5,4000,1.00,0.00);
INSERT INTO DETALLES VALUES(1040,1,4090,5.00,0.00);
INSERT INTO DETALLES VALUES(1040,2,4100,1.00,0.00);
INSERT INTO DETALLES VALUES(1040,3,4110,6.00,0.00);
INSERT INTO DETALLES VALUES(1040,4,4000,6.00,0.00);
INSERT INTO DETALLES VALUES(1040,5,4010,6.00,0.00);
INSERT INTO DETALLES VALUES(1040,6,4020,1.00,0.00);
INSERT INTO DETALLES VALUES(1040,7,4030,1.00,0.00);
INSERT INTO DETALLES VALUES(1040,8,4040,4.00,0.00);
INSERT INTO DETALLES VALUES(1041,1,4100,6.00,0.00);
INSERT INTO DETALLES VALUES(1041,2,4110,5.00,0.00);
INSERT INTO DETALLES VALUES(1041,3,4000,6.00,0.00);
INSERT INTO DETALLES VALUES(1041,4,4010,1.00,0.00);
INSERT INTO DETALLES VALUES(1041,5,4020,5.00,0.00);
INSERT INTO DETALLES VALUES(1041,6,4030,5.00,0.00);
INSERT INTO DETALLES VALUES(1041,7,4040,4.00,0.00);
INSERT INTO DETALLES VALUES(1041,8,4050,1.00,0.00);
INSERT INTO DETALLES VALUES(1042,1,4110,2.00,0.00);
INSERT INTO DETALLES VALUES(1042,2,4000,6.00,0.00);
INSERT INTO DETALLES VALUES(1042,3,4010,3.00,0.00);
INSERT INTO DETALLES VALUES(1042,4,4020,6.00,0.00);
INSERT INTO DETALLES VALUES(1042,5,4030,3.00,0.00);
INSERT INTO DETALLES VALUES(1043,1,4000,4.00,0.00);
INSERT INTO DETALLES VALUES(1043,2,4010,6.00,0.00);
INSERT INTO DETALLES VALUES(1043,3,4020,5.00,0.00);
INSERT INTO DETALLES VALUES(1043,4,4030,5.00,0.00);
INSERT INTO DETALLES VALUES(1044,1,4010,5.00,0.00);
INSERT INTO DETALLES VALUES(1044,2,4020,5.00,0.00);
INSERT INTO DETALLES VALUES(1044,3,4030,5.00,0.00);
INSERT INTO DETALLES VALUES(1044,4,4040,1.00,0.00);
INSERT INTO DETALLES VALUES(1044,5,4050,1.00,0.00);
INSERT INTO DETALLES VALUES(1044,6,4060,3.00,0.00);
INSERT INTO DETALLES VALUES(1045,1,4020,1.00,0.00);
INSERT INTO DETALLES VALUES(1045,2,4030,6.00,0.00);
INSERT INTO DETALLES VALUES(1045,3,4040,3.00,0.00);
INSERT INTO DETALLES VALUES(1045,4,4050,2.00,0.00);
INSERT INTO DETALLES VALUES(1046,1,4030,1.00,0.00);
INSERT INTO DETALLES VALUES(1046,2,4040,1.00,0.00);
INSERT INTO DETALLES VALUES(1047,1,4040,4.00,0.00);
INSERT INTO DETALLES VALUES(1048,1,4050,5.00,1.00);
INSERT INTO DETALLES VALUES(1048,2,4060,6.00,2.00);
INSERT INTO DETALLES VALUES(1048,3,4070,4.00,3.00);
INSERT INTO DETALLES VALUES(1048,4,4080,2.00,4.00);
INSERT INTO DETALLES VALUES(1048,5,4090,5.00,5.00);
INSERT INTO DETALLES VALUES(1048,6,4100,2.00,6.00);
INSERT INTO DETALLES VALUES(1048,7,4110,6.00,7.00);
INSERT INTO DETALLES VALUES(1048,8,4000,5.00,8.00);
INSERT INTO DETALLES VALUES(1048,9,4010,3.00,9.00);
INSERT INTO DETALLES VALUES(1048,10,4020,5.00,10.00);
INSERT INTO DETALLES VALUES(1048,11,4030,4.00,11.00);
INSERT INTO DETALLES VALUES(1048,12,4040,2.00,12.00);
INSERT INTO DETALLES VALUES(1049,1,4060,2.00,13.00);
INSERT INTO DETALLES VALUES(1049,2,4070,3.00,14.00);
INSERT INTO DETALLES VALUES(1049,3,4080,5.00,15.00);
INSERT INTO DETALLES VALUES(1049,4,4090,6.00,16.00);
INSERT INTO DETALLES VALUES(1049,5,4100,2.00,17.00);
INSERT INTO DETALLES VALUES(1050,1,4070,5.00,18.00);
INSERT INTO DETALLES VALUES(1050,2,4080,6.00,19.00);
INSERT INTO DETALLES VALUES(1050,3,4090,6.00,20.00);
COMMIT;


UPDATE DETALLES SET PRECIOUNI = (SELECT PRECIO FROM ARTICULOS
                                  WHERE DETALLES.ARTICULO = ARTICULOS.NROARTIC)
       Where Detalles.PRECIOUNI = 0;

--
-- INSERT INTO de Datos con NULL
--
BEGIN TRANSACTION;
INSERT INTO CLIENTES (nrocli, nyape, saldocli) VALUES (502,'Jose Pereira',-28.00);
INSERT INTO CLIENTES (nrocli, nyape, saldocli) VALUES (509,'Pablo Ferro',38.00);
INSERT INTO CLIENTES (nrocli, nyape, domicilio, saldocli) VALUES (520,'Pablo Ferro','Peru 31',228.00);
COMMIT;



---------------------------------- PRACTICA 10 -------------------------------------

--A)  Hallar los clientes deudores ordenado en forma alfabetica

SELECT * FROM CLIENTES WHERE SALDOCLI < 0 ORDER BY NYAPE ASC;


--B) Hallar los articulos que se deberían reponer

SELECT * FROM ARTICULOS WHERE STOCK <= PTO_REPOSICION;


--C) Averiguar los clientes que viven en Capital

SELECT * FROM CLIENTES WHERE LOCALIDAD = 'Capital Federal';


--D) Averiguar los clientes que vivan en Capital o en Carapachay y no sean deudores

SELECT * FROM CLIENTES WHERE (LOCALIDAD = 'Capital Federal' OR LOCALIDAD = 'Carapachay') AND SALDOCLI >= 0; 


--E) Averiguar la cantidad de cada uno de los artículos vendidos durante
--   marzo del 2010, ordenado segun la cantidad vendida.
--   (Rsta: 13 FILAS)

SELECT d.articulo AS nro_artic, SUM(d.cantidad) AS cantidad_vendida FROM DETALLES d, FACTURAS f
WHERE d.nrofactura = f.nrofactura
AND f.fecha BETWEEN '2010-03-01' AND '2010-03-31'
GROUP BY d.articulo
ORDER BY cantidad_vendida DESC;


--F) Hallar los importes totales día a día durante abril del 2010, ordenados en
--   forma decreciente. (Rsta: 5 filas)

SELECT to_char(f.fecha,'YYYY-MM-DD') AS fecha,SUM(d.preciouni*d.cantidad)cant FROM DETALLES d, FACTURAS f
WHERE d.nrofactura = f.nrofactura
AND f.fecha BETWEEN '2010-04-01' AND '2010-04-30'
GROUP BY fecha
ORDER BY cant DESC;


-- G) Obtener las fechas en las que se hayan vendido más de $200.- (Rsta: filas 9)

SELECT to_char(f.fecha,'YYYY-MM-DD') AS fecha, SUM(d.cantidad*d.preciouni) AS vendido FROM DETALLES d, FACTURAS f
WHERE d.nrofactura = f.nrofactura 
GROUP BY fecha
HAVING SUM(d.cantidad*d.preciouni) > 200 
ORDER BY vendido DESC;


-- H) Obtener las fechas en las que mas se facturo
--   (2010-03-17 - $429)

SELECT to_char(f.fecha,'YYYY-MM-DD') AS fecha, SUM(d.cantidad*d.preciouni) AS facturado FROM DETALLES d, FACTURAS f
WHERE d.nrofactura = f.nrofactura
GROUP BY fecha ORDER BY facturado DESC LIMIT 1


-- I) Averiguar los rubros con movimientos del 15 al 30 de Abril del 2010 (Rsta: 3 filas)

SELECT a.rubro FROM ARTICULOS a, DETALLES d, FACTURAS f
WHERE a.nroartic = d.articulo AND f.nrofactura = d.nrofactura AND (f.fecha BETWEEN '2010-04-15' AND '2010-04-30') 
GROUP BY a.rubro;


-- J) Listar Numero y nombre de los cliente. Además, listar la cantidad de facturas que
--    tuvo durante Marzo y Abril del 2010 considerando SOLO las facturas en las que compro
--    articulos del rubro 3, ordenado por numero de cliente. (Rsta: 7 filas)

SELECT c.nrocli, c.nyape, COUNT(f.nrofactura) AS facturas FROM CLIENTES c, FACTURAS f, DETALLES d, ARTICULOS a 
WHERE c.nrocli = f.cliente AND d.nrofactura = f.nrofactura 
AND a.nroartic = d.articulo AND(f.fecha BETWEEN '2010-03-01' AND '2010-04-30')
AND a.rubro = 3 GROUP BY c.nrocli, c.nyape ORDER BY facturas DESC;


-- K) Listar Numero y nombre de los cliente y la cantidad de facturas que tuvo durante
--    Marzo y Abril del 2010 con articulos del rubro 3 y CON MAS DE 2 FACTURAS, 
--    ordenado por numero de cliente. (Rsta: 1 fila)

SELECT c.nrocli, c.nyape, COUNT(f.nrofactura) AS facturas FROM CLIENTES c, FACTURAS f, DETALLES d, ARTICULOS a 
WHERE c.nrocli = f.cliente AND d.nrofactura = f.nrofactura 
AND a.nroartic = d.articulo AND (f.fecha BETWEEN '2010-03-01' AND '2010-04-30')
AND a.rubro = 3 GROUP BY c.nrocli HAVING COUNT(f.nrofactura)>2 ORDER BY facturas DESC


-- L) Calcular la cantidad de unidades del artículo 4040 vendidas en marzo del 2010.
--    (Rsta: 8 articulos)

SELECT d.articulo, SUM(d.cantidad) AS unidades_vendidas FROM FACTURAS f, DETALLES d
WHERE d.articulo = 4040 AND f.nrofactura = d.nrofactura AND (f.fecha BETWEEN '2010-03-01' AND '2010-03-31')
GROUP BY d.articulo;


-- M) Calcular la cantidad de facturas en las que vendieron artículos del rubro 3
--    (Rsta: 26 facturas)

SELECT COUNT(*) AS cantidad_facturas FROM FACTURAS f
WHERE f.nrofactura in (SELECT d.nrofactura FROM ARTICULOS a, DETALLES d 
					   WHERE f.nrofactura = d.nrofactura
					   AND   d.articulo   = a.nroartic
					   AND   a.rubro = 3);
			  
			  
-- N) Obtener el promedio del importe diario de las ventas del mes de mayo del 2010.

SELECT to_char(f.fecha,'YYYY-MM-DD') AS fecha, AVG(d.cantidad*d.preciouni) as promedio FROM FACTURAS f, DETALLES d
WHERE (f.fecha BETWEEN '2010-05-01' AND '2010-05-31') AND d.nrofactura = f.nrofactura
GROUP BY f.fecha


-- O) a) Listar el numero, nombre, apellido y el total facturado de los clientes que 
--       hayan gastado más de $150 durante el mes de mayo de 2010.
--    b) Listar el numero, nombre, apellido y el total facturado de los clientes que 
--       hayan gastado en mayo de 2010 mas que en abril de 2010.

--a
SELECT c.nrocli, c.nyape, SUM(d.cantidad*d.preciouni) AS total_facturado FROM CLIENTES c, FACTURAS f, DETALLES d
WHERE f.cliente = c.nrocli AND d.nrofactura = f.nrofactura AND (f.fecha BETWEEN '2010-05-01' AND '2010-05-31')
GROUP BY c.nrocli 
HAVING SUM(d.cantidad*d.preciouni) > 150
ORDER BY total_facturado DESC

--b
SELECT c.nrocli, c.nyape, SUM(d.cantidad*d.preciouni) AS total_facturado FROM CLIENTES c, FACTURAS f, DETALLES d
WHERE f.cliente = c.nrocli AND d.nrofactura = f.nrofactura AND (f.fecha BETWEEN '2010-05-01' AND '2010-05-31')
GROUP BY c.nrocli 
HAVING SUM(d.cantidad*d.preciouni) > (SELECT SUM(dd.cantidad*dd.preciouni) FROM FACTURAS ff, DETALLES dd
									  WHERE ff.cliente = c.nrocli AND dd.nrofactura = ff.nrofactura AND (ff.fecha BETWEEN '2010-04-01' AND '2010-04-30'))
									

-- P) Listar los articulos que tengan un stock menor al stock minimo y NO se hayan
--    vendido en Junio del 2010
--    Resultado: 1 fila

SELECT ar.*  FROM ARTICULOS ar WHERE ar.stock <= ar.pto_reposicion
AND ar.nroartic NOT IN (select de.articulo from detalles de, facturas fa
where de.nrofactura = fa.nrofactura
and date_part('year', fa.fecha) = 2010
and date_part('month', fa.fecha) = 06);


-- Q) Listar los artículos que tengan un precio mayor a la mitad del precio
--    promedio de los artículos y un stock mínimo mayor a 200 unidades. (6 filas)

SELECT * FROM ARTICULOS a
WHERE a.pto_reposicion > 200 AND a.precio > (SELECT  AVG(precio)/2 FROM ARTICULOS)
 
 
-- R) Listar los datos cabecera de las Facturas de mas de $200 y que la cantidad
--    de artículos facturados en la misma sea mayor a 30 
--    (Rsta: 4 filas)

SELECT f.* FROM FACTURAS f, DETALLES d
WHERE f.nrofactura = d.nrofactura
GROUP BY f.nrofactura, f.cliente, f.fecha
HAVING SUM(d.cantidad)>30 AND SUM(d.cantidad*d.preciouni)>200


-- S) Listar los datos cabecera de las Facturas de mas de $200 y que la cantidad
--    de artículos facturados en la misma sea mayor al 5% del stock promedio
--    de los rubros "Herramienta%"
--    (Rsta: 5 FILAS)

SELECT f.*, SUM(d.cantidad*d.preciouni) AS facturado FROM FACTURAS f, DETALLES d
WHERE f.nrofactura = d.nrofactura 
GROUP BY f.nrofactura, f.cliente, f.fecha
HAVING SUM(d.cantidad*d.preciouni) > 200 AND SUM(d.cantidad)>(SELECT AVG(aa.stock)*0.05 FROM ARTICULOS aa, RUBROS r
															    WHERE aa.rubro = r.cod_rubro 
																AND r.descripcion ILIKE 'herramienta%')
ORDER BY f.nrofactura DESC;


-- T) a) Listar los clientes compraron TODOS los articulos (1 fila - cliente 109)
--    b) Listar los clientes que en Junio compraron TODOS los articulos del rubro
--       "Tornillos". (2 filas - clientes 160 - 304)

--a
SELECT * FROM CLIENTES c
WHERE NOT EXISTS (SELECT 1 FROM ARTICULOS A
                  WHERE NOT EXISTS 
                  (SELECT 1 FROM DETALLES D,FACTURAS F
                   WHERE C.NROCLI = F.CLIENTE 
				   AND F.NROFACTURA = D.NROFACTURA 
				   AND D.ARTICULO = A.NROARTIC))
				 
--b
SELECT c.* FROM CLIENTES c
WHERE NOT EXISTS (SELECT 1 FROM ARTICULOS A
				  WHERE NOT EXISTS (SELECT 1 FROM DETALLES d, FACTURAS f
								    WHERE d.nrofactura = f.nrofactura 
									AND d.articulo = A.nroartic
								    AND c.nrocli = f.cliente
								    AND date_part('month',f.fecha) = 06)
				  AND A.rubro IN (SELECT r.cod_rubro FROM RUBROS r
								  WHERE r.descripcion ILIKE 'Tornillo%'))

				 					
-- Y) Listar los clientes de 'Capital Federal' que NO compraron articulos del
--    rubro 'Articulos de Electricidad' durante mayo de año 2010.
--    Ordenar los datos en forma descendente por nombre y apellido.
--    (Rsta: 10 filas)

SELECT c.* FROM CLIENTES c WHERE c.localidad ILIKE 'CAPITAL FEDERAL'
AND c.nrocli NOT IN(SELECT f.cliente FROM FACTURAS f, DETALLES d, RUBROS r, ARTICULOS a
				    WHERE f.nrofactura = d.nrofactura AND d.articulo = a.nroartic
				    AND r.cod_rubro = a.rubro AND r.descripcion ILIKE 'Articulos de Electricidad'
				    AND (f.fecha BETWEEN '01-05-2010' AND '31-05-2010'))
GROUP BY c.nrocli, c.nyape, c.domicilio, c.localidad, c.saldocli
ORDER BY c.nyape DESC


-- Z) Listar los rubros (y la cantidad de articulos vendidos) de cada rubro que haya
--    vendido mas de 30 articulos.

SELECT r.*, SUM(d.cantidad) AS articulos_vendidos FROM RUBROS r, DETALLES d, ARTICULOS a 
WHERE a.nroartic = d.articulo AND r.cod_rubro = a.rubro 
GROUP BY r.cod_rubro
HAVING SUM(d.cantidad) > 30
ORDER BY r.cod_rubro ASC


-- 3) Generar un unico Select con el o los articulos mas caros y con el o los mas baratos

SELECT MAX(PRECIO), MIN(PRECIO) FROM ARTICULOS


-- 4) Listar los datos de los clientes que no compraron ningun articulo
--    (Rsta: 3 filas)

SELECT * FROM CLIENTES c
WHERE NOT EXISTS (SELECT 1 FROM FACTURAS f
				  WHERE EXISTS (SELECT 1 FROM DETALLES d, FACTURAS f
							    WHERE c.nrocli = f.cliente 
								AND d.nrofactura = f.nrofactura
							    AND a.nroartic = d.articulo))
SELECT * FROM CLIENTES c
WHERE c.nrocli NOT IN (SELECT f.cliente FROM FACTURAS f)
								
-- 5) Listar las localidades que vendieron mas de que lo que se le facturo al cliente 179

SELECT c.localidad, SUM(d.cantidad*d.preciouni) AS facturado FROM CLIENTES c, FACTURAS f, DETALLES d
WHERE c.nrocli = f.cliente AND d.nrofactura = f.nrofactura
GROUP BY c.localidad
HAVING SUM(d.cantidad*d.preciouni) > (SELECT SUM(dd.cantidad*dd.preciouni) FROM FACTURAS ff, DETALLES dd
									  WHERE ff.cliente = 179 AND dd.nrofactura = ff.nrofactura)


-- 6) Listar numero, nombre y apellido de los clientes, el total facturado y que
--    porcentaje del total facturado gastaron
--    Rsta: Nrocli   NyApe           Facturado   Porc_del_total_facturado   
--          ------   ---------------  -------    -------------------------
--          179	   "Natalia Lopéz"  "781.00"	"15.81611988659376265700"
--          109    "Pedro Garcia"   "641.00"	"12.98096395301741595800"
--          160	   "Silvana Zabala" "545.00"	"11.03685702713649250700"

SELECT c.nrocli, c.nyape, c.saldocli, SUM(d.cantidad*d.preciouni) AS Facturado FROM CLIENTES c, FACTURAS f, DETALLES d
WHERE c.nrocli = f.cliente AND f.nrofactura = d.nrofactura
GROUP BY c.nrocli


-- 9) Listar todos los datos de los clientes, el total facturado y la cantidad de facturas
--    del primer trimestre del año 2010 y el total facturado y la cantidad de facturas
--    del segundo trimestre del año 2010
--
--  Nro nyape          Domicilio   Localidad        Saldo  T_1Trim  Q_1Trim T_2Trim  Q_2Trim
-- ---- -------------  ----------- --------------- -------  ------- ------- -------  --------
--   69 Juan Martinez  Maipu 123   Capital Federal  -28.00    42.00	1   <null>	0
--  109 Pedro Garcia   Rosales 346 Capital Federal -121.00   389.00	3   252.00	2
--  138 Isela Perez    Alsina 399  Carapachay	    -39.67    21.00	1   102.00	3
--  160 Silvana Zabala Medrano 32  Capital Federal  -45.67    32.00	1   513.00	4

SELECT A.*, B.T_2Trim, B.Q_2Trim FROM
(SELECT c.*, SUM(d.cantidad * d.preciouni) AS T_1Trim, COUNT(d.nrofactura) AS Q_1Trim FROM CLIENTES c, FACTURAS f, DETALLES d
WHERE c.nrocli = f.cliente AND d.nrofactura = f.nrofactura AND f.fecha BETWEEN '2010-01-01' AND '2010-03-31'
GROUP BY c.nrocli, c.nyape, c.domicilio, c.localidad, c.saldocli) A
FULL OUTER JOIN 
(SELECT c.nrocli, SUM(d.cantidad * d.preciouni) AS T_2Trim, COUNT(d.nrofactura) AS Q_2Trim FROM CLIENTES c, FACTURAS f, DETALLES d
WHERE c.nrocli = f.cliente AND d.nrofactura = f.nrofactura AND f.fecha BETWEEN '2010-04-01' AND '2010-06-30'
GROUP BY c.nrocli, c.nyape, c.domicilio, c.localidad, c.saldocli) B on A.nrocli = B.nrocli


-------------------------- PARCIAL WALTER --------------------------

-- CLIENTES (Nrocli,     NyApe,       Domicilio, Localidad, Saldocli)
-- FACTURAS (Nrofactura, Cliente,     Fecha)
-- DETALLES (Nrofactura, Renglón,     Articulo,  Cantidad,  Preciouni)
-- ARTICULOS(Nroartic,   Descripción, Rubro,     Stock,     Pto_reposicion, precio)
-- RUBROS   (Cod_rubro,  Descripción)


--A) Listar los dias del mes de Mayo de 2010 en que el total facturado es inferior a $15000
-- listar fecha y monto facturado, ordenado por fecha.

SELECT f.fecha, SUM(d.cantidad * d.preciouni) AS Facturado FROM DETALLES d, FACTURAS f
WHERE d.nrofactura = f.nrofactura AND f.fecha BETWEEN '01-05-2010' AND '31-05-2010'
GROUP BY f.fecha
HAVING SUM(d.cantidad * d.preciouni) < 15000
ORDER BY f.fecha


--B) Listar todos los datos de los articulos y la descripción de su rubro de aquellos articulos que tengan
-- un stock menor al punto de reposición y que NO se hayan vendido en Julio de 2010

SELECT a.*, r.descripcion FROM ARTICULOS a, RUBROS r
WHERE a.rubro = r.cod_rubro AND a.stock < a.pto_reposicion
AND a.nroartic NOT IN (SELECT d.articulo FROM DETALLES d, FACTURAS f
					   WHERE d.nrofactura = f.nrofactura
					   AND f.fecha BETWEEN '01-07-2010' AND '31-07-2010')
GROUP BY a.nroartic, r.descripcion
ORDER BY a.nroartic ASC


