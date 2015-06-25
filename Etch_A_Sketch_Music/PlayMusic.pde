import beads.*;
import java.util.Arrays; 
import java.util.Collections;

import javax.sound.sampled.*;

AudioContext ac;
int currentSound = 0;
ArrayList<String> samples = new ArrayList<String>();
long startTime = System.currentTimeMillis();
float curTime = 0;
int numberOfSongs = 0;
String song = "";
int durationMs = 0;

color fore = color(255, 102, 204);
color back = color(0,0,0);

void startMusicEngine() {
  ac = new AudioContext();
  samples.add("1.wav");
  samples.add("2.wav");
  samples.add("3.wav");
  samples.add("4.wav");
  samples.add("5.wav");
  samples.add("6.wav");
  samples.add("7.wav");
  Collections.shuffle(samples);
  numberOfSongs = new File(sketchPath("") + "/data/Audio").listFiles().length;
  song = "Song " + (int) (Math.floor(Math.random() * numberOfSongs));
  playNextSound();
}

/*void mouseClicked() {
  playNextSound();
}*/

float getCurRuntime(){
  println(curTime);
  return curTime;
}

void playNextSound(){
  if(currentSound < 7){
    fileSelected(samples.get(currentSound));
    currentSound++;
  }
}

void fileSelected(String wavName) {
  File selection = new File(sketchPath("") + "data/Audio/" + song + "/" + wavName);
  try{
    AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(selection);
    AudioFormat format = audioInputStream.getFormat();
    long frames = audioInputStream.getFrameLength();
    double durationInSeconds = frames / format.getFrameRate(); );
    durationMs = (int) Math.ceil(durationInSeconds * 1000);
    curTime = (int)((System.currentTimeMillis() - startTime) % (durationMs));
  } catch(Exception e){
    
  }
  
  String audioFileName = selection.getAbsolutePath();
  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
  player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS );
  Gain g = new Gain(ac, 2, 0.2);
  player.start(getCurRuntime() + (millis() - prevMillis));
  g.addInput(player);
  ac.out.addInput(g);
  ac.start();  
}

/*void draw() {
  loadPixels();
  //set the background
  Arrays.fill(pixels, back);
  //scan across the pixels
  for(int i = 0; i < width; i++) {
    //for each pixel work out where in the current audio buffer we are
    int buffIndex = i * ac.getBufferSize() / width;
    //then work out the pixel height of the audio data at that point
    int vOffset = (int)((1 + ac.out.getValue(0, buffIndex)) * height / 2);
    //draw into Processing's convenient 1-D array of pixels
    vOffset = min(vOffset, height);
    pixels[vOffset * height + i] = fore;
  }
  updatePixels();
}*/
