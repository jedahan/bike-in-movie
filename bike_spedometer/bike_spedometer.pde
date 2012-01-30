import oscP5.*;
import netP5.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

long edge = 400;
long reading = 0;
boolean high = false;

int photoPin = 2;

OscP5 oscP5;
NetAddress myRemoteLocation;
OscMessage message;
float frequency=0;
float lastFrequency=60;
long lastButtonPressTime;

void setup() {
  size(100, 100);
  
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(photoPin, Arduino.INPUT);
    
  frameRate(30);
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  message = new OscMessage("/setup");
  message.add(100);
  oscP5.send(message, myRemoteLocation); 
}


void draw() {
  background(0);

  oscP5.send(message, myRemoteLocation); 

  int reading = arduino.analogRead(photoPin);
  //println(reading);
  
  if ( reading > edge ) {
    high = true;
  } else {
    if ( high ) {
      // FALLING EDGE
      high = false;
      println(1010101);
      // CLICK
      frequency = 60000 /(millis() - lastButtonPressTime);
      lastButtonPressTime = millis();
      if(frequency != lastFrequency) {
        println(frequency);
        message = new OscMessage("/speed");
        message.add(frequency/60.000);
        oscP5.send(message, myRemoteLocation);
        lastFrequency = frequency;
      }
    }
  }
}
