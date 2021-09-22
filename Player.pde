class Player {

  PImage sashaStill; // static sasha sprite
  PImage[] sashaRun= new PImage[4]; // run to right sprite
  PImage[] sashaRunL = new PImage[4]; // left run sprite
  PImage sashaStart, sashaJump, sashaStartL, sashaJumpL; // smoothen animation (start) and jumps
  float x;
  float x1;
  float y;
  float speed;
  float vy;
  float g = 1.2;
  float a;
  float t;
  int index = 0;
  boolean keyJustPressed;
  boolean jump;
  boolean blocked, blocked2;

  boolean alive;

  Player() {
    sashaStill = loadImage("playerR/sasha.png");
    for (int i = 0; i < 4; i ++) {
      String num = str(i + 1);
      sashaRunL[i] = loadImage("playerL/run/sashaL" + num + ".png");
      sashaRun[i] = loadImage("playerR/sasharun" + num + ".png");
    }
    sashaStart = loadImage("playerR/sashastartR.png");
    sashaStartL = loadImage("playerL/sashaStartL.png");
    sashaJump = loadImage("playerR/SashajumpR.png");
    sashaJumpL = loadImage("playerL/SashajumpL.png");

    jump = false;
    keyJustPressed = false;
    blocked = false;
    blocked2 = false;

    x = 400;
    x1 = 400;
    y = height-500;
    speed = 0;
    vy = 0;
    a = 0;
  }

  void printData() { 
    // prints sasha's coordinates; 
    // note that images are always displayed at (x1, y)
    println("x: " + x);
    println("y: " + y);
    println("speed: " + speed);
    println ("vy: " + vy);
  }


  boolean isOnGround(Platform boundary) { // returns true if player is on boundary
    if (y >= boundary.getY(sasha) - 50) {
      return true;
    } else {
      return false;
    }
  }


  void setToBoundary(Platform boundary) { // player must not fall below boundary - stops vy if player makes it to the ground and is falling.
    if (isOnGround(boundary) && vy > 0) { 
      vy = 0;
      jump = false;
    } else if (!isOnGround(boundary) && !jump) { // if falling in air (not jump) gravity takes effect.
      vy = 8;
    }
  }


  void display(Platform boundary) { // display for sasha and takes in boundary parameter.

// jump displays
    if (!isOnGround(boundary) && (speed < 0)) {
      image(sashaJumpL, x1-50, y-50);
    } else if (!isOnGround(boundary) && (speed >= 0)) {
      image(sashaJump, x1-50, y-50);
    } else if (speed == 0) {
      image(sashaStill, x1-50, y-50);
    } else if (speed > 0) {  
      if (frameCount % 12 == 0) {
        index ++;
      }
      int i = index % 4;

// run animations
      image(sashaRun[i], x1-50, y-50);
    } else if (speed < 0) { // player uses left key, move backwards
      if (frameCount % 12 == 0) {
        index ++;
      }
      int i = index % 4;

      image(sashaRunL[i], x1-50, y-50);
    }
  }
  //where the magic happens: position update
  void move() { 
    if (x < 350)  // set map boundaries to x(350, 9000). can only be unblocked if running the right direction
      blocked = true; 
    if ( x > 9000) 
      blocked2 = true; 
    if (blocked && speed > 1)
      blocked = false;
    if (blocked2 && speed < -1) 
      blocked2 = false;

    if (!blocked && ! blocked2) { // if  player is inside map invisible bounds, update positions: he run!!!

// yay! update x and y based on speed and vy! gravity with jump.
      x += speed;
      y += vy/2;
      // vy usually 0
      if (jump) {
        vy += 0.8 * g;
      }
    }
  }

  void jump(int k) { // keypresstracker input
    if (k == 1) // if key just pressed
      jump = true;
    vy = -20 - abs(speed); // speed boosts jump
    speed *= 1.02 ; // small speed exponential increase when jump pressed
  }

  void runForward(int k) {
    speed = 6;

    // sashaStart image played when the key is first pressed(for smoother animation)
    // 
    if (k == 1) {
      image(sashaStart, x1-50, y-50);
    }
  }


  void runBackward(int k) {

    speed = -6;


    if (k == 1) {
      image(sashaStartL, x1-50, y-50);
      print ("sasha started!");
    }
  }
  void stopRun() { // used to stop sasha when key is released.
    speed = 0;
  }

// getters and setters
  int getY() {
    return (int) y;
  }
  int getX() {
    return (int) x;
  }
  int getVY() {
    return (int) vy;
  }
  int getSpeed() {
    return (int) speed;
  }
  int getDir() {
    if (speed < 0) {
      return -1;
    } else {
      return 1;
    }
  }
  //everything relative to sasha x!!

  void setY(int newY) {
    y = newY;
  }
  boolean getJump() {
    return jump;
  }
  void JumpBoost() { // jump boost when sasha jumps on enemies' heads!
    vy -= 25;
  }
  void HitBoost() {
    x -= 60 * getDir(); // hit boost to push sasha away from enemies when he takes damage. prevents bug of 1-hit death
  }
  void SetPos(float x, float y) {
    this.x = x;
    this.y = y;
  }
}
