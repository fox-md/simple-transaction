#!/bin/bash

sed -i "s/<Your SQL Server Connection String>/Server=$SQL_SERVER_HOST;Database=$SQL_SERVER_DATABASE;User Id=$SQL_SERVER_USER;Password=$SQL_SERVER_PASS;/g" /app/appsettings.json > /dev/null

exec "$@"
