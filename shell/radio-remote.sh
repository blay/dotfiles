#!/bin/bash
station_names="
[1] NTS1
[2] NTS2
[3] Resonance.fm
[4] Rinse FM France
[5] Sub FM
[6] Radio Flouka
[7] BBC 6
[8] Radio Fume
[9] World Wide Radio
[0] Next Station
[+] Play
[-] Pause
"

pi="mypi-music"

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
        [3]* ) 
            clear
            echo Resonance.fm
            ssh $pi 'mpc play 3'
            ;;
        [4]* ) 
            clear
            echo Rinse FM
            ssh $pi 'mpc play 4'
            ;;
        [5]* ) 
            clear
            echo Sub FM
            ssh $pi 'mpc play 5'
            ;;
        [6]* ) 
            clear
            echo Radio Flouka
            ssh $pi 'mpc play 6'
            ;;
        [7]* ) 
            clear
            echo BBC 6
            ssh $pi 'mpc play 7'
            ;;
        [8]* ) 
            clear
            echo Radio Fume
            ssh $pi 'mpc play 8'
            ;;
        [9]* ) 
            clear
            echo World Wide Radio
            ssh $pi 'mpc play 9'
            ;;
        [0]* ) 
            clear
            echo Next
            ssh $pi 'mpc next'
            ;;
        [+]* ) 
            clear
            echo "Playing: $(ssh $pi 'mpc current')"
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
