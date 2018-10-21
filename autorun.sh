#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")

g_echo () { echo -e "\x1b[1;32m$@\e[0m"; } # Green text
myecho () { echo $'\n#' $(g_echo $@) $'#\n'; }

echo "#################################################"
myecho "Automatic configuration of cluster components"
echo "#################################################"

myecho "stop_all.sh"
$DIR/sharding/stop_all.sh
g_echo "***\n" 

myecho "start_all.sh"
$DIR/sharding/start_all.sh
g_echo "***\n"

myecho "data_cleaning.sh"
$DIR/sharding/data_cleaning.sh
g_echo "***\n"

myecho "sharding/data_generation.sh $1"
$DIR/sharding/data_generation.sh $1
g_echo "***\n"

myecho "data_importing.sh"
$DIR/sharding/data_importing.sh
g_echo "***\n"

myecho "server.py"
$DIR/server/server.py
