#!/bin/bash
# Written by Salavat Garifullin
#It returns the call data (session type, from, to, date of creation and completion) 
#using the phone number/numbers in the last 168 hours (7 days)

request_type='phones_time'
phone_ids=$(mongo asl --port 40000 --quiet --eval='db.sessions.findOne({created: {$gte: (new Date(new Date() - 24*3600*1000))}},{_id:0,from_:1}).from_')
over_last=168
request="request_type=$request_type&phone_ids=$phone_ids&over_last=$over_last"
echo $0$'\n'$request

echo $'\n'"Simple response"
echo $(curl "http://localhost:3467/?$request") | python -m json.tool # > $0.json

echo $'\n'"Verbose response"
echo $(curl "http://localhost:3467/?$request&verbose=1") | python -m json.tool # > $0_v.json
