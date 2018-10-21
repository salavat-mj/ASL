#!/bin/bash
# Written by Salavat Garifullin
# Imports the DB from the ./test

DIR=$(dirname "${BASH_SOURCE[0]}")

f='\x1b[1;34m'
t='\e[0m'
echo
echo      "#################################"
echo -e "#$f Import data into the database $t#"
echo      "#################################"
echo 

mkdir -p $DIR/import/

echo
echo -e "#$f Importing accounts $t#"
echo 
touch $DIR/import/accounts.json
mongoimport --port 40000 --db asl --collection accounts --type json --file $DIR/import/accounts.json
echo -e "$f***$t"

echo
echo -e "#$f Importing sessions $t#"
echo 
touch $DIR/import/sessions.json
mongoimport --port 40000 --db asl --collection sessions --type json --file $DIR/import/sessions.json
echo -e "$f***$t"

echo
echo -e "#$f Importing legs $t#"
echo 
touch $DIR/import/legs.json
mongoimport --port 40000 --db asl --collection legs --type json --file $DIR/import/legs.json
echo -e "$f***$t"
