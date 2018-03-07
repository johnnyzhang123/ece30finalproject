from scipy import signal as sig
import numpy as np
import matplotlib.pyplot as plt

time = np.zeros(1000)
y = np.zeros(1000)
scaled = np.zeros(1000)

#original unfiltered scaled EMG signal
EMG_raw_data = open("EMG_raw_data.txt", 'r')
for i in range(1000):
	line = EMG_raw_data.readline()
	data = line.split("\t")
	time[i] = float(data[1])
	y[i] = float(data[0])
	scaled[i] = float(((3.3/1024)*y[i]-1.5)/3600)
# plt.plot(time,scaled)
# plt.xlabel("time")
# plt.ylabel("EMG_scaled_data")

#Welch plot to observe frequency signal
# frequency, power = sig.welch(scaled*1000, 200) 
# plt.subplot(412)
# plt.plot(frequency,power)
# plt.xlabel("frequency")
# plt.ylabel("welch_data")

#using just lowpass filter
b_low,a_low = sig.butter(3, 0.4, "lowpass")
signal_out_lowpass = sig.lfilter(b_low, a_low, scaled)
# plt.plot(time,signal_out_lowpass)
# plt.xlabel("time")
# plt.ylabel("lowpass_data")

#using just highpass filter
b_high,a_high = sig.butter(3, 0.4, "highpass")
signal_out_highpass = sig.lfilter(b_high, a_high, scaled)
# plt.subplot(414)
# plt.plot(time,signal_out_highpass)
# plt.xlabel("time")
# plt.ylabel("highpass_data")

#using both lowpass and highpass filters
signal_out_both = sig.lfilter(b_high, a_high, signal_out_lowpass)
# plt.plot(time,signal_out_both)
# plt.xlabel("time")
# plt.ylabel("highpass_n_lowpass_data")

#rectified signal, after using both lowpass and highpass filters
signal_out_rectified = abs(signal_out_both)
# plt.subplot(235)
# plt.plot(time,signal_out_rectified)
# plt.xlabel("time")
# plt.ylabel("rectified_data")

#smoothed signal using boxcar
box = sig.boxcar(100)
print(box)
signal_out_smoothed = sig.lfilter(box, 1, signal_out_rectified)
# plt.subplot(236)
plt.plot(time,signal_out_smoothed)
plt.xlabel("time")
plt.ylabel("smoothed_data")

#power spectral density estimation(welch)
frequency, power = sig.welch(signal_out_both*1000, 200) 
# plt.plot(frequency,power)
# plt.xlabel("frequency")
# plt.ylabel("power_spectral_density")

plt.show()
