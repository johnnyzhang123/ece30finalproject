#include "CurieTimerOne.h"

int SensorReading;
int AnalogPin = A0;
bool toggle = 0;
int t;
int to;
int n = 1;

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
    Serial.print(SensorReading);
    Serial.print("\t");
    Serial.println(t);
    n++;
    toggle = 0;
  }
}
