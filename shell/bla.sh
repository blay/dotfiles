#!/bin/bash

y=aa
num=$(ls -l out?*.txt| grep ^- | wc -l)
echo $num
for i in $(seq 0 $num)
do

    y=$(perl -E 'print ++$ARGV[0]' $y)
    echo $y
done