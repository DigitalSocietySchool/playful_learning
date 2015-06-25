# playful_learning
Developer: Dennis Reep<br/>

<b>Hybrid play</b><br/>
Hybrid play.zip -> The code for the Etsch a sketch game that use the Hybrid play to draw on the screen and starts music after you draw on a gameobject. <br/>
You need 2 hybrid play to play this game. (http://www.hybridplay.com/)<br/>
1. Connect the bluetooth devices to the computer. <br/>
2. Open the code in processing. <br/>
3. Turn on the Hybrid play devices. <br/>
4. Press play.  <br/>

<b>Colors Game</b> <br/>
Arduino bluetooth.rar -> The initialization for the first run of the Bluetooth Bee. It sets the name/password of the device and sets it to slave. Upload the sketch and run it once.<br/>
Arduino.zip -> The colors game arduino code. The code that can change the light of the RGB led and manages the bluetooth requests.<br/>
processing bluetooth interface.zip -> The Processing environment to control the bands through bluetooth requests through an interface.<br/>
You can run the program when you have at least 1 headband connected.<br/>
1. If you want to create a new headband, run the Arduino bluetooth code once on the new device to initialize.<br/>
2. Run the Arduino.zip code on the device.<br/>
3. Turn on the device and press the resetbutton.<br/>
4. (only on first run) Connect the devices through bluetooth. The password is 0000. (if you can't find them, repeat step 3.)<br/>
5. Open the processing bluetooth interface code in processing.<br/>
6. Press play when at least one device is connected to the computer.<br/>
7. Repeat step 3 if the band doesn't connect. <br/>
8. Use the interface to control the headbands.<br/>
9. If the interface doesn't react anymore, press stop and play in processing and look if all the bands are connected. If one isn't connected, try to find it by changing all the other headbands from color. Repeat step 3.


arduino Fio.txt -> The prices and urls for the devices needed to create a new headband.
mats.txt -> The prices and urls for the devices needed to create a mat/checkpoint.

breadboard.png/schematics.png -> the schematics for the bluetooth headbands.
