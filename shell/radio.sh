#!/bin/bash
while :
do

station_names="
[1] NTS1
[2] NTS2
[0] Next Station
[+] Play
[-] Pause
"
printf "$station_names"
read -n1 -p "Select station: " station
    case $station in
        [1]* ) 
            clear
            echo NTS1
            mpc play 1
            ;;
        [2]* ) 
            clear
            echo NTS2
            mpc play 2
            ;;
        [0]* ) 
            clear
            echo Next
            mpc next
            ;;
        [+]* ) 
            clear
            echo Play
            mpc play
            ;;
        [-]* ) 
            clear
            echo Pause
            mpc pause
            ;;
        [Qq]* ) exit;;
         * ) echo "Please answer 1 or 2. ";;
    esac
done
