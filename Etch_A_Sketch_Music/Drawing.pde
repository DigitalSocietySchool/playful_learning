boolean drawArcEfect = false;
boolean changeGameState = false;
boolean gameStateTriggered = true;
int timeStartDrawEfect = 0;
float ellipseR = 100.f;
PGraphics pg;
int loop = 1;
int gameState = 1;
int lockGameState = 0;
int x, y;
int delay = 0;
int colorArray[] = {0,0,0};

float paintSize = 1.5;

int circleSize = 100;
int timer = 900000000;

int prevMillis = millis();

PImage img;
PImage images[] = new PImage[4];
PImage bgImage;;

int imgIndex = 0;
float imgPause = 150;
float imgTimer = millis() + imgPause;

int spriteSet = (int)Math.round(Math.random());
int randomSprite = (int) (Math.round(Math.random() * 6)) + 1;


/*void setup(){
 size(600,600); 
 prevPlayerPositionX = width/2;
 prevPlayerPositionY = height/2;
 pg = createGraphics(600, 600);
}*/

void createBackground(){
  bgImage = loadImage("Visuals/Dots 0/background.png");
  bgImage.resize(screenWidth, screenHeight);
}

void createDots(){
  for (int i = 0 ; i < 4 ; i++){
    img = loadImage("Visuals/Dots " + spriteSet +"/dot" + randomSprite + "_" + (i + 1) + ".png");
    images[i] = img;  
  }
}

void setupDrawing(){
  createBackground();
  createDots();
  //img.width = circleSize * 10 / 5;
  //img.height = circleSize * 10 / 5;
  pg = createGraphics(screenWidth, screenHeight);
}

void resetStats(){
  timer = 900000000;
  x = (int)(Math.random() * (screenWidth / 2));
  y = (int)(Math.random() * (screenHeight / 2));
  print("Reset shit");
  pg.clear();
  clear();
  gameState = 1;
  currentSound = 0;
  ac.stop();
  ac = new AudioContext();
  startMusicEngine();
}

void startTimer(){
  //resetStats();
  timer = millis() + 10000;
}

void update(){ 
  if(timer < millis()){
    resetStats();
  }
  if(changeGameState && gameStateTriggered == false){
    gameStateTriggered = true;
    gameState++;
    changeGameState = false;
  }
  if (lockGameState == 0){
  switch(gameState){
    case 1:
     x = (screenWidth / 2) + (int)(Math.random() * (screenWidth / 2));
     y = (screenHeight / 2) + (int)(Math.random() * (screenHeight / 2));
     colorArray = new int[] {1,0,0};
      break;
    case 2:
     x = (screenWidth / 2) - (int)(Math.random() * (screenWidth / 2));
     y = (screenHeight / 2) + (int)(Math.random() * (screenHeight / 2));
     colorArray = new int[] {0,1,0};
      break;
    case 3:
     x = (screenWidth / 2) - (int)(Math.random() * (screenWidth / 2));
     y = (screenHeight / 2) - (int)(Math.random() * (screenHeight / 2));
     colorArray = new int[] {0,0,1};
      break;
    case 4:
     x = (screenWidth / 2) + (int)(Math.random() * (screenWidth / 2));
     y = (screenHeight / 2) - (int)(Math.random() * (screenHeight / 2));
     colorArray = new int[] {1,1,0};
      break;
    case 5:
     x = (screenWidth / 2) - (int)(Math.random() * (screenWidth / 2));
     y = (screenHeight / 2) - (int)(Math.random() * (screenHeight / 2));
     colorArray = new int[] {0,1,1};
      break;
    case 6:
     x = (screenWidth / 2) - (int)(Math.random() * (screenWidth / 2));
     y = (screenHeight / 2) + (int)(Math.random() * (screenHeight / 2));
     colorArray = new int[] {1,0,1};
      break;
    case 7:
     x = (int)(Math.random() * (screenWidth / 2));
     y = (int)(Math.random() * (screenHeight / 2));
     colorArray = new int[] {0,0,0};
      break;    
    case 8:
     x = (screenWidth * 2);
     y = (screenHeight * 2);
     colorArray = new int[] {1,0,0};
     startTimer();
      break;
    }  
    lockGameState = 1;
  }  
  prevMillis = millis();
}

