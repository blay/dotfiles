import serial
import time

ser = serial.Serial('/dev/tty.usbmodem411', 38400, timeout=1)

feed = 10


file = open("test", "r")
 
for line in file:
        
	ser.write(line)
	time.sleep(0.5)

ser.write(chr(feed))
ser.write(chr(feed))

file.close()
