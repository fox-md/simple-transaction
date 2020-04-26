#!/bin/bash

sed -i "s/{{ID_ENDPOINT_HOST}}/$ID_ENDPOINT_HOST/g" /app/configuration.json > /dev/null
sed -i "s/{{ID_ENDPOINT_PORT}}/$ID_ENDPOINT_PORT/g" /app/configuration.json > /dev/null

sed -i "s/{{TX_ENDPOINT_HOST}}/$TX_ENDPOINT_HOST/g" /app/configuration.json > /dev/null
sed -i "s/{{TX_ENDPOINT_PORT}}/$TX_ENDPOINT_PORT/g" /app/configuration.json > /dev/null

exec "$@"
