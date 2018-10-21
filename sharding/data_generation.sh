#!/bin/bash
# Written by Salavat Garifullin
# Generated documents for the DB (by default for 1000 call sessions)
# When you call the script, you can send the parameter 'number' (number of required sessions), e.g. "./data_generation.sh 2000"

f='\x1b[1;34m'
t='\e[0m'
echo
echo      "####################################"
echo -e "#$f Generating data for the database $t#"
echo      "####################################"
echo

DIR=$(dirname "${BASH_SOURCE[0]}")

export from to accounts sessions legs
from=0
to=0
accounts=''
session=''
legs=''

echo
echo -e "#$f Removing the old version of the data $t #"
echo
mkdir -p $DIR/import/
rm -f $DIR/import/*.json
echo -e "$f***$t"

echo
echo -e "#$f Generation of accounts $t #"
echo
. $DIR/utils/accounts.sh
num_of_acc=$[$[$to - $from + 1]/10]
echo $accounts > $DIR/import/accounts.json
echo "Generated $num_of_acc accounts"
[[ ! -z $1 ]] && (( $[$1] == 0 )) && echo -e $'\n'"Only accounts have been generated"$'\n'"$f***$t" && exit
echo -e "$f***$t"

(( ( $[$1] > 0 ) && ( n=$[$1] )     )) || (( n=1000 ))
(( ( $n > 100 )  && ( k=$[$n/100] ) )) || (( k=1 ))
(( ( $k == 1 )   && ( m=$n )        )) || (( m=100 ))

echo
echo -e "#$f Generation of sessions and legs $t #"
echo 
echo "Create $[$k*$m] call sessions and $[2*$k*$m] legs"
echo "Countdown..."
for i in $(eval echo {$k..1}); do
    echo $i
        for j in $(eval echo {1..$m}); do
            . $DIR/utils/calls.sh
            echo $sessions >> $DIR/import/sessions.json
	        echo $legs >> $DIR/import/legs.json
        done
    done
echo -e "$f***$t"
