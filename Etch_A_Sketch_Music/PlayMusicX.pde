import beads.*;
import javax.sound.sampled.*;

ArrayList<File> channels = new ArrayList<File>();
AudioContext audioContext;

ArrayList<SamplePlayer> musicPlayers = new ArrayList<SamplePlayer>();

void playAllMusic(){
  for(int i = 1 ; i < 7 ; i ++){
    File selection = new File(sketchPath("") + "data/Audio/" + song + "/" + i + ".wav");
    channels.add(selection);
    
    String audioFileName = channels.get(i - 1).getAbsolutePath();
    
    SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
    player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS );
    musicPlayers.add(player);
    
    Gain g = new Gain(ac, 2, 0.2);
    g.addInput(musicPlayers.get(i - 1));
    ac.out.addInput(g);
  }
  ac.start();
}
