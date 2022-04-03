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

while :
do

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
        [3]* ) 
            clear
            echo Resonance.fm
            mpc play 3
            ;;
        [4]* ) 
            clear
            echo Radio Flouka
            mpc play 4
            ;;
        [5]* ) 
            clear
            echo Sub FM
            mpc play 5
            ;;
        [6]* ) 
            clear
            echo BBC 6
            mpc play 6
            ;;
        [0]* ) 
            clear
            echo Next
            mpc next
            ;;
        [+]* ) 
            clear
            echo "Playing: $(mpc current)"
            espeak "$(mpc current)"
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
