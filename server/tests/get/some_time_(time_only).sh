#!/bin/bash
# Written by Salavat Garifullin
#It returns the call data (session type, from, to, date of creation and completion) in a period of time from
#t to T (Unix time in milliseconds)

day=$[24*3600*1000]
now=$[$(date +%s)*1000]

request_type='time_only'
T=$[$now-$day]
t=$[$T-2*$day]
request="request_type=$request_type&t=$t&T=$T"
echo $0$'\n'$request

echo $'\n'"Simple response"
echo $(curl "http://localhost:3467/?$request") | python -m json.tool # > $0.json

echo $'\n'"Verbose response"
echo $(curl "http://localhost:3467/?$request&verbose=1") | python -m json.tool # > $0_v.json
