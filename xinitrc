DEFAULT_SESSION=dwm

case $1 in
dwm)
    /usr/bin/feh --bg-scale /home/svartfax/images/bigcitylife_1280x800.jpg &
    exec dwm
        ;;
openbox)
    exec openbox-session
        ;;
*)
    exec $DEFAULT_SESSION
        ;;
esac

