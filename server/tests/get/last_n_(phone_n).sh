#!/bin/bash
# Written by Salavat Garifullin
#It returns information (session type, from, to, date of creation and completion) about 24 last call  
#using the phone number

request_type='phone_n'
#phone_id=100
phone_id=$(mongo asl --port 40000 --quiet --eval='db.sessions.findOne({created: {$gte: (new Date(new Date() - 24*3600*1000))}},{_id:0,from_:1}).from_')
n=24
request="request_type=$request_type&phone_id=$phone_id&n=$n"
echo $0$'\n'$request

echo $'\n'"Simple response"
echo $(curl "http://localhost:3467/?$request") | python -m json.tool # > $0.json

echo $'\n'"Verbose response"
echo $(curl "http://localhost:3467/?$request&verbose=1") | python -m json.tool # > $0_v.json
