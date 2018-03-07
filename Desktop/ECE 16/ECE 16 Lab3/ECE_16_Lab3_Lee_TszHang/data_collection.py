import serial
arduino = serial.Serial("/dev/cu.usbmodem14111", 9600, timeout=.1)

print("Please enter the Signal Mode, raw or scaled?")
mode = input()
arduino.write(mode.encode("ascii"))

if (mode == "raw"):
	name = "EMG_raw_data.txt"
if (mode == "scaled"):
	name = "EMG_scaled_data.txt"

with open(name,"w") as EMG_file:
	while True:	
		# if (arduino.inWaiting()):
		for i in range(0, 1000):
			data_line = arduino.readline().decode().rstrip("\n")
			# print(data_line)
			EMG_file.write(data_line)
		print('done')
		break
arduino.close()


			