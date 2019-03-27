#!/bin/sh

while ! nc -z primary 3306; do echo 'waiting for primary...' && sleep 1; done
while ! nc -z replica 3306; do echo 'waiting for replica...' && sleep 1; done

./bin/console doctrine:schema:update --force
./bin/console server:run 0.0.0.0:8000
