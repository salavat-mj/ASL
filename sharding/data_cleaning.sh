#!/bin/bash
# Written by Salavat Garifullin
# Removes old data, without consequences for the cluster

f='\x1b[1;34m'
t='\e[0m'
echo
echo      "#####################"
echo -e "#$f Database cleanup $t#"
echo      "#####################"
echo 
echo
echo -e "#$f Cleaning accounts $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval="db.accounts.remove({});"
echo -e "$f***$t"
echo
echo -e "#$f Cleaning sessions $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval="db.sessions.remove({})"
echo -e "$f***$t"
echo
echo -e "#$f Cleaning legs $t#"
echo 
mongo asl --port 40000 --quiet --norc --eval="db.legs.remove({})"
echo -e "$f***$t"
