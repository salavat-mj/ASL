#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")

export from_ to_ dt_ ago_
hour=3600000

from_=10
to_=11
ago_=$[24*$hour]
$DIR/call.sh

exit

from_=10
to_=20
ago_=$[36*$hour]
$DIR/call.sh


from_=10
to_=11
ago_=$[24*$hour]
$DIR/call.sh


from_=10
to_=11
ago_=$[24*$hour]
$DIR/call.sh
