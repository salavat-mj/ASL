#!/bin/bash
# Written by Salavat Garifullin
#It returns the call data (session type, from, to, date of creation and completion) 
#using the account id(for all numbers in the account) in the last 24 hours

from=$(mongo asl --port 40000 --quiet --eval='db.sessions.findOne({created: {$gte: (new Date(new Date() - 24*3600*1000))}},{_id:0,from_:1}).from_')
account_id=$(mongo asl --port 40000 --quiet --eval="db.accounts.findOne({phones: $from})._aid.valueOf()")
phones=$(mongo asl --port 40000 --quiet --eval="db.accounts.findOne({'_aid': ObjectId(\"$account_id\")}).phones")

request_type='phones_time'
account_id=$account_id
over_last=24
request="request_type=$request_type&account_id=$account_id&over_last=$over_last"
echo $0$'\n'$request

echo $'\n'"Simple response"
echo $(curl "http://localhost:3467/?$request") | python -m json.tool # > $0.json

echo $'\n'"Verbose response"
echo $(curl "http://localhost:3467/?$request&verbose=1") | python -m json.tool # > $0_v.json
