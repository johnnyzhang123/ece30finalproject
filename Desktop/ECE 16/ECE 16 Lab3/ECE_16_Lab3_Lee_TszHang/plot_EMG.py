import numpy as np
import matplotlib.pyplot as plt

x = np.zeros(1000)
y = np.zeros(1000)
print("Please enter the Signal Mode, raw or scaled?")
mode = input()

if (mode == "raw"):
	name = "EMG_raw_data"
	name1 = "EMG_raw_data.txt"
	plt.ylabel("EMG_raw_data")
if (mode == "scaled"):
	name = "EMG_scaled_data"
	name1 = "EMG_scaled_data.txt"
	plt.ylabel("EMG_scaled_data")

name = open(name1, 'r')
for i in range(1000):
	line = name.readline()
	data = line.split("\t")
	x[i] = float(data[1])
	y[i] = float(data[0])
plt.plot(x,y)
plt.xlabel("time")
plt.show()
