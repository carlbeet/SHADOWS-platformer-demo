// types of projectiles
// 1. eye guy, just straight out in direction of orientation
// 2. royce, playertrace

class Projectile { 
float x;
float y;
float x1, y1;
float vx;
float vy;
int size; // diameter
int dir;
boolean shot;
boolean moving;


Projectile(EyeEnemy e) { // sets up bullet position and speed, moving = true so it will display.

  dir = e.getDirection(); // - 1 is left, 1 is right
  vx = 2*dir;
  vy = 0;  
  x = e.getX() + (50*dir);
  y = e.getY() + 50;
    x1 = e.getX() + (50*dir);
  y1 = e.getY() + 50;
  size = 10;
  moving = true;

}

Projectile () { // unused default constructor
  vx = 1;
  vy = 0;
  
  size = 10;
  dir = 1;
}

void move(Player p) { // update x if moving and display bullet as circle
  println("move bullet");
  if (moving)
    x += vx;
  fill(#B5D3D6);
  noStroke();
  circle(x + 400 - p.getX(), y, size);
}

void reset(EyeEnemy e) { // bullet resets to eyeenemy(source) when it leaves window bounds.
  if (e.GetAlive()) {
  moving = true;
  vx = 2*e.getDirection();
  vy = 0;  
  x = x1;
  y = y1;
  }
}


boolean out(Player p) { // tracks when bullet is out of window bounds for reset function
  if (x + 400 - p.getX() > width || x + 400 - p.getX() < 0 )
  return true;
  else
  return false;
}

  // getters
  float getX() {
    return x + 400;
  }
  float getY() {
    return y;
  }
  
  // used to stop bullet & temporarily send it out of the map when collision occurs with player
  void stopProj() {
    moving = false;
    x = -10;
    y = -10;
  }

}
