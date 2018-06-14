output = system.exec_command("date +%Y-%m-%d")
keyboard.send_keys("#FIX: created:" + output)
