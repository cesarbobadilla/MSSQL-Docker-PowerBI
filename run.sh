#!/bin/bash
# Start SQL Server in the background
/opt/mssql/bin/sqlservr &
# Wait for SQL Server to start up
sleep 20
# Start Ngrok
ngrok tcp 1433
