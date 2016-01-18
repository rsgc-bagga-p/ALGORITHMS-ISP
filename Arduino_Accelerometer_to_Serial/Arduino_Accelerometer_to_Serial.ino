/*
 * Created by: Puneet Singh Bagga
 * Purpose: Use an accelerometer with swift
 * Date: December 11th, 2015
*/
#include <Wire.h> //I2C library
#include <SparkFun_MMA8452Q.h> //Includes the accelerometer library
MMA8452Q accel;// assign the accelerometer a name
float average[15]; //keeps the average
float val; //the value sent through serial
void setup() { //loops once
  Serial.begin(9600); //starts serial
  accel.init(); //initializes the accelerometer
  Serial.flush();
}

void loop() { //iterates forever

  if (accel.available()) { //check if the accelerometer is available/working
    accel.read(); //read accelerometer values
    averageRead(); //prints the averaged values to serial
  }
}

void averageRead() { //reads the accelerometer values and sends out an average
  for (int i = 0; i < 15; i++) { // loops through the values and adds them to average array

    average[i] = accel.cx; //assigns values to average array

    val += average[i]; //adds the values to the val int
  }
  val = val / 15; //averages the value
  // float newVal = map(val, -1.00, 1.00, 0.00, 2.00); // maps the average to positive values
  //newVal = newVal * 250.00; // multiplies the value to canvas size

  Serial.print(val);
  Serial.print("|");
  delay(20);
}

