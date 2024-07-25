# MSSQL-Docker-PowerBI
MSSQL con Docker para usarse en PowerBI

MODO DE USO

Paso 1 - Construir la imagen

docker build -t sqlserver-ngrok .

Paso 2 - Ejecuta la instancia

docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pass@word' -p 5433:1433 -p 4040:4040 -d sqlserver-ngrok

Paso 3 - Descarguemos la base de datos a usar AdventureWorks2019.bak

wget https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak

Paso 4 - Obtenemos el id del contenedor. ( Para no estar copiando manualmente. )

CONTAINER_ID=$(docker ps -qf "ancestor=sqlserver-ngrok")

Paso 5 - Crear un directorio

docker exec $CONTAINER_ID mkdir -p /var/opt/mssql/backup

Paso 6 - Copiamos la base de dato al contendedor

docker cp AdventureWorks2019.bak $CONTAINER_ID:/var/opt/mssql/backup/AdventureWorks2019.bak

Paso 7 - Restauramos la base de datos, en el interior del contenedor

docker exec -it $CONTAINER_ID /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "Pass@word" -Q "RESTORE DATABASE AdventureWorks2019 FROM DISK = '/var/opt/mssql/backup/AdventureWorks2019.bak' WITH MOVE 'AdventureWorks2019' TO '/var/opt/mssql/data/AdventureWorks2019.mdf', MOVE 'AdventureWorks2019_Log' TO '/var/opt/mssql/data/AdventureWorks2019.ldf'"

Paso 8 - Validamos la base de datos restaurada

docker exec -it $CONTAINER_ID /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "Pass@word" -Q "USE AdventureWorks2019;  SELECT @@VERSION"

Paso 9 - Ingresamod al contendor

docker exec -it $CONTAINER_ID /bin/bash

Paso 10 - Instalamos en el interior del contenedor "curl" (Client URL)

apt install curl

Paso 11 - Recuperamos y filtrar información sobre túneles ngrok activos.

curl -s http://localhost:4040/api/tunnels | grep -o 'tcp://[^"]*'

Deberiamos obtener algo como 
0.tcp.ngrok.io:16585

Entonces la conexión a Power BI debe ser algo como:

Server	0.tcp.ngrok.io, 16585
User	sa
password:	Pass@word	

Podemos probar en la terminal local con algo como:

cbm@MacBookPro-10 data % mssql -u SA -p Pass@word -s 8.tcp.ngrok.io -port 18058
1> USE AdventureWorks2019;  SELECT @@VERSION
2> GO
