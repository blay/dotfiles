#!/bin/bash

# How long is the ice artwork melting in miliseconds?
MELTING=$(expr 4 \* 60 \* 1000)

# How many moments is the melting captured into? (starts from 0)
MOMENTS=999

# How many images in each book?
IMAGES=5

# This gives the duration of a present.
PRESENT=$(expr $MELTING / $MOMENTS)

# Iterate over moments and perform the operations.
for j in $(seq 0 $MOMENTS)

do 
    # The time of the captured moment is the duration of a present times the moment number with three random decimals added.
    MOMENT=$(expr $PRESENT \* $j)ms
    # The number of books is the amount of moments divided by number of images  plus one since there is no book zero.
    BOOK=$(($j/$IMAGES+1))

    # If the moment is evenly divisible by the number of books, make a new book.
    if 
        [ $(( j % $IMAGES )) -eq 0 ]; then
            mkdir $BOOK
    fi

    # Capture a moment at the time of a present from the melting and place it in a book, named after the timestamp of its moment.
    ffmpeg -ss $MOMENT -i $1 -frames:v 1 $BOOK/$MOMENT.jpg
done
