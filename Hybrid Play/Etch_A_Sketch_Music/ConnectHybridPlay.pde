/**
 * Many Serial Ports
 * 
 * Read data from the multiple Serial Ports
 */
 
//value: 128 - 383
//280 - 380

//IR: 250 - 500

import processing.serial.*;
import java.util.Arrays;

Serial[] myPorts = new Serial[2];  // Create a list of objects from Serial class
int[] dataIn = new int[2];         // a list to hold data from the serial ports

byte[] buffer0 = new byte[1024]; 
byte[] buffer1 = new byte[1024];

byte[] buffer0prev = new byte[1024];
byte[] buffer1prev = new byte[1024];

int bytePos0 = 0;
int bytePos1 = 0;

int accX0 = 0;
int accY0 = 0;
int accZ0 = 0;
int IR0 = 0;
int bat0 = 0;

int accX1 = 0;
int accY1 = 0;
int accZ1 = 0;
int IR1 = 0;
int bat1 = 0;

int startX0 = -2;
int startY0 = 0;
int startZ0 = 0;

int startX1 = -2;
int startY1 = 0;
int startZ1 = 0;

String direction0 = "None";
String direction1 = "None";

void connectHybridPlay()  {
  // print a list of the serial ports:
  printArray(Serial.list());
  // On my machine, the first and third ports in the list
  // were the serial ports that my microcontrollers were 
  // attached to.
  // Open whatever ports ares the ones you're using.

// get the ports' names:
  String portOne = Serial.list()[0];
  String portTwo = Serial.list()[2];
  // open the ports:
  myPorts[0] = new Serial(this, portOne, 115200);
  myPorts[1] = new Serial(this, portTwo, 115200);
}


/*void draw() {
  int drawScale = 40;
  // clear the screen:
  background(0);
  println(startX1);
  println(startX1 - accX1);
  println("--");
  println(startY1);
  println(startY1 - accY1);
  println("--");
  // use the latest byte from port 0 for the first circle
  fill(255, 0, 0);
  rect(width/3, height/2, drawScale, (startX0 - accX0));
  fill(0, 255, 0);
  rect(width/3 + drawScale, height/2, drawScale, (startY0 - accY0));
  fill(0, 0, 255);
  rect(width/3 + 2 * drawScale, height/2, drawScale, (startZ0 - accZ0));
  // use the latest byte from port 1 for the second circle
  fill(255, 0, 0);
  rect(2*width/3, height/2, drawScale, (startX1 - accX1));
  fill(0, 255, 0);
  rect(2*width/3 + drawScale, height/2, drawScale, (startY1 - accY1));
  fill(0, 0, 255);
  rect(2*width/3 + 2 * drawScale, height/2, drawScale, (startZ1 - accZ1));
}*/

/** 
  * When SerialEvent is generated, it'll also give you
  * the port that generated it.  Check that against a list
  * of the ports you know you opened to find out where
  * the data came from
*/

private int readArduinoBinary(byte least, byte most){
  int val = 0;

  //println("least: " + least + " most: " + most);

  val = least;
  val = (most * 256) + val;
  
  if(least == 0 && most == 0){
    val = 0;
  } 
  
  return val;
}

