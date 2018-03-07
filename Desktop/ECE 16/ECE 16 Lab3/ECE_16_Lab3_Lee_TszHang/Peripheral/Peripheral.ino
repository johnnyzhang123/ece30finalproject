#include <CurieBLE.h>
#include <CurieIMU.h>
#include "CurieTimerOne.h"

// Global variables
volatile bool hasRead = false;   // toggle to print 
float ax, ay, az, gx, gy, gz;    // accel/gyro values 
int EMG_data;                    // EMG value
int EMG_data1;                   // EMG value1

//************************************** BLE Code ****************************************
//BLEPeripheral my_BLE_Periph;    
BLEService accel_service("ENG-A"); // BLE ACCEL Service                        
BLEService gyro_service("ENG-B");   // BLE GYRO Service                         
BLEService emg_service("ENG-C");     // BLE EMG Service                          
// Set up characteristics                                                                
// BLE Accelerometer Service Characteristics                                             
BLEFloatCharacteristic accel_characteristic_x("ENG-A1", BLERead | BLEWrite);       
BLEFloatCharacteristic accel_characteristic_y("ENG-A2", BLERead | BLEWrite);       
BLEFloatCharacteristic accel_characteristic_z("ENG-A3", BLERead | BLEWrite);       
// BLE Gyroscope Service Characteristics                                                 
BLEFloatCharacteristic gyro_characteristic_x("ENG-B1", BLERead | BLEWrite);        
BLEFloatCharacteristic gyro_characteristic_y("ENG-B2", BLERead | BLEWrite);        
BLEFloatCharacteristic gyro_characteristic_z("ENG-B3", BLERead | BLEWrite);        
// BLE EMG Service Characteristics                                                       
BLEIntCharacteristic emg_characteristic("ENG-C1", BLERead | BLEWrite);   
BLEIntCharacteristic emg1_characteristic("EMG-2", BLERead | BLEWrite);         
//****************************************************************************************

void setup() {
  // Establish Serial Connection
  Serial.begin(9600);
  // Wait for connection to establish
  while(!Serial);                   
  Serial.println("Serial Established.");
  // Initialize IMU
  CurieIMU.begin();
  CurieIMU.setGyroRange(250);
  CurieIMU.setAccelerometerRange(2);
  //Serial.println("IMU Initialized.");

  //**************************** BLE Code ****************************
  // Initiliaze the BLE hardware
  BLE.begin(); 
  // set advertised local name and service UUID:                     
  BLE.setLocalName("ECE-16-123 IMU and EMG");                         
  BLE.setAdvertisedServiceUuid(accel_service.uuid());    
  // add characteristics to services                                 
  accel_service.addCharacteristic(accel_characteristic_x);           
  accel_service.addCharacteristic(accel_characteristic_y);           
  accel_service.addCharacteristic(accel_characteristic_z);           
  gyro_service.addCharacteristic(gyro_characteristic_x);             
  gyro_service.addCharacteristic(gyro_characteristic_y);             
  gyro_service.addCharacteristic(gyro_characteristic_z);             
  emg_service.addCharacteristic(emg_characteristic);
  emg_service.addCharacteristic(emg1_characteristic);           
  // add service to peripheral                                       
  BLE.addService(accel_service);                           
  BLE.addService(gyro_service);                            
  BLE.addService(emg_service);                                          
  // set initial characteristic values                               
  accel_characteristic_x.writeFloat(float(0.0));                              
  accel_characteristic_y.writeFloat(float(0.0));                              
  accel_characteristic_z.writeFloat(float(0.0));                              
  gyro_characteristic_x.writeFloat(float(0.0));                               
  gyro_characteristic_y.writeFloat(float(0.0));                               
  gyro_characteristic_z.writeFloat(float(0.0));                               
  emg_characteristic.writeInt(0);
  emg1_characteristic.writeInt(0);         
  // BEGIN ADVERTISING THE BLE                                                       
  //Serial.println("BLE being advertised");   
  BLE.advertise();                         
  //******************************************************************

  // Start Interupt, at 10Hz
  CurieTimerOne.start(100000, &my_sample);            
  //Serial.println("Interupt Started.");
}

// loop() function used to establish and reestablish BLE connection
void loop() {
  //******************************* BLE Code *******************************
  // look for a BLE central to connect to
  BLEDevice central_BLE = BLE.central();
  // if connection established between Peripheral and Central
  if (central_BLE) {
    //Serial.print("Connected to central: ");
    // Stop advertising BLE
    BLE.stopAdvertise();
    //Serial.println("Stopped advertising BLE ");

    // while the Peripheral is still connected to Central, write data
    while (central_BLE.connected()) {
      // write to characteristics, if sampled
      if (hasRead) {
        accel_characteristic_x.writeFloat(ax);
        accel_characteristic_y.writeFloat(ay);
        accel_characteristic_z.writeFloat(az);
        gyro_characteristic_x.writeFloat(gx);
        gyro_characteristic_y.writeFloat(gy);
        gyro_characteristic_z.writeFloat(gz);
        emg_characteristic.writeInt(EMG_data);
        Serial.print(emg_characteristic.intValue());
        Serial.print("\t");
        emg1_characteristic.writeInt(EMG_data1);
        Serial.println(emg1_characteristic.intValue());
        hasRead = false;
      }
    }
    // When the central disconnects, print it out:
    //Serial.println("Disconnected from central");
    // Advertise BLE again
    //Serial.println("BLE being advertised");   
    BLE.advertise(); 
  }
  //************************************************************************
}


// Sampling function (ISR)
void my_sample(){
  // Sample Accel, Gyro, then EMG
  CurieIMU.readAccelerometerScaled(ax, ay, az);
  CurieIMU.readGyroScaled(gx, gy, gz);
  EMG_data = analogRead(A0);
  EMG_data1 = analogRead(A1);
  // Toggle print ON
  hasRead = true;
}

