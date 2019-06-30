#!/bin/bash

level=$(acpi -V | head -n 1 | awk '{print ($4)}' | sed 's/..$//')

if [ $level -lt '10' ]
then
		notify-send -u 'critical' -t 60000 'battery low'
fi

