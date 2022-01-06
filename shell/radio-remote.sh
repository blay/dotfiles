#!/bin/bash
station_names="
[1] NTS1
[2] NTS2
[3] Resonance.fm
[4] Radio Flouka
[5] Sub FM
[6] BBC 6
[0] Next Station
[+] Play
[-] Pause
"

pi="pi@192.168.0.7"

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
            echo Radio Flouka
            ssh $pi 'mpc play 4'
            ;;
        [5]* ) 
            clear
            echo Sub FM
            ssh $pi 'mpc play 5'
            ;;
        [6]* ) 
            clear
            echo BBC 6
            ssh $pi 'mpc play 6'
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
