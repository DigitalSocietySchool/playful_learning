/*
  One-time setup for a new Bluetooth Bee (BT Bee).
  Only inquiry should be needed to connect after setup.
  
  This sketch assumes that you are using:
    1. the BT Bee and XBee Shield
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
    a returns 'connected' to the host
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

// serial port
long DATARATE = 38400;  // default data rate for BT Bee

char inChar = 0;
int  LED = 13;   // Pin 13 is connected to a LED on many Arduinos

void setup() {

  Serial.begin(DATARATE);

  // bluetooth bee setup
  Serial.print("\r\n+STWMOD=0\r\n");     // set to slave
  delay(1000);
  Serial.print("\r\n+STNA=Korg M1\r\n");     // DSC = digital setting circles
  delay(1000);
  Serial.print("\r\n+STAUTO=0\r\n");     // don't permit auto-connect
  delay(1000);
  Serial.print("\r\n+STOAUT=1\r\n");     // existing default
  delay(1000);
  Serial.print("\r\n +STPIN=0000\r\n");  // existing default
  delay(2000);  // required

  // initiate BTBee connection
  Serial.print("\r\n+INQ=1\r\n");
  delay(2000);   // wait for pairing

  pinMode(LED, OUTPUT);
}

void loop() {

  // test app:
  //   wait for character,
  //   a returns message, h=led on, l=led off
  if (Serial.available()) {
    inChar = Serial.read();

    if (inChar == 'a') {
      Serial.print("connected");  // test return connection
    }

    if (inChar == 'h') {
      digitalWrite(LED, HIGH);   // on
    }

    if (inChar == 'l') {
      digitalWrite(LED, LOW);    // off
    }

  }

}
