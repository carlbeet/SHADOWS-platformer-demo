class EyeEnemy {

  PImage[] eyeguy = new PImage[4]; // eye guy image sequence
  PImage smushedR;
  PImage smushedL;

float rx;
float ry;
  float x;
  float y;
  int index;
  float speed;
  int direction; // -1 or 1
  boolean shoot;
  Player p;

  boolean bounce;
  boolean alive;

  EyeEnemy(float k, float j, int dir, Player sasha) { // load each new eyeenemy 
  //with image loops, direction towards sasha, position x,y
  // and alive boolean
    bounce = true;
    alive = true;
    shoot = false;
    direction = dir;
    p = sasha;

    for (int i = 0; i < 4; i ++) {
      String num = str(i + 1);
      if (direction == 1) {
      eyeguy[i] = loadImage("eyeguy" + num + ".png"); }
      else {
       eyeguy[i] = loadImage("eyeguyL" + num + ".png"); }
      
    } // load images into eyeguy array
    rx = k; // store initial position so that if he is killed, he will return to same spot after game is reloaded.
    ry = j;
    x = k;
    y = j;
    index = 0;
    //speed = 0.2; 
    
    smushedR  = loadImage("smushedR.png");
    smushedL = loadImage("smushedL.png");
  }

  void display() { // display: must be alive; increment index 
    if (alive){
      if (frameCount % 12 == 0) {
        index ++;
      }
    if (index % 4 == 3) {
      shoot = true;
    }
    // index % 4 will give us results 0-3, indexes of different images for the sprite loop
    else {
      shoot = false; }
    image(eyeguy[ index % 4 ], x + 300 - sasha.getX(), y); // sprite
    }
  }
  //getters and setters
  int getDirection() {
    return direction;
  }
  void setDirection (int k) {
    direction = k;
  }
  boolean getShoot() {
    return shoot;
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
    
void GetSmushed() { // smushed an
if (direction == 1) {
  image(smushedR, x + 300 - sasha.getX(), y);
}
  else {
  image(smushedL, x + 300 - sasha.getX(), y);
  }
  alive = false;
  x = 0;
  y = 0;
}

boolean GetAlive() { // is he alive? then display
  return alive;}
  
  //use in game reset: restore to default values
  void Restore() {
    alive = true;
    x = rx;
    y = ry;
    direction = -1;
  }
};
