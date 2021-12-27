#!/bin/bash
station_names="
[1] NTS1
[2] NTS2
[0] Next Station
[+] Play
[-] Pause
"

pi="pi@192.168.0.9"

while :
do

printf "$station_names"
read -n1 -p "Select station: " station
    case $station in
        [1]* ) 
            clear
            echo NTS1
            ssh $pi 'mpc play 1'
            ;;
        [2]* ) 
            clear
            echo NTS2
            ssh $pi 'mpc play 2'
            ;;
        [0]* ) 
            clear
            echo Next
            ssh $pi 'mpc next'
            ;;
        [+]* ) 
            clear
            echo "Playing: $(ssh pi 'mpc current')"
            ssh $pi 'espeak "$(mpc current)"'
            ssh $pi 'mpc play'
            ;;
        [-]* ) 
            clear
            echo Pause
            ssh $pi 'mpc pause'
            ;;
        [Qq]* ) exit;;
         * ) echo "Please answer 1 or 2. ";;
    esac
done
