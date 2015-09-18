import processing.serial.*;
import java.util.Arrays;
import java.util.Collections;

Serial[] myPorts = new Serial[10];

int lastTime = millis();
int trigger = 0;

int waitTime = 100;
int timer = millis();

Boolean konamiBool = false;
char[] konamiSequence = {38, 38, 40, 40, 37, 39, 37, 39, 'b', 'a'};
int konamiCounter = 0;

ArrayList<Integer> simonSaysSequence = new ArrayList<Integer>(); 
ArrayList<Integer> workingBands = new ArrayList<Integer>();
ArrayList<PImage> imgs = new ArrayList<PImage>();

Boolean init = false;

int phpDelay = 1234;
int phpTimer = millis();
int btnCount = 0;

long simonTimer = 0;
int simonDelay = 2000;
int simonPlayer;
int simonCounter = 0;

Boolean tagTimer = false;
int minTimer = 7;
int maxTimer = 21;
int curTagTimer = millis();

int curGamemode = 1;

void setup()  {
  size(800, 600);
  initialize();
  imgs.add(loadImage("img/var1.png"));
  imgs.add(loadImage("img/var2.png"));
  imgs.add(loadImage("img/var3.png"));
  simonSaysAdd();
}

void randomGameMode() {
  image(imgs.get((int)random(0, 3)), 0, 0, 800, 600);
}

void initialize() {
  //int noOfBands = 0;
  //Get all Serial ports on the computer.
  //printArray(Serial.list());  
  println("Connecting...");
  for(int i = 0 ; i < Serial.list().length ; i ++){
    //Try to connect to each headband.
    //if(i == 4 || i == 0 || i == 3 || i == 6 ){
    if(i == 1 || i == 2 || i == 5 || i == 7){
    //} else {
      println("Checking band " + i + "...");
      try {
        myPorts[i] = new Serial(this, Serial.list()[i], 115200);         
        println("Connection to band " + i + " established.");
        //noOfBands++;
        workingBands.add(i);
        //setRandom(i);
      } catch(Exception e){
        //Print error.
        println("Connection to band " + i + " failed");
      }
    }
  } 
  println("--\n" + workingBands.size() + " bands connected.");
  println("Initialization complete!\n--"); 
}

void setRandom(int band){
  char col = 'g';
  switch(floor(random(4))){
    case 0 : col = 'r'; break;
    case 1 : col = 'g'; break;
    case 2 : col = 'b'; break;
    case 3 : col = 'y'; break;
    default : col = 'g'; break;
  }
  myPorts[band].write(col);
}

void disco(){
  if(timer + waitTime < millis()){     
    setDisco();
    timer = millis();
  }
}

void setDisco(){     
  char col = 'x';
  
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(i)].write(col);  
  
    switch(floor(random(6))){
      case 0 : col = 'r'; break;
      case 1 : col = 'g'; break;
      case 2 : col = 'b'; break;
      case 3 : col = 'y'; break;
      case 4 : col = 'p'; break;
      case 5 : col = 'c'; break;     
      default : col = 'R'; break;
    }       
    myPorts[workingBands.get(i)].write(col); 
  }
}

void setAllRandom(){    
  curGamemode = 3;
  char col = 'x';
  
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(i)].write(col);  
  
    switch(floor(random(4))){
      case 0 : col = 'r'; break;
      case 1 : col = 'g'; break;
      case 2 : col = 'b'; break;
      case 3 : col = 'y'; break;
      default : col = 'R'; break;
    }       
    myPorts[workingBands.get(i)].write(col); 
  }
}

void drawSmiley(int x, int y){
  strokeWeight(8);
  fill(255, 255, 0);
  ellipse(x, y, 300, 300);
  fill(0, 0, 0);
  ellipse(x + 40, y - 50, 10, 50);
  ellipse(x - 40, y - 50, 10, 50);
  
  noFill();
  curve(x - 80, y - 400, x - 80, y + 30, x + 80, y + 30, x + 80, y - 400);
  arc(x - 100, y + 12, 50, 50, 0, PI / 2);
  arc(x + 100, y + 12, 50, 50, PI / 2, PI);
}

void bttnCheck(){
  try{
    if(phpTimer + phpDelay < millis()){
      phpTimer = millis();
      String [] response = loadStrings("https://oege.ie.hva.nl/~reep16/bttn/getcount.php");   
      if(btnCount != Integer.parseInt(response[0].substring(1).substring(0, response[0].length() - 3))){
        btnCount = Integer.parseInt(response[0].substring(1).substring(0, response[0].length() - 3));
        setAllRandom();
        println("'Big Red Button' triggered.");       
        //randomGameMode();
      }
    }
  } catch(Exception e){
    println("Connection to Button lost.");
  }
}