void imgIndexUp(){
  if(imgTimer < millis()){    
    imgTimer = millis() + imgPause;
    imgIndex ++;
    imgIndex = imgIndex % 4;
  }
}


void draw(){
  if(direction0 == "Vertical"){
    playerPositionX += ((accZ0 - startZ0) * scale);
  }
  if(direction0 == "Horizontal"){
    playerPositionX += ((accZ0 - startZ0) * scale);
  }
 
  difX1 = Math.abs(prevX1 - accX1);
  difY1 = Math.abs(prevY1 - accY1);
  difZ1 = Math.abs(prevZ1 - accZ1);
 
 
  if(difX1 > 4 || difY1 > 4 || difZ1 > 4){  
    //println("X: " + difX1);
    //println("y: " + difY1);
    //println("Z: " + difZ1);       
    playerMovementY = -((difX1 + difY1 + difZ1) * scale / 2);
  } else {
    playerMovementY += scale / 4;  
  }
  
  playerPositionY += playerMovementY;
  
  if( playerMovementY > (scale * 10)){
    playerMovementY = (scale * 10);
  }

  if( playerMovementY < -(scale * 10)){
    playerMovementY = -(scale * 10);
  }
  
  //line(prevPlayerPositionX, prevPlayerPositionY, playerPositionX, playerPositionY);
  //stroke(0);
  
  if(playerPositionX > screenWidth){
    playerPositionX = screenWidth;
  }

  if(playerPositionX < 0){
    playerPositionX = 0;
  }
  
  if(playerPositionY > screenHeight){
    playerPositionY = 1;
  }

  if(playerPositionY < 0){
    playerPositionY = screenHeight - 1;
  }

  update();
  if (spriteSet == 0 ){
    background(bgImage);
  } else {
    background(200);
  }
  image(pg,0,0); //draw the lines
  
  //println("posX: " + playerPositionX);
  //println("posY: " + playerPositionY);
  
  
  //intersection with the circles
  if (circleLineIntersect(playerPositionX,playerPositionY,prevPlayerPositionX,prevPlayerPositionY, x, y, circleSize) == true && delay > 10 ) {
    delay = 0;
    playNextSound();
    drawArcEfect = true;
    gameStateTriggered = false; 
    timeStartDrawEfect = millis();
  }
  else {
    fill(0);
  }
  delay ++;

  if(drawArcEfect && timeStartDrawEfect+1000>millis()){
     fill(0,0,255,255-loop);
     if (loop < 255)loop = loop + 3;
     ellipse(x,y,ellipseR,ellipseR);
     ellipseR = ellipseR*1.01;     
     if (timeStartDrawEfect+10>millis()){
       lockGameState = 0;
     }
  }else{
    changeGameState = true;
    loop = 1;
    ellipseR = 100;
    drawArcEfect = false;
  }
  noStroke();
  fill(0);
  
  //ellipse(x, y, circleSize, circleSize);
  //img = images[imgIndex];
  //image(img, 0, 0);
  image(images[imgIndex], x - (images[imgIndex].width / 2), y - (images[imgIndex].height / 2));
  images[imgIndex].resize((int)(circleSize), (int)(circleSize));
  
  imgIndexUp();
   
//drawing the line
  pg.beginDraw();
  pg.strokeJoin(ROUND);
  float distance = dist(playerPositionX,playerPositionY,prevPlayerPositionX,prevPlayerPositionY);
  distance = distance *3;
  if (distance > 255){
    distance = 255;
  }
  //println(distance);
  pg.stroke(colorArray[0]*(255 - distance),colorArray[1]*255-distance,colorArray[2]*255 - distance, 255 - distance); //color and transparency
  pg.strokeWeight(distance * paintSize);
  pg.strokeCap(ROUND);
  
  pg.line(playerPositionX,playerPositionY,prevPlayerPositionX,prevPlayerPositionY);
   prevPlayerPositionX = playerPositionX;
   prevPlayerPositionY = playerPositionY;

   prevX1 = accX1;
   prevY1 = accY1;
   prevZ1 = accZ1;    
  pg.endDraw();

}


  
