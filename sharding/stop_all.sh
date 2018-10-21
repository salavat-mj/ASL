#!/bin/bash
# Written by Salavat Garifullin
# Turns off the cluster

f='\x1b[1;34m'
t='\e[0m'
echo
echo      "########################################"
echo -e "#$f Stopping all components of a cluster $t#"
echo      "########################################"
echo 

DIR=$(dirname "${BASH_SOURCE[0]}")

echo
echo -e "#$f Stopping the mongos server $t#"
echo 
mongo admin --quiet --norc --port 40000 --eval="db.shutdownServer()"
echo -e "$f***$t"

n=0
for proc in conf sh1 sh2 sh3 sh4 sh5; do

echo
echo -e "#$f Stopping the mongod for $proc repl#1 $t#"
echo 
mongod --dbpath $DIR/data/$proc-1 --port 30$[$n]01 --shutdown
echo -e "$f***$t"

echo
echo -e "#$f Stopping the mongod for $proc repl#2 $t#"
echo 
mongod --dbpath $DIR/data/$proc-2 --port 30$[$n]02 --shutdown
echo -e "$f***$t"

echo
echo -e "#$f Stopping the mongod for $proc repl#3 $t#"
echo 
mongod --dbpath $DIR/data/$proc-3 --port 30$[$n]03 --shutdown
echo -e "$f***$t"

n=$[$n+1]

done