void drawInterface(){  
  init = true;
  int sizeTxt = 32;   
  //textSize(sizeTxt);
  textFont(createFont("Arial Bold", sizeTxt));
  
  fill(127, 127, 127, 255);
  //get rekt
  rect(0, 0, 800, 600);  
   
  fill(0, 123, 0, 100);
  rect(0, 0, 800, 600);
  
  //Very important script that creates the smileys in the background. Do not delete.
  drawSmiley(100, 400);  
  drawSmiley(400, 200);
  drawSmiley(500, 550);
  drawSmiley(800, 300);
  drawSmiley(50, 30);
   
  fill(0, 123, 0, 100);
  rect(0, 0, 800, 600);
  
  strokeWeight(4);  
  
  fill(0, 0, 0);
  rect(0, 0, 800, 40);  
  fill(255, 255, 255);
  text("><><><><><><><><><><><><><><><><><><><><><><><><>", 0, 28);
  stroke(255);
  line(0, 32, 800, 32);
  
  fill(0, 0, 0);
  stroke(0);
  rect(0, 600 - 40, 800, 40);  
  fill(255, 255, 255);
  text("><><><><><><><><><><><><><><><><><><><><><><><><>", 0, 600 - 5);
  stroke(255);
  line(0, 600 - 32, 800, 600 - 32);
  stroke(0);
 
  if(workingBands.size() > 0){
    fill(255, 255, 255);
    rect(20, 50, 550, (workingBands.size() * 120) + 20);
  }
  
  for(int i = 0 ; i < workingBands.size() ; i ++){
    fill(0, 0, 0);
    text(i + 1, 50, (110 * (i) - 20) + 150 + (sizeTxt / 2));  
    fill(255, 0, 0);
    rect(100, 100 + (110 * (i) - 15), 100, 100);
    fill(0, 255, 0);
    rect(210, 100 + (110 * (i) - 15), 100, 100);
    fill(0, 0, 255);
    rect(320, 100 + (110 * (i) - 15), 100, 100);
    fill(255, 255, 0);
    rect(430, 100 + (110 * (i) - 15), 100, 100);  
  }
  
  /*if(workingBands.size() > 0){
    fill(0, 0, 0);
    text("1", 50, 150 + (sizeTxt / 2));  
    fill(255,0,0);
    rect(100,100,100,100);
    fill(0,255,0);
    rect(210,100,100,100);
    fill(0,0,255);
    rect(320,100,100,100);
    fill(255,255,0);
    rect(430,100,100,100);
  }
  
  if(workingBands.size() > 1){
    fill(0, 0, 0);
    text("2", 50, 260 + (sizeTxt / 2));  
    fill(255,0,0);
    rect(100,210,100,100);
    fill(0,255,0);
    rect(210,210,100,100);
    fill(0,0,255);
    rect(320,210,100,100);
    fill(255,255,0);
    rect(430,210,100,100);
  }
  
  if(workingBands.size() > 2){
    fill(0, 0, 0);
    text("3", 50, 370 + (sizeTxt / 2));  
    fill(255,0,0);
    rect(100,320,100,100);
    fill(0,255,0);
    rect(210,320,100,100);
    fill(0,0,255);
    rect(320,320,100,100);
    fill(255,255,0);
    rect(430,320,100,100);
  }
  
  if(workingBands.size() > 3){
    fill(0, 0, 0);
    text("4", 50, 480 + (sizeTxt / 2));
    fill(255,0,0);
    rect(100,430,100,100);
    fill(0,255,0);
    rect(210,430,100,100);
    fill(0,0,255);
    rect(320,430,100,100);
    fill(255,255,0);
    rect(430,430,100,100);
  }*/
  
  fill(255, 255, 255);  
  rect(590, 50, 200, 500);
  //rect(590, 200, 200, 200);
  //rect(590, 350, 200, 200); 
  
  fill(0, 0, 0);
  text("4 Colors", 630, 90 + (sizeTxt / 2));
  text("1 Red", 630, 190 + (sizeTxt / 2));  
  text("Random", 630, 290 + (sizeTxt / 2));  
  text("2 Colors", 630, 390 + (sizeTxt / 2)); 
  text("2 Teams", 630, 490 + (sizeTxt / 2));   
}

