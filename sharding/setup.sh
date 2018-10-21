# Written by Salavat Garifullin
# When you call the script, you can specify the parameters:
# -g - generate DB, by defaulе 5000 sessions
# -g 'number' - number of required sessions

f='\x1b[1;32m'
t='\e[0m'
echo
echo      "#################################################"
echo -e "#$f Automatic configuration of cluster components $t#"
echo      "#################################################"
echo 
DIR=$(dirname "${BASH_SOURCE[0]}")

echo
echo -e "#$f stop_all.sh $t#"
echo 
$DIR/stop_all.sh
echo -e "$f***$t"

echo
echo -e "#$f delete_all.sh $t#"
echo 
$DIR/delete_all.sh
echo -e "$f***$t"

echo
echo -e "#$f start_replicas.sh -j $t#"
echo 
$DIR/start_replicas.sh #-j  # to use profiling
echo -e "$f***$t"

echo
echo -e "#$f basis_of_shards.sh $t#"
echo 
$DIR/basis_of_shards.sh
echo -e "$f***$t"

echo
echo -e "#$f relationships.sh $t#"
echo 
$DIR/relationships.sh
echo -e "$f***$t"

exit

#if [[ "$1" > 0 ]] || [[ "$1" == 0 ]]; then
echo
echo -e "#$f data_generation.sh $1 $t#"
echo 
$DIR/data_generation.sh $1  #number of sessions
echo -e "$f***$t"    
#fi

echo
echo -e "#$f data_importing.sh $t#"
echo 
$DIR/data_importing.sh
echo -e "$f***$t"
