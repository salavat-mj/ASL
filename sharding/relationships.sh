#!/bin/bash
# Written by Salavat Garifullin
# Establishing the relationship between replicas.

f='\x1b[1;34m'
t='\e[0m'
echo
echo      "##################################################"
echo -e "#$f Establishing the relationship between replicas $t#"
echo      "##################################################"
echo 

declare	-a N=('MinKey' 2 3 4 5 'MaxKey')
for i in {1..5}; do
shards="$shards"'sh.addShard("sh'$i'/localhost:30'$i'01,localhost:30'$i'02"); '
tags="$tags"'sh.addShardTag("sh'$i'", "tag'$i'"); '
range="$range"'sh.addTagRange("asl.legs",{"shkey":'${N[$i-1]}'},{"shkey":'${N[$i]}'},"tag'$i'"); '
done

#indexes='db.legs.ensureIndex({created: 1});'
indexes='db.sessions.ensureIndex({_sid: 1});
db.legs.ensureIndex({_sid: 1});
db.legs.ensureIndex({created: 1});'

zones='sh.enableSharding("asl");
sh.shardCollection("asl.sessions", {_sid: 1});
sh.shardCollection("asl.legs", {shkey: 1});'

echo
echo -e "#$f Shards $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval="$shards"
echo -e "$f***$t"

echo
echo -e "#$f Zones $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval="$zones"
echo -e "$f***$t"

echo
echo -e "#$f Indexes $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval="$indexes"
echo -e "$f***$t"

echo
echo -e "#$f Disable balancing $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval='sh.disableBalancing("asl.legs")'
echo -e "$f***$t"

echo
echo -e "#$f Tags $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval="$tags"
echo -e "$f***$t"

echo
echo -e "#$f Range $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval="$range"
echo -e "$f***$t"

echo
echo -e "#$f Enable balancing $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval='sh.enableBalancing("asl.legs")'
echo -e "$f***$t"

echo
echo -e "#$f Stats $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval='db.getSiblingDB("config").shards.find()'
echo -e "$f***$t"

#read -p "Press enter to continue..."
