#!/bin/bash
# Written by Salavat Garifullin
#It returns information (session type, from, to, date of creation and completion) 
#about call for the last 24 hours

request_type='time_only'
over_last=24
request="request_type=$request_type&over_last=$over_last"
echo $0$'\n'$request

echo $'\n'"Simple response"
echo $(curl "http://localhost:3467/?$request") | python -m json.tool # > $0.json

echo $'\n'"Verbose response"
echo $(curl "http://localhost:3467/?$request&verbose=1") | python -m json.tool # > $0_v.json
