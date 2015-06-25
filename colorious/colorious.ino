/*
  A template sketch for using the Bluetooth Bee (BT Bee) in your own app.

  This sketch does not setup the BT Bee, it only attempts
  to connect to the host.  Use the BTBee_setup sketch first to set
  defaults on the BT Bee you are using.  After setup, only inquiry is
  needed to initiate a BT connection as the sketch demonstrates.
  
  This sketch assumes that you are using:
    1. the Bluetooth Bee and XBee Shield
    2. pins 0/1 for RX/TX
    3. dip switches on the XBee Shield should be
       set right/right, to run the sketch

  Sequence for uploading a sketch that expects the BT Bee:
    1. Remove the BT Bee before uploading a sketch
    2. Upload the sketch
    3. Attach the BT Bee/XBee Shield
    4. Reset the Arduino
  
                          
  In this sketch, a test app runs which accepts
  characters from a terminal program:
    b returns 'connected' to the host
    h turns on LED on pin 13
    l turns off LED on pin 13
    
  This program was modified from the program found at
  http://garden.seeedstudio.com/index.php?title=Bluetooth_Bee:
    pins 0/1 are used for RX/TX instead of the NewSoftSerial library
  
  For reference: 
    Leds on BT Bee:
      blinking green = connected
      double-blink green = not connected
      green-red blinking = pairing/inquiring
    Leds on XBee Shield
      green = power
      red =connected
    
*/

#include <toneAC.h>

// Melody liberated from the toneMelody Arduino example sketch by Tom Igoe.
int melody[] = { 262, 196, 196, 220, 196, 0, 247, 262 };
int noteDurations[] = { 4, 8, 8, 4, 4, 4, 4, 4 };

int rPin = 2;
int gPin = 3;
int bPin = 4;
int bttn = 5;

int colors = 4;

int randCol = 0;

byte prevBttn = 0;

byte colorsArray[8][3] = {
  {0, 1, 1},
  {1, 0, 1},
  {1, 1, 0},
  {0, 0, 1},
  {1, 0, 0},
  {0, 1, 0},
  {1, 1, 1},
  {0, 0, 0}
};

int buttonPressed = 0;

// serial port
long DATARATE = 38400;  // default data rate for BT Bee

char inChar = 0;

void setup() {
  Serial.begin(DATARATE);

  // initiate bluetooth bee connection
  Serial.print("\r\n+INQ=1\r\n");
  delay(2000);   // wait for pairing

  pinMode(rPin, OUTPUT);  
  pinMode(gPin, OUTPUT);  
  pinMode(bPin, OUTPUT); 
  pinMode(bttn, INPUT);  
}

void playSound(){
  for (int thisNote = 0; thisNote < 8; thisNote++) {
    int noteDuration = 1000/noteDurations[thisNote];
    toneAC(melody[thisNote], 9, noteDuration, true); // Play thisNote at full volume for noteDuration in the background.
    delay(noteDuration * 4 / 3); // Wait while the tone plays in the background, plus another 33% delay between notes.
  }
}

void setSelectedColor(int col){
  digitalWrite(rPin, colorsArray[col][0]);
  digitalWrite(gPin, colorsArray[col][1]);
  digitalWrite(bPin, colorsArray[col][2]);
  playSound();
}

void setColor(){
  digitalWrite(rPin, colorsArray[(buttonPressed + randCol) % colors][0]);
  digitalWrite(gPin, colorsArray[(buttonPressed + randCol) % colors][1]);
  digitalWrite(bPin, colorsArray[(buttonPressed + randCol) % colors][2]);
  playSound();
}

void randomColor(){
  randCol = random(0, colors);
  setColor();
}

void nextColor(){
  buttonPressed++;  
  setColor();
}

byte checkBttn(){
  byte curBttn = digitalRead(bttn);
  byte check = 0;
  if (prevBttn != curBttn && curBttn == 1){
    check = 1;
  }
  prevBttn = curBttn;
  
  return check;
}

void setColor(char color){
  if(color == 'r'){
    setSelectedColor(0);
  }
  if(color == 'g'){
    setSelectedColor(1);
  }
  if(color == 'b'){
    setSelectedColor(2);
  }
  if(color == 'y'){
    setSelectedColor(3);
  }
  if(color == 'c'){
    setSelectedColor(4);
  }
  if(color == 'p'){
    setSelectedColor(5);
  }
  if(color == 'o'){
    setSelectedColor(6);
  }
  if(color == 'w'){
    setSelectedColor(7);
  }
}

void loop() {
  // test app:
  //   wait for character,
  //   b returns message, h=led on, l=led off
  if (Serial.available()) {
    inChar = Serial.read();
    if (inChar == 'r' || inChar == 'g' || inChar == 'b' || inChar == 'y' || inChar == 'c' || inChar == 'p' || inChar == 'o' || inChar == 'w'){
      setColor(inChar);  // test return connection
    }

    if (inChar == 'R') {
      randomColor();    // off
    }  
  }
  if(checkBttn() == 1){
    nextColor();
  }  
}
