#!/bin/bash

case $1 in 
"completed")
d1=$(date +%Y-%m-%d -d "$2")
d2=$(date +%Y-%m-%d -d "$2+1 days")
d3=$(date +%Y-%m-%d -d "$2+2 days")
d4=$(date +%Y-%m-%d -d "$2+3 days")
d5=$(date +%Y-%m-%d -d "$2+4 days")
d6=$(date +%Y-%m-%d -d "$2+5 days")
d7=$(date +%Y-%m-%d -d "$2+6 days")

ag "completed\:($d1|$d2|$d3|$d4|$d5|$d6|$d7)"
;;
"created")
d1=$(date +%Y-%m-%d -d "$2")
d2=$(date +%Y-%m-%d -d "$2+1 days")
d3=$(date +%Y-%m-%d -d "$2+2 days")
d4=$(date +%Y-%m-%d -d "$2+3 days")
d5=$(date +%Y-%m-%d -d "$2+4 days")
d6=$(date +%Y-%m-%d -d "$2+5 days")
d7=$(date +%Y-%m-%d -d "$2+6 days")

ag "created\:($d1|$d2|$d3|$d4|$d5|$d6|$d7)"
;;
"agenda")
gcalcli agenda $2
;;
"notes")
find -newerct "$(date +%Y-%m-%d -d "$2")" ! -newerct "$(date +%Y-%m-%d -d "$2+6 days")" -printf '%Tc %p\n'|sort
;;
*) echo "wrong input"

esac