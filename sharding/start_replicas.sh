#!/bin/bash
# Written by Salavat Garifullin
# Runs all mongod servers
# To use profiling, you must enable journaling
# When you call a script, you can specify the parameters:
# -j - enable journaling

f='\x1b[1;34m'
t='\e[0m'
echo
echo      "########################################"
echo -e "#$f Starting mongod servers for replicas $t#"
echo      "########################################"
echo 

DIR=$(dirname "${BASH_SOURCE[0]}")

#if [ "-j" == $1 ]; then
#	j=""
#else
#	j=" --nojournal"
#fi

svr="--configsvr"
n=0
mkdir -p $DIR/data/logs
for proc in conf sh1 sh2 sh3 sh4 sh5; do

for i in 1 2 3; 
do

echo
echo -e "#$f Mongod for $proc repl#$i $t#"
echo 
mkdir -p $DIR/data/$proc-$i
mongod $svr --replSet $proc --dbpath $DIR/data/$proc-$i --port 30$[$n]0$i --logpath $DIR/data/logs/$proc-$i.log --fork --quiet
echo -e "$f***$t"

done
svr="--shardsvr""$j"
n=$[$n+1]

done

