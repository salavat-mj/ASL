#!/bin/bash
# Written by Salavat Garifullin
# Shard borders are set by time intervals:
b1=$[2*24*3600*1000]	# 2 days
b2=$[14*24*3600*1000]	# 2 weeks
b3=$[30*24*3600*1000]	# 1 month
b4=$[120*24*3600*1000]	# 4 months

now=$[$(date +%s)*1000]	# now


# For process "migration" you can specify how many hours have passed
add=$[$[$2]*3600000] # the moment in "$2" hours in the future
now=$[$now+$add]
sh0=$[$now-$b1]
sh1=$[$now-$b2]
sh2=$[$now-$b3]
sh3=$[$now-$b4]

echo $now $sh1 $sh2 $sh3 $sh4
