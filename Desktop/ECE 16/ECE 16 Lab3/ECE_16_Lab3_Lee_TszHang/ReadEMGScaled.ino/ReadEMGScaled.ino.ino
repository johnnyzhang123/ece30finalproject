#include "CurieTimerOne.h"

int SensorReading;
int AnalogPin = A0;
bool toggle = 0;
int t;
int to;
int n = 1;
float EMG_Voltage;

void setup() {
  Serial.begin(9600);
  while(!Serial);
  CurieTimerOne.start(5000, sample);
}

void sample(){
  SensorReading = analogRead(AnalogPin);
  toggle = 1;
}

void loop() {
  if(toggle){
    t = micros();
    if (n == 1) {
     to = t;
    }
    t = t - to;
    EMG_Voltage = ((3.3/1024)*SensorReading-1.5)/3600;
    Serial.print(EMG_Voltage,6);
    Serial.print("\t");
    Serial.println(t);
    n++;
    toggle = 0;
  }
}
