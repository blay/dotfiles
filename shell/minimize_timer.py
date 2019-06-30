#!/usr/bin/env python3
import subprocess
import sys
import time

def getwindowlist():
    # get windowlist
    try:
        return [
            l.split()[0] for l in \
            subprocess.check_output(["wmctrl", "-l"]).decode("utf-8")\
            .splitlines()
            ]
    except subprocess.CalledProcessError:
        pass

def getactive():
    # get active window, convert to hex for compatibility with wmctrl
    wid = str(hex(int(
        subprocess.check_output(["xdotool", "getactivewindow"])\
        .decode("utf-8"))))
    return wid[:2]+str((10-len(wid))*"0")+wid[2:]

# round down on 2 seconds (match needs to be exact)
minitime = (int(sys.argv[1])/2)*2

wlist1 = []
timerlist = []

while True:
    time.sleep(2)
    wlist2 = getwindowlist()
    if wlist2:
        # clean up previous windowlist; remove non- existent windows
        try:
            timerlist = [
                wcount for wcount in timerlist if wcount[0] in wlist2
                ]
        except IndexError:
            pass
        for w in wlist2:
            # add new windows, zero record
            if not w in wlist1:
                timerlist.append([w, 0])
        # add two to account(s)
        for item in timerlist:
            item[1] += 2
        active = getactive()
        for w in timerlist:
            # minimize windows that reach the threshold
            if w[1] == minitime:
                subprocess.Popen(["xdotool", "windowminimize", w[0]])
            # set acoount of active window to zero
            w[1] = 0 if w[0] == active else w[1]
        wlist1 = wlist2
