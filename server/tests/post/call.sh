#!/bin/bash
# Written by Salavat Garifullin
#Generating of a call through the server between phone numbers 10, 11 belonging to the same account
#in the next day from the present.

# Functions:

post () {
echo $(curl -X POST --data @$@ http://localhost:3467/ --header "Content-Type:application/json")
}

create_session () {
local type=$1
local from_=$2
local oid="None"
local to_=$3
local date=$4
echo $'\n' 'create_session' $'\n' >&2
echo '{
"request_type": "create_session",
"session_type": "'$type'",
"from_": "'$from_'",
"to_": "'$to_'",
"created": {"$date": '$date'}
}' > $temp/session_$type.json
echo $(post $temp/session_$type.json)
}

create_leg () {
local num=$1
local oid=$2
local from_=$3
local to_=$4
local date=$5
echo $'\n' "create_leg_$num" $'\n' >&2
echo '{
"request_type": "create_leg",
"session_id": {"$oid": "'$oid'"},
"from_": "'$from_'",
"to_": "'$to_'",
"created": {"$date": '$date'}
}' > $temp/leg_$num.json
echo $(post $temp/leg_$num.json)
}

update () {
local type=$1
local oid=$2
local date=$3
echo $'\n''update_'$type$'\n' >&2
echo '{
"request_type": "update_'$type'",
"'$type'_id": {"$oid": "'$oid'"},
"terminated": {"$date": '$date'}
}' > $temp/$type.json
#echo $(post $temp/$type.json)
post $temp/$type.json
}

# universal create not finished
create () {
local type=$1
local call_or_oid=$2
local from_=$3
local to_=$4
local date=$5
echo $'\n' "create $type $call_or_oid" $'\n' >&2
echo '{
"request_type": "create_session",
"session_id": {"$oid": "'$call_or_oid'"},
"session_type": "'$call_or_oid'",
"from_": "'$from_'",
"to_": "'$to_'",
"created": {"$date": '$date'}
}' > $temp/$type_$call.json
echo $(post $temp/"$type"_"$call_or_oid".json)
}

# Main part:

DIR=$(dirname "${BASH_SOURCE[0]}")

mkdir -p $DIR/temp
temp=$DIR/temp

(( $[$from_] )) || (( from_=$(shuf -i 10-99 -n 1) ))
(( $[$to_] ))   || (( to_=$(shuf -i 10-99 -n 1) ))
(( $[$dt_] ))   || (( dt_=$(shuf -i 5000-3600000 -n 1) ))
(( $[$ago_] ))  || (( ago_=$[$(shuf -i 1-$[24*360] -n 1) *3600*1000] ))
created=$[$(date +%s)*1000 - $ago_]
terminated=$[$created + $dt_]

session_id=$(create_session call $from_ $to_ $created)
echo $'\n'"session_id $session_id"

leg_id_1=$(create_leg 1 $session_id $from_ -1 $created)
echo $'\n'"leg_id $leg_id_1"

leg_id_2=$(create_leg 2 $session_id -1 $to_ $created)
echo $'\n'"leg_id $leg_id_2"

update leg $leg_id_1 $terminated

update leg $leg_id_2 $terminated

update session $session_id $terminated

rm -rf $temp
