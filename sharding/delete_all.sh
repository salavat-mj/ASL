#!/bin/bash
# Written by Salavat Garifullin
# Completely removes the entire cluster (should be disabled)
DIR=$(dirname "${BASH_SOURCE[0]}")

f='\x1b[1;34m'
t='\e[0m'
echo
echo      "##################################"
echo -e "#$f Deleting the cluster with data $t#"
echo      "##################################"
echo 

echo
echo -e "#$f rm -rf ./data/ $t#"
echo 
rm -rf $DIR/data/
echo -e "$f***$t"

#mkdir -p $DIR/data/logs/

