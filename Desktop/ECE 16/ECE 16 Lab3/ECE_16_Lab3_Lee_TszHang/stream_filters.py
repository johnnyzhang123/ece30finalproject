import numpy as np
import matplotlib.pyplot as plt
import serial
arduino = serial.Serial("/dev/cu.usbmodem14111", 9600, timeout=.1)

times = np.zeros(1000)
values = np.zeros(1000)

def run_real_time():
	#need an intial plot for axis config
	plt.plot(times, values)
	for N in range(1000):
		line = arduino.readline().decode().rstrip("\n")
		data = line.split("\t")
		times[i] = float(data[1])
		values[i] = float(data[0])
	plt.ion()	#Turn on interactive plotting mode

	while(True):
		plt.pause(0.0001)		#wait before uddating figure
		grab_samples(N)			#grab N samples from Serial

		plt.cla()				#clear the figure axes
		plt.plot(times,values)	#plot the data