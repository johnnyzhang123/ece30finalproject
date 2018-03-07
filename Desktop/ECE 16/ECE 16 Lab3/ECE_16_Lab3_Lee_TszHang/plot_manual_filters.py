from scipy import signal as sig
import numpy as np
import matplotlib.pyplot as plt

time = np.zeros(1000)
y = np.zeros(1000)
scaled = np.zeros(1000)
low = np.zeros(1000)
high = np.zeros(1000)
both = np.zeros(1000)

#original unfiltered scaled EMG signal
EMG_raw_data = open("EMG_raw_data.txt", 'r')
for i in range(1000):
	line = EMG_raw_data.readline()
	data = line.split("\t")
	time[i] = float(data[1])
	y[i] = float(data[0])
	scaled[i] = float(((3.3/1024)*y[i]-1.5)/3600)

#lowpass filtering
b_low,a_low = sig.butter(3, 0.4, "lowpass")
for n in range(1000):
	q = n-1
	w = n-2
	e = n-3
	if (q < 0):
		q = 0
	if (w < 0):
		w = 0
	if (e < 0):
		e = 0
	low[n] = b_low[0]*scaled[n] + b_low[1]*scaled[q] + b_low[2]*scaled[w] + b_low[3]*scaled[e] - a_low[1]*low[q] - a_low[2]*low[w] - a_low[3]*low[e]
plt.plot(time,low)
plt.xlabel("time")
plt.ylabel("lowpass_data")
plt.show()

#highpass filtering
b_high,a_high = sig.butter(3, 0.4, "highpass")
for n in range(1000):
	q = n-1
	w = n-2
	e = n-3
	if (q < 0):
		q = 0
	if (w < 0):
		w = 0
	if (e < 0):
		e = 0
	high[n] = b_high[0]*scaled[n] + b_high[1]*scaled[q] + b_high[2]*scaled[w] + b_high[3]*scaled[e] - a_high[1]*high[q] - a_high[2]*high[w] - a_high[3]*high[e]
# plt.plot(time,high)
# plt.xlabel("time")
# plt.ylabel("highpass_data")
# plt.show()



