#!/bin/bash
# Written by Salavat Garifullin
# Configures the entire relationship

f='\x1b[1;34m'
t='\e[0m'
echo
echo      "####################################"
echo -e "#$f Enable mongod and mongos servers $t#"
echo      "####################################"
echo 

DIR=$(dirname "${BASH_SOURCE[0]}")


n=0
for proc in conf sh0 sh1 sh2 sh3 sh4; do

echo
echo -e "#$f Replicas for $proc $t#"
echo 
initiator="rs.initiate({_id:\"$proc\",members:[
{_id:0,host:\"localhost:30"$n"01\"},
{_id:1,host:\"localhost:30"$n"02\"},
{_id:2,host:\"localhost:30"$n"03\"$arbiter}]})"
mongo --port 30$[$n]01 --quiet --norc --eval="$initiator"
arbiter=", arbiterOnly:true"
n=$[$n+1]
echo -e "$f***$t"

done


echo
echo -e "#$f Mongos with replicas $t#"
echo 
mongos --configdb conf/localhost:30001,localhost:30002,localhost:30003 --port 40000 --fork --logpath $DIR/data/logs/mongos.log
echo -e "$f***$t"

s=30
echo
echo -e "#$f Please wait $s second $t#"
echo
echo "Countdown..."
for i in $(eval echo {$[$s]..1}); do
    echo $i
    sleep 1    
done
echo -e "$f***$t"