void draw(){
  if(curTagTimer < millis() && tagTimer){
    resetTimer();
    switch(curGamemode){
      case 1 : oneRed(); break;
      case 2 : fourColors(); break;
      case 3 : setAllRandom(); break;
      case 4 : twoColors(); break;
      case 5 : twoTeams(); break;
      default : oneRed();
    }
  }
  
  if(simonTimer != 0){
    if(simonTimer + simonDelay < millis()){
      for(int i = 0 ; i < workingBands.size() ; i++){
        if(i != simonPlayer){ 
          myPorts[workingBands.get(i)].write('o');  
        }
      } 
      simonCounter++;
      simonTimer = millis();
      char simonCol = 'R';
      println(simonSaysSequence.size() + " "+ simonCounter);
      if(simonCounter == (simonSaysSequence.size())) {
          myPorts[workingBands.get(simonPlayer)].write('o'); 
          simonTimer = 0;
      } else {
        switch(simonSaysSequence.get(simonCounter)){
          case 0 : simonCol = 'r'; break;
          case 1 : simonCol = 'g'; break;
          case 2 : simonCol = 'b'; break;
          case 3 : simonCol = 'y'; break;
          default : simonCol = 'r';
        }
        //println(simonPlayer);
        //println(simonCol);
        myPorts[workingBands.get(simonPlayer)].write(simonCol);
      }
    }
  }
  
  bttnCheck();
  if(konamiBool){ 
    disco();
  }
  if(!init){
    drawInterface();
  }
}

void setColor(int band, char col) {
  try{
    myPorts[workingBands.get(band - 1)].write(col);
  } catch(Exception e){
    println("It's a feature!");
  }
}

void setAllColor(char col) {
  /*
  for(int i = 0 ; i < Serial.list().length ; i ++){
    if(blacklist[i] != 1){
        myPorts[i].write(col); 
    }      
  }*/
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(1)].write(col);    
  }
}

void fourColors() {
  curGamemode = 2;
  ArrayList<Integer> on = new ArrayList<Integer>();
  on.add(0);
  on.add(1);
  on.add(2);
  on.add(3);
  
  Collections.shuffle(on);
  
  println(on.size());
  
  myPorts[workingBands.get(on.get(0))].write('r'); 
  myPorts[workingBands.get(on.get(1))].write('g'); 
  myPorts[workingBands.get(on.get(2))].write('b'); 
  myPorts[workingBands.get(on.get(3))].write('y'); 
  
  /*int on = (int)(Math.random() * workingBands.size());
  for(int i = 0 ; i < workingBands.size() ; i++){
    if(on != i){
      myPorts[workingBands.get(i)].write('o');   
    } else {
      myPorts[workingBands.get(i)].write('g');  
    }
  } */ 
}

void killAll() {
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(i)].write('o');
  }
}

void allRed() {
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(i)].write('r');
  }
}

void allGreen() {
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(i)].write('g');
  }
}

void allBlue() {
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(i)].write('b');
  }
}

void allYellow() {
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(i)].write('y');
  }
}

void allPink() {
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(i)].write('p');
  }
}

void allCyan() {
  for(int i = 0 ; i < workingBands.size() ; i++){
    myPorts[workingBands.get(i)].write('c');
  }
}

void oneRed() {
  curGamemode = 1;
  int on = (int)(Math.random() * workingBands.size());
  for(int i = 0 ; i < workingBands.size() ; i++){
    if(on != i){
      myPorts[workingBands.get(i)].write('g');   
    } else {
      myPorts[workingBands.get(i)].write('r');  
    }
  }   
}

int getRandCol() {
  int randCol = (int)random(4);
  if(randCol == workingBands.get(workingBands.size() - 1)){
    randCol = getRandCol();
  }
  return randCol;
}

void simonSaysAdd() {
  int randColor = getRandCol();
  simonSaysSequence.add(randColor);
  simonPlayer = (int)random(workingBands.size());
  simonCounter = 0;
}

void simonSaysPlay() {
  simonTimer = millis();
  simonCounter = 0;
}

void simonSaysReset() {
  simonSaysSequence.clear();
  simonSaysAdd();  
}

void twoColors() {
  curGamemode = 4;
  for(int i = 0 ; i < workingBands.size() ; i++){
    int on = (int) (Math.random() * 2);
    if(on != 0){
      myPorts[workingBands.get(i)].write('g');   
    } else {
      myPorts[workingBands.get(i)].write('r');  
    }
  }   
}

