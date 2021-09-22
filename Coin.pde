class Coin {
 PImage[] coins = new PImage[5]; // coin spin sprite 
 PImage[] coinGlint = new PImage[2]; // coin glint sprite
 float x;
 float y;
 int index;
 int index2 = 0;
 boolean coinGained;
 // if player intersects with coin, coinGained = true;
 // coin get: play fileCoin, flash
 
  Coin() 
   {
     x = 0;
     y = 0;
   }
   Coin(float x, float y) { // load coin with image loops, position x,y, and not collected boolean
     this.x = x;
     this.y = y;
     
    for (int i = 0; i < 5; i ++) {
      String num = str(i + 1);
      coins[i] = loadImage("coin" + num + ".png");
   }
      for (int i = 0; i < 2; i ++) {
      String num = str(i + 1);
      coinGlint[i] = loadImage("coinsparkle" + num + ".png");
   }
   index = 0;
   index2 = 0;
   coinGained = false;
 }
   
   void display() { 
     if (!coinGained) { // display if coin has not been collected.
       if (frameCount % 10 == 0) {
        index ++; }
    image(coins[index % 5], x + 500 - sasha.getX(), y);
       } else {
         if (frameCount % 5 == 0) {
         index2 ++; }
         if (index2 < 30) 
        image(coinGlint[index % 2],  x + 500 - sasha.getX(), y);
        
       }

 
   }
   void Collected() { // toggles if coin should display or not, based on if player collected it
     coinGained = true;
   }
   void CoinRestore() { // at end of game, restore coin
     coinGained = false;
   }
   
   //setters and getters
   void setX(int newx) {
     x = newx;
   }
   void setY (int newy) {
     y = newy;
   }
   
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
  boolean isCoinGained() { // if coin has been collected or not
    return coinGained; }

    

 
 
};
