#!/bin/sh

case "$1" in
    --toggle)
        if [ "$(pgrep dropbox)" ]; then
            pkill -f dropbox
        else
            dropbox &
        fi
        ;;
    *)
        if [ "$(pgrep dropbox)" ]; then
            echo "Y"
        else
            echo "N"
        fi
        ;;
esac

