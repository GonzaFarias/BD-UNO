# script para conectarse a una BD PostgreSQL
# funciones: dbWriteTable(); dbGetQuery(); dbReadTable();
# dbSendQuery(); dbCommit(con); dbDisconnect()

#leemos un archivo .csv
library(readr)
datos <- read_delim("datos_01.csv", ";", 
                     escape_double = FALSE, locale = locale(decimal_mark = ",", 
                     grouping_mark = ""), trim_ws = TRUE)

summary(datos)

# Crear una conexion ala base de datos:

# cargamos en biblioteca
library(DBI)
library('RPostgreSQL') 

con <- dbConnect(RPostgres::Postgres(),
                 host = "localhost",
                 port = 5432,
                 dbname = "taller_",
                 user = "postgres",
                 password = "postgres"
)
# establecer una conexion a PoststgreSQL usando RPostgreSQL
# pg = dbDriver("PostgreSQL") # version simple  (localhost como default)
# 
# con = dbConnect(pg, user="postgres", password="postgres",
#                 host="localhost", port=5432, dbname="taller_")

# grabamos una nueva tabla en la BD
dbBegin(con)
dbWriteTable(con,'covid', datos, row.names=FALSE)

# realizamos una consulta:
dtab = dbGetQuery(con, "select * from covid")

# control:
summary(dtab)
dtab  # muestro la tabla

# leemos la tabla completa sin usar sintaxis SQL:

rm(dtab) # borro lo anterior
dtab = dbReadTable(con, "covid")
summary(dtab)

# otro ejemplo de consulta:
rm(dtab)
dtab = dbGetQuery(con, "select pais, casos  from covid")
summary(dtab)

#######   drop
# remover la tabla de la BD

dbSendQuery(con, "drop table covid")

# guardar los cambios
dbCommit(con)
############# desconectar
# desconectar de la BD
dbDisconnect(con)
#############
#  ejemplos de usos:

toaltes <- dbGetQuery(con, "Select *
                            From covid")

aux   <- dbGetQuery(con, "Select max(casos) as max, sum(casos) as  suma
                            From covid")
print(aux)

consulta <- c("select pais, casos from covid c  where casos > 10000 order by casos desc")

aux   <- dbGetQuery(con, consulta)
print(aux)
######################

# ALTER SYSTEM SET password_encryption = 'md5'
# --Clic derecho en la instancia > Reload Configuration
# ALTER ROLE postgres PASSWORD 'postgres';
# SELECT passwd FROM pg_shadow WHERE user = 'postgres'
