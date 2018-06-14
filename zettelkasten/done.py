output = system.exec_command("date +%Y-%m-%d")
keyboard.send_keys("#DONE: completed:" + output)
