#!/bin/bash

# How long is the ice melting in miliseconds?
ICEMELTING=$(expr 4 \* 60 \* 1000)

# How many moments is the melting captured into?
MOMENTS=999

# How many images in each book?
IMAGES=5

# This gives the duration of a present.
PRESENT=$(expr $ICEMELTING / $MOMENTS)

# Iterate over moments and perform the operations.
for j in $(seq 0 $MOMENTS)

do 
    # The time of the captured moment is the duration of a present times the moment number with three random decimals added.
    MOMENT=$(expr $PRESENT \* $j)ms
# The future is the moment number divided by number of futures plus one since there is no future zero.
    BOOK=$(($j/$IMAGES+1))

    # If the moment is evenly divisble by the number of futures, make a new future.
    if 
        [ $(( j % $IMAGES )) -eq 0 ]; then
            mkdir $BOOK
    fi

    # Capture a moment at the time of a present from the ice melting and place it in its future, named after the timestamp of its moment.
    ffmpeg -ss $MOMENT -i $1 -frames:v 1 $BOOK/$MOMENT.jpg

# All operations are done, object has melted.
done