void serialEvent(Serial thisPort) {
  // variable to hold the number of the port:
  int portNumber = -1;
  
  // iterate over the list of ports opened, and match the 
  // one that generated this event:
  for (int p = 0; p < myPorts.length; p++) {
    if (thisPort == myPorts[p]) {
      portNumber = p;
    }
  }
  // read a byte from the port:
  byte inByte = (byte)thisPort.read();
  // put it in the list that holds the latest data from each port:
  dataIn[portNumber] = inByte;
  // tell us who sent what:
  //println("Got " + inByte + " from serial port " + portNumber);
  
  if(portNumber == 0){
    if(inByte == 'H'){
      buffer0 = new byte[1024];      
      bytePos0 = 0;
    }
    buffer0[bytePos0] = inByte;
    bytePos0 ++;
    if(inByte == 'F'){
      if(buffer0[1] > 256 || buffer0[2] > 3 || buffer0[3] > 256 || buffer0[4] > 3 || buffer0[5] > 256 || buffer0[6] > 3){
        buffer0 = buffer1prev.clone();        
      }
      accX0 = readArduinoBinary(buffer0[1], buffer0[2]);
      accY0 = readArduinoBinary(buffer0[3], buffer0[4]);
      accZ0 = readArduinoBinary(buffer0[5], buffer0[6]);
      IR0 = readArduinoBinary(buffer0[7], buffer0[8]);
      bat0 = readArduinoBinary(buffer0[9], buffer0[10]);

      if(accX0 > 380){
        accX0 = 380;
      }
      
      if(accX0 < 280){
        accX0 = 280;
      }

      if(accY0 > 380){
        accY0 = 380;
      }
      
      if(accY0 < 280){
        accY0 = 280;
      }

      if(accZ0 > 380){
        accZ0 = 380;
      }
      
      if(accZ0 < 280){
        accZ0 = 280;
      }      
      
      accX0 -= 280;
      accY0 -= 280;
      accZ0 -= 280;
      
      if(startX0 == -1){
        startX0 = accX0;
        startY0 = accY0;
        startZ0 = accZ0;
        
        if (direction0.equals("None")){
          if(startY0 == 0){
            direction0 = "Vertical";
          } else {
            direction0 = "Horizontal";        
          }
        }
      }
      
      //println("buffer0: " + "accX: " + accX0 + " accY: " + accY0 + " accZ: " + accZ0 + " IR: " + IR0 + " bat: " + bat0);
      buffer0prev = Arrays.copyOf(buffer0, buffer0.length);
    }    
  }
  if(portNumber == 1){
    if(inByte == 'H'){
      buffer1 = new byte[1024];      
      bytePos1 = 0;
    }
    buffer1[bytePos1] = inByte;
    bytePos1 ++;
    if(inByte == 'F'){
      if(buffer1[1] > 256 || buffer1[2] > 3 || buffer1[3] > 256 || buffer1[4] > 3 || buffer1[5] > 256 || buffer1[6] > 3){
        buffer1 = buffer1prev.clone();        
      }
      
      accX1 = readArduinoBinary(buffer1[1], buffer1[2]);
      accY1 = readArduinoBinary(buffer1[3], buffer1[4]);
      accZ1 = readArduinoBinary(buffer1[5], buffer1[6]);
      IR1 = readArduinoBinary(buffer1[7], buffer1[8]);
      bat1 = readArduinoBinary(buffer1[9], buffer1[10]);
      
      if(accX1 > 380){
        accX1 = 380;
      }
      
      if(accX1 < 280){
        accX1 = 280;
      }

      if(accY1 > 380){
        accY1 = 380;
      }
      
      if(accY1 < 280){
        accY1 = 280;
      }

      if(accZ1 > 380){
        accZ1 = 380;
      }
      
      if(accZ1 < 280){
        accZ1 = 280;
      }
      
      accX1 -= 280;
      accY1 -= 280;
      accZ1 -= 280;
      
      if(startX1 == -1){
        startX1 = accX1;
        startY1 = accY1;
        startZ1 = accZ1;
        
        if (direction1.equals("None")){
          if(startY1 == 0){
            direction1 = "Vertical";
          } else {
            direction1 = "Horizontal";        
          }
        }
      }
      
      //println("buffer1: " + "accX: " + accX1 + " accY: " + accY1 + " accZ: " + accZ1 + " IR: " + IR1 + " bat: " + bat1);      
      buffer1prev = Arrays.copyOf(buffer1, buffer1.length);
      
      if( startX0 == -2){
        startX0 = -1;
        startX1 = -1;
      }
      
      //println(direction0);
      //println(direction1);
    }    
  }  
}

/*
The following Wiring/Arduino code runs on both microcontrollers that
were used to send data to this sketch:

void setup()
{
  // start serial port at 9600 bps:
  Serial.begin(9600);
}

void loop() {
  // read analog input, divide by 4 to make the range 0-255:
  int analogValue = analogRead(0)/4; 
  Serial.write(analogValue);
  // pause for 10 milliseconds:
  delay(10);                 
}


*/
