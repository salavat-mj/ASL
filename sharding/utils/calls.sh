#!/bin/bash
# Written by Mikova Valentina, Akchurin Roman and Salavat Garifullin
#Generating of a call for the one year for profiling.
#Possible phone numbers are 100-999. There are 5 shards. 
#Default shard borders from the 1st April 2017: 2 days, 2 weeks, 1 month, 4 months.

#'from' and 'to' exported from 'data_generation.sh' through 'accounts.sh'
(( $[$from] )) || (( from=10 ))
(( $[$to] ))   || (( to=99 ))

utils=$(dirname "${BASH_SOURCE[0]}")

now=$[$(date +%s)*1000]	# now

# For process "migration" you can specify how many hours have passed
#add=$[$[$2]*3600000] # the moment in "$2" hours in the future
#now=$[$now+$add]
day=$[24*3600*1000]
shkeys=($[$now-2*$day]
        $[$now-15*$day] 
        $[$now-32*$day] 
        $[$now-125*$day])

dt_min=$[5*1000]
dt_max=$[2*3600*1000]

year_ago=$[$now-370*$day]
date=$(shuf -i $year_ago-$now -n 1)
from_=$(shuf -i $from-$to -n 1)
to_=$(shuf -i $from-$to -n 1)
dt=$(shuf -i $dt_min-$dt_max -n 1)
terminated=$[$date+$dt]
delta=$[7*$day] # lag before update
date_ul=$[$terminated+$delta]
date_update=$(shuf -i $terminated-$date_ul -n 1)


(( ($date > ${shkeys[0]}) && (shkey=0) )) || 
(( ($date > ${shkeys[1]}) && (shkey=1) )) || 
(( ($date > ${shkeys[2]}) && (shkey=2) )) || 
(( ($date > ${shkeys[3]}) && (shkey=3) )) || 
                            ((shkey=4))

# for debug
# echo $shkey >> temp.temp
# echo $date >> date.temp

_sid1=$(shuf -i 100000000000-999999999999 -n 1)
_sid2=$(shuf -i 100000000000-999999999999 -n 1)
_lid1=$(shuf -i 100000000000-999999999999 -n 1)
_lid2=$(shuf -i 100000000000-999999999999 -n 1)
_lid3=$(shuf -i 100000000000-999999999999 -n 1)
_lid4=$(shuf -i 100000000000-999999999999 -n 1)

sessions='{
"_sid": {"$oid": "'$_sid1$_sid2'"},
"session_type": "call",
"created": {"$date": '$date'},
"updated": {"$date": '$date_update'},
"from_": '$from_',
"to_": '$to_',
"terminated": {"$date": '$terminated'}
}'

legs='{
"_lid": {"$oid": "'$_lid1$_lid2'"},
"created": {"$date": '$date'},
"updated": {"$date": '$date_update'},
"from_": '$from_',
"to_": -1,
"shkey": '$shkey',
"terminated": {"$date": '$terminated'},
"_sid": {"$oid": "'$_sid1$_sid2'"}
}
{
"_lid": {"$oid": "'$_lid3$_lid4'"},
"created": {"$date": '$date'},
"updated": {"$date": '$date_update'},
"from_": -1,
"to_": '$to_',
"shkey": '$shkey',
"terminated": {"$date": '$terminated'},
"_sid": {"$oid": "'$_sid1$_sid2'"}
}'
