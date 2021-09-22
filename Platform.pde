class  Platform {
  int x1;
  int x2;
  int y1;
  int y2;
  int groundY;
  int h;
  int numPlatforms;
  int px, py, pw, ph;
  Player p;
  
PImage surface;
PImage ground;
  
  boolean showPlatform;
  
  Platform() { // default platform: game ground
    groundY = height - 200;
    showPlatform = true;
    line(0, groundY, width, groundY);
  }
  
  Platform(int _x1, int _y1, int _x2, int _y2) { // constructor for platform takes in x y w h
    numPlatforms = 1;
    x1 = _x1;
    x2 = _x2;
    pw = _x2-_x1;
    y2 = _y2;
    y1 = _y1;
    ph = _y2 -_y1;
    groundY = _y2 ;
    surface = loadImage("block2.png");
    ground = loadImage("block1.png");
  
    
  }
   void addPlatform(int x, int y, int w, int h) {// x is left corner y is y, width and height of platform.
   // want a width divisible by 50
    px = x;
    py = y;
    pw = w;
    ph = h;
    
    numPlatforms ++;
    
  }
  int getY(Player p) { // changes based on if player is up and x within new playform's x. only works for one platform
   
    if ((p.getY() + 30  < py)  && p.getX() + 80 > px  && p.getX() + 80 < px + pw) { // attempt with platform
      groundY = py; }
      
    else { groundY = y2; }
   // set groundY back to y2
  return groundY;
    }
   

 //void displayLine() { // line display of boundary
 //  if (numPlatforms == 0) {
 //     stroke(255);
 //  line(x1, y1, x2, y2);
 //    //rotate angle
 //  }
 //  else 
 //  stroke(0);
 //  line(x1, y1, x2, y2);
 //  noFill();
 //  //rect(px, py, pw, ph);
 //  { // display
 //}}
 
 void drawPlatform(Player sasha){ // draw a red boundary relative to sasha
   fill(250, 1, 1);
   rect(px + 400 - sasha.getX(), py, pw, ph, 20);

   }
   
   
 }
   
 //void playerBoundary(Player player) {
 //  if (player.getY() > (groundY - 25)) {
 //    player.setY}
   
 