void twoTeams() {
  curGamemode = 5;
  ArrayList<Integer> players = new ArrayList<Integer>();
  for(int i = 0 ; i < workingBands.size() ; i++){
    players.add(i);
  }
  
  Collections.shuffle(players);
  
  for(int i = 0 ; i < workingBands.size() ; i++){  
    if(i % 2 == 0){
      println(i);
      myPorts[workingBands.get(players.get(i))].write('r'); 
    } else {
      myPorts[workingBands.get(players.get(i))].write('g');       
    }    
  } 
}

void mousePressed() {
  try{
    drawInterface();
    int mousePosX = mouseX;
    int mousePosY = mouseY;
    
    int changeBand = 0;
    char changeCol = 'h';
    
    if (mousePosX > 100 && mousePosX < 200){
      changeCol = 'r';
    }
    if (mousePosX > 210 && mousePosX < 310){
      changeCol = 'g';
    }
    if (mousePosX > 320 && mousePosX < 420){
      changeCol = 'b';
    }
    if (mousePosX > 430 && mousePosX < 530){
      changeCol = 'y';
    }   
    
    if (mousePosY > 100 && mousePosY < 200){
      changeBand = 1;
    }
    if (mousePosY > 210 && mousePosY < 310){
      changeBand = 2;
    }
    if (mousePosY > 320 && mousePosY < 420){
      changeBand = 3;
    }
    if (mousePosY > 430 && mousePosY < 530){
      changeBand = 4;
    }    
     
    if(mousePosX > 560 && mousePosX < 760){
      //4 Colors
      if(mousePosY > 50 && mousePosY < 150){
        fourColors();
      }
      //1 Red
      if(mousePosY > 150 && mousePosY < 250){
        oneRed();
      }    
      //Random 
      if(mousePosY > 250 && mousePosY < 350){
        setAllRandom();   
        //randomGameMode();
      }
      //2 Colors
      if(mousePosY > 350 && mousePosY < 450){
        twoColors();
      }    
      //2 Teams
      if(mousePosY > 450 && mousePosY < 550){
        twoTeams();
      }    
    } else {
      setColor(changeBand, changeCol);
    }
  } catch(Exception e){
    
  }
}

void resetTimer(){
  curTagTimer = millis() + (minTimer * 1000) + ((int)random(maxTimer - minTimer) * 1000);
}

void enableTimer() {
  if(tagTimer){
    tagTimer = false;
  } else{
    tagTimer = true;
  }
  println("timer enabled: " + tagTimer);
  resetTimer();
}

void keyPressed() {
  //add Simon
  if (key == 'a'){
    simonSaysAdd();
  }
  //play Simon
  if (key == 's'){
    simonSaysPlay();
  }  
  if (key == 'r'){
    simonSaysReset();
  }
  if (key == 'r'){
    enableTimer();
  }
  if (key == 'o'){
    killAll();
  }
  if (key == '1'){
    allRed();
  }
  if (key == '2'){
    allGreen();
  }
  if (key == '3'){
    allBlue();
  }
  if (key == '4'){
    allYellow();
  }
  if (key == '5'){
    allPink();
  }
  if (key == '6'){
    allCyan();
  }
  
  if (key == CODED) {
    if(konamiSequence[konamiCounter] == keyCode){
      konamiCounter ++;
    } else{
      konamiCounter = 0;
    }
  } else{
    if(konamiSequence[konamiCounter] == key){
      konamiCounter ++;
    } else{
      konamiCounter = 0;
    }
    if(konamiCounter > 9){
      println("Konami Code triggered!");
      if(!konamiBool){
        konamiBool = true;
      } else {      
        konamiBool = false;
      }
      konamiCounter = 0;
    }
  }
}

/*
void setup()  {
  try {
    size(800, 600);
    printArray(Serial.list());  
      for(int i = 0 ; i < Serial.list().length - 1 ; i ++){
      println(i);
      myPorts[i] = new Serial(this, Serial.list()[i], 115200);
      myPorts[i].write('h');
    }    
    lastTime = millis();
  } catch(Exception e){
      println(e);
  }
  println(1234);
}

void triggerLight(){
  for(int i = 0 ; i < myPorts.length ; i ++){
    if(trigger % 2 == 0){
      myPorts[i].write('h');
      println("h");
    } else {
      myPorts[i].write('l');    
      println("l");
    }
  }   
  trigger ++;
  lastTime = millis();
}

void draw() {
  println(delay + lastTime);
  if ((delay + lastTime) > millis()){
    triggerLight();
  }
}*/

