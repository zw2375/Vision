/*
  Button Bluetooth MASTER

  Turns on and off a light emitting diode(LED) connected to digital pin 13,
  when pressing a pushbutton attached to pin 2.

  The circuit:
  - LED attached from pin 13 to ground
  - pushbutton attached to pin 2 from +5V
  - 10K resistor attached to pin 2 from ground

  - Note: on most Arduinos there is already an LED on the board
    attached to pin 13.

  created 2005
  by DojoDave <http://www.0j0.org>
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  http://www.arduino.cc/en/Tutorial/Button
*/
#include <SoftwareSerial.h>

SoftwareSerial mySerial(8, 7); // RX, TX

// constants won't change. They're used here to set pin numbers:
const int buttonPin = 2;     // the number of the pushbutton pin
const int ledPin = 13;
// variables will change:
int sensor1 = 0;         // variable for reading the pushbutton status
int previous1 = 0;
int displayed1 = 0;
void setup() {
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600); // Default communication rate of the Bluetooth module
  mySerial.begin(9600);
}

void loop() {
  //  if (Serial.available() > 0) { // Checks whether data is comming from the serial port
  //    // buttonState = Serial.read();
  //    mySerial.write(Serial.read());
  //  }// Reads the data from the serial port
  // Checks whether data is comming from the serial port
  sensor1 = digitalRead(buttonPin);
   // int sensor1 = digitalRead(2);
  if (sensor1 == 1 && previous1 == 0) 
   {
     displayed1 = 1 - displayed1;  
    }
    
    previous1 = sensor1;
 
// Reads the data from the serial port
  // read the state of the pushbutton value:

  Serial.println(sensor1);
  mySerial.println(displayed1);
  delay(100);
}

//  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
//  if (buttonState == HIGH) {
//    // turn LED on:
//    digitalWrite(ledPin, HIGH);
//  } else {
//    // turn LED off:
//    digitalWrite(ledPin, LOW);
//  }
//  Serial.println(buttonState);
//}
