#!/bin/bash
export XAUTHORITY=/home/svartfax/.Xauthority
export DISPLAY=:0.0

DISP_ID=eDP-1

# Get the current software brightness from xrandr. 
OLED_BR=`xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '`

# Get brightness from "backlight" (which gets adjusted by the window
# manager, but does nothing for an OLED display; we do this second,
# so that there has been time to adjust it).
BACKLIGHT="/sys/class/backlight/intel_backlight"
BRIGHTNESS=$(cat $BACKLIGHT/brightness)
MAX_BRIGHTNESS=$(cat $BACKLIGHT/max_brightness)

# Adjust current to desired brightness in 5 steps, using rounded percentages.
CURRENT=`LC_ALL=C /usr/bin/printf "%.*f" 2 $OLED_BR`
DESIRED=`echo "scale=2; $BRIGHTNESS / $MAX_BRIGHTNESS" | bc`
for I in {1..5..1}; do
    brightness=`echo "scale=2; $CURRENT + $I/5*($DESIRED-$CURRENT)" | bc`
    xrandr --output $DISP_ID --brightness $brightness 2>&1 >/dev/null | logger -t oled-brightness
done
