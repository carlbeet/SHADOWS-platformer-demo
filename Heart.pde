class Heart {
  float x;
  boolean bounce; // if heart is valid (not lost)
  int index = 0;
  PImage[] heart = new PImage[5];
  
  Heart() 
  {}
  
  Heart( int xIncrement) { // x increment is for display of hearts next to eachother
    bounce = true;
    x = (width * .84) + xIncrement;
         for (int i = 0; i < 5; i ++) {
    heart[i] = loadImage("heart_" + i + ".png");
        }
  }
  
  
  
  void display() {
    if(bounce) {
      if (frameCount % 6 == 0) {
        index ++; }
       
   
   image(heart[index % 5], x, height* .090); // heart animation

  
}}
 
 void endHeart() { // if life is lost...
   
   bounce = false;
 }
 void restoreHeart() { // if resetting game!
   bounce = true;
 }
   
  
    };
