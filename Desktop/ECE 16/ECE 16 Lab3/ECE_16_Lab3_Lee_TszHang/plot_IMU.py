import numpy as np
import matplotlib.pyplot as plt

x = np.zeros(1000)
y = np.zeros(1000)
z = np.zeros(1000)
print("Please enter the Mode, accel or gyro?")
mode = input()

if (mode == "accel"):
	name = "accel_output"
	name1 = "accel_output.txt"
	plt.ylabel("accel_data")
if (mode == "gyro"):
	name = "gyro_output"
	name1 = "gyro_output.txt"
	plt.ylabel("gyro_data")

name = open(name1, 'r')
for i in range(1000):
	line = name.readline()
	data = line.split("\t")
	t[i] = float(data[3])
	x[i] = float(data[0])
	y[i] = float(data[1])
	z[i] = float(data[2])
plt.subplot(1,3,1)
plt.plot(x,t)
plt.subplot(1,3,2)
plt.plot(y,t)
plt.subplot(1,3,3)
plt.plot(z,t)
plt.xlabel("time")
plt.show()