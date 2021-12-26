#!/bin/bash
directory_names="
[1] Fiction
[2] Documentaries
[3] BJJ
[q] quit
"

pi="pi@192.168.0.9"
fiction="~/seagate/Movies/fiction/fiction"
documentaries="~/seagate/Movies/documentaries/documentaries"
bjj="~/seagate/bjj/bjj"

if [[ $1 = fiction ]]
then 
        ssh $pi "ls $fiction"
elif [[ $1 = documentaries ]]
then 
        ssh $pi "ls $documentaries"
elif [[ $1 = bjj ]]
then 
        ssh $pi "tree -L 2 $bjj"
else
while :
do

printf "$directory_names"
read -n1 -p "Select directory to list: " directory
    case $directory in
        [1]* )
            ssh $pi "ls $fiction"|less
            ;;
        [2]* )
            ssh $pi "ls $documentaries"|less
            ;;
        [3]* )
            ssh $pi "tree -L 2 $bjj"|less
            ;;
        [Qq]* ) exit;;
         * ) echo "Please answer 1 or 2. ";;
    esac
done
fi
