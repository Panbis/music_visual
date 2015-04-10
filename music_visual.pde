import ddf.minim.*;
import ddf.minim.analysis.*;

// Objets pour analyser un son
Minim minim;
AudioPlayer player;
AudioMetaData meta;
BeatDetect beat;
// Rayon des divers cercles
int  r = 200;
float rad = 70;
//Permet de changer de geometrie
boolean pressed = false;
// Permet de generer un beat une fois sur deux
int tour =0;
void setup()
{
  size(displayWidth, displayHeight);
  minim = new Minim(this);
  player = minim.loadFile("2014_hit.mp3");
  meta = player.getMetaData();
  beat = new BeatDetect();
  // Lecture du fichier
  player.loop();
  //player.play();
  background(-1);
  cursor(CROSS);
}

void draw()
{ 
  int bsize = player.bufferSize();
  float t = map(mouseX, 0, width, 0, 1);
  beat.detect(player.mix);
  // Background
  fill(#1A1F18, 20);
  noStroke();
  rect(0, 0, width, height);
  // Translate l'origine au centre de l'image
  translate(width/2, height/2);
  noFill();
  // En cas de beat...
  if (beat.isOnset()) {
    rad = rad*1.5;
    // Genere un cercle de couleur aleatoire,
    fill(Rcolor(), Rcolor(),Rcolor());
    ellipse(0, 0, 2*rad, 2*rad);
    stroke(Rcolor(), Rcolor(),Rcolor());
    fill(255);
    // des arcs blancs,
    if (tour == 0) {
      arc (0, 0, 4*rad, 4*rad, 0, PI/36);
      arc (0, 0, 4*rad, 4*rad, PI/4, 5*PI/18);
      arc (0, 0, 4*rad, 4*rad, PI/2, 9.5*PI/18);
      arc (0, 0, 4*rad, 4*rad, 12.5*PI/18, 13*PI/18);
      arc (0, 0, 4*rad, 4*rad, PI, 18.5*PI/18);
      arc (0, 0, 4*rad, 4*rad, 22.5*PI/18, 23*PI/18);
      arc (0, 0, 4*rad, 4*rad, 27*PI/18, 27.5*PI/18);
      arc (0, 0, 4*rad, 4*rad, 31.5*PI/18, 16*PI/9);
      tour += 2;
    }
    else tour -=2;
    // et des lignes de couleurs aleatoires partant du centre
    for (int i = 0; i < bsize - 1; i+=5)
    {
      float x = cos(i*2*PI/bsize);
      float y = sin(i*2*PI/bsize);
      float x2 = (r*2.5 + player.left.get(i)*100)*cos(i*2*PI/bsize);
      float y2 = (r*2.5 + player.left.get(i)*100)*sin(i*2*PI/bsize);
      strokeWeight(2);
      line(x, y, x2, y2);
    }
  }
  else {
    rad = 70;
  }
  
  stroke(-1, 50);
  
  // Genere un cercle de lignes modifiables par les tampons
  for (int i = 0; i < bsize - 1; i+=5)
  {
    float x = (r*1.45)*cos(i*2*PI/bsize);
    float y = (r*1.45)*sin(i*2*PI/bsize);
    float x2 = (r*1.55 + player.left.get(i)*100)*cos(i*2*PI/bsize);
    float y2 = (r*1.55 + player.left.get(i)*100)*sin(i*2*PI/bsize);
    line(x, y, x2, y2);
  }
  beginShape();
  
  // Genere une forme d'ondes et des cercles liés aux tampons
  for (int i = 0; i < bsize; i+=30)
  {
    float x2 = (r*1.5 + player.left.get(i)*200)*cos(i*2*PI/bsize);
    float y2 = (r*1.5 + player.left.get(i)*200)*sin(i*2*PI/bsize);
    //Forme d'onde
    stroke(Rcolor(), Rcolor(),Rcolor());
    vertex(x2, y2);
    //Cercles ou rectangles rempli 
    strokeWeight(1);
    fill(Rcolor(), Rcolor(),Rcolor());
    if (!pressed) 
      ellipse(x2, y2, player.left.get(i)*(r*0.75),player.left.get(i)*(r*0.75));
    else 
      rect(x2, y2, player.left.get(i)*(r*0.75), player.left.get(i)*(r*0.75)); 
    if (!beat.isOnset()) {
      x2 = (r + player.left.get(i)*400)*cos(i*2*PI/bsize);
      y2 = (r + player.left.get(i)*400)*sin(i*2*PI/bsize);
    }
   }
   noFill();
   for (int i = 0; i < bsize; i+=30)
   {
      float x2 = (r + player.left.get(i)*400)*cos(i*2*PI/bsize);
      float y2 = (r + player.left.get(i)*400)*sin(i*2*PI/bsize);
      pushStyle();
      //Cercles ou rectangles rempli avec le beat ou pas
      stroke(-1);
      strokeWeight(1);
      if (beat.isOnset()) {
        fill (Rcolor(), Rcolor(), Rcolor());
        line(0,0, x2, y2);
      }
      else noFill();
      if (!pressed) 
        ellipse(x2, y2, player.left.get(i)*(r*1.5),player.left.get(i)*(r*1.5));
      else 
        rect(x2, y2, player.left.get(i)*(r*1.5),player.left.get(i)*(r*1.5));
      popStyle();
  }
  endShape();
}

// Booléen pour le plein ecran
boolean sketchFullScreen() {
  return true;
}

//Booleen en fonction de la souris
void mousePressed() {
  pressed = !pressed;
}

//Fonction liée aux touches Echap et s
void keyPressed() {
  if(key==' ')exit();
  if(key=='s')saveFrame("###.jpeg");
}

// Generateur de couleurs aleatoires
int Rcolor () {
  return (int)random (0, 255);
}
