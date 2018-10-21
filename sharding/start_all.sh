#!/bin/bash
# Written by Salavat Garifullin
# 

f='\x1b[1;34m'
t='\e[0m'
echo
echo      "####################################"
echo -e "#$f Enable mongod and mongos servers $t#"
echo      "####################################"
echo 

echo -e "$f***$t"

DIR=$(dirname "${BASH_SOURCE[0]}")

$DIR/start_replicas.sh #-j  # to use profiling

echo
echo      "##########################"
echo -e "#$f Starting mongos server $t#"
echo      "##########################"
echo 

mongos --configdb conf/localhost:30001,localhost:30002,localhost:30003 --port 40000 --fork --logpath $DIR/data/logs/mongos.log
echo -e "$f***$t"
