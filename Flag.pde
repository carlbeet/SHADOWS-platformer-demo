class Flag {
float x;
float y;
PImage fl;
Player p;

Flag() { 
  x = 8000;
  y = 500;
}
Flag(float x, float y, Player sasha) { // load flag with image, and position
  this.x = x;
  this.y = y;
  fl = loadImage("flag.png");
  p = sasha;
}

int getX() // x getter
{ return (int) x; }

void display(){ //display flag relative to sasha
 image(fl,  x + 500 - p.getX(), y);
}

}
