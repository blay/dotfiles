#!/usr/bin/env python
import wnck
import gtk

screen = wnck.screen_get_default()

while gtk.events_pending():
    gtk.main_iteration()

windows = screen.get_windows()
active_app = screen.get_active_window().get_application()

for w in windows:
    if not w.get_application() == active_app:
        w.minimize()
