//https://animeplyx.one

/* SHADOWS 
Carley Noll
version 1.0
assets: about 60 external files. all sprites made by me.


*///* NOTE: if game menu doesn't respond at first, just click inside the game display to get it working.
// improvements if free: add goomba type enemy (cat?) that crawls forward
// add platforms and put enemies on that. incentive: special coin (unlock new background?)

//for next sem CAP3027, new game think stardew and undertale >:D
// play earthbound?


// Audio theme asset: https://www.youtube.com/watch?v=9GjwOlPA4jw&list=RDEuVDSwLEbAY&index=2 
// Theme music from the Game Boy version of Jurassic Park. Composed by Jonathan Dunn. 
// Player is sasha, vampire boy.

import processing.sound.*;
SoundFile filej;
SoundFile fileb;
SoundFile fileh;
SoundFile filegame;

SoundFile fileCoin;
SoundFile fileOver;
SoundFile fileVictory;
SoundFile fileWin;
SoundFile fileLoseLife;
String jumpPath = "jump.mp3";
String buttonPath = "buttonhit.mp3";
String hitPath = "hit.mp3";
String gameTheme = "jurrparkgameby.mp3"; // was jurrparkgameby.mp3 could be homestuck.mp3

String coinPath = "coinPickup.mp3";
String overPath = "gameOver.mp3";
String winPath = "spicywinSound.mp3";
String victoryPath = "winVictory.mp3";
String losePath = "loseLife.mp3";

PFont gamefont;
MenuPointer pointer;
PImage menuTitle;
PImage options;
PImage menuimg;
PImage blocks;
PImage backgroundNight;
PImage cobblestone;
PImage heart;
PImage flag;

EyeEnemy[] troys; // troy, a fearsome pack of eyeguys
boolean click;
boolean clickP; // track if we just pressed c for menu.
Player sasha;
Platform terrain;
Platform newLedge;
Projectile[] bullet;
Coin[] coins;
Heart[] hearts;
float soundBuffer; // dampens or mutes sound;
Flag f;


int levelNew = 0; // use to indicate if game over or game won
boolean takeHit = false;
int jumpTracker;
int keyPressTracker; // tracks if player just pressed key
int ptrDown;
int level; // tracks game level : 0, menu, -1 choose difficulty, 1, level 1, 2 level 2, 3 gameover, 4 win: retry, exit to menu
int soundTrigger1 = 0; // prevent sound from looping and sounding like death
int soundTrigger2 = 0;
int soundTrigger3 = 0;
int soundTrigger4 = 0;
int soundTrigger5 = 0;
int soundTrigger6 = 0;
int loseHeartCt; // use to track hits, damage taken by sasha. if hits exceeds 3, game over.
boolean gameover;


//  keep track of statistics across multiple games
int coinCt;
int totalDeaths;
int totalWins = 0;
int totalGames = 0;

int collisionEye;
boolean collisionCoin;
boolean collisionBullet;
boolean collisionFlag;
boolean deathRun;
int deathx;
PImage bat;
PImage sashass;




color white = color(255, 255, 255);
color[] c = {#f1ffd9, // 0 light cream
  #b292ea, // 1- purple
  #8bdbf5, //  2- blue
  #FFFB79, // 3- yellow
  color(255, 0, 0) // 4 red
};

color[] muted = { #fb743e, //0 orange1
  #de774e, //1 orange2
  #383e56, //2 dark blueish
  #b7e1b5, //3 pastel green
  #684656, //4 hot plum
  #1c1124 };//5 dark

//platform game
//1. menu: start, options, statistics, exit
//inspiration- mario ,fancy pants, undertale

//RESOURCES
//https://www.youtube.com/watch?v=bOUGHpxqyRA
//https://poanchen.github.io/blog/2016/11/15/how-to-add-background-music-in-processing-3.0

/*=====================================================================================================*/
// TODO: 
//1.
// Make Function: detectCollision(Player p, OtherObject k);
// Parent class OtherObject? --- Coin (player collects, play two glint images), Enemies, and Projectiles (harm player), Flag ?
// just derive x and y, and boundingbox size(w/h) based on image size
// return  the SIDE on which a collion occurred (IF IT OCCURRED)


//==========================*
//2.
// HOW TO RESET GAME OBJECTS?/ Variables for new game FUNCTION!!!!
// in gameover function, call reset: make all values default again.
// options panel and stats page w/ win suprise if (coinGet >= 50);
// problems: platform
// gameover executes every moment player takes damage

// bullets out of scope dont move
// projectiles not loading and hit function


// REWORK Platforms & Player setToBoundary
// TODO gameover sequence, options panel, statistics, and win surprise. + BOUNDARIES!!

// sometimes after a jump he lands a little below the boundary
// Start adding more comments
// kill enemies by jumping on their head

// IMPORT SOUNDS: menu song, game song, and keypress song.
// map moves with player


void setup() {

    size(1000, 1000);
    
  noStroke();
  menuimg = loadImage("menuimage.png");
  gamefont = createFont("Gameplay.ttf", 50);
  rectMode(CENTER);
  blocks = loadImage("groundSurface.png");
  cobblestone = loadImage("ground.png");
  backgroundNight = loadImage("background.png");
  flag = loadImage("flag.png");
  menuTitle = loadImage("title1.png");
  options = loadImage("options.png");
  bat = loadImage("bats.gif");
  sashass = loadImage("sashastartR.png");


  // initialize major class objects
  pointer = new MenuPointer();
  sasha = new Player();
  troys = new EyeEnemy[10];
  bullet = new Projectile[10]; 
  f = new Flag(8000, 600, sasha); //initialize flag (pass for victory)

  for (int i = 0; i < 10; i ++) {// initialize eye-enemy objects from an array with random x values, and their associated bullets.
    troys[i] = new EyeEnemy(800 + random(400, 1200)*i, 605, -1, sasha);
    bullet[i] = new Projectile(troys[i]);
  }
  deathRun = false; // use to toggle levels.



  terrain = new Platform(0, height-300, width, height-300);  
  newLedge = new Platform(600, height - 350, 700, height - 350);

  hearts = new Heart[3];
  hearts[0] = new Heart(30);
  hearts[1] = new Heart(60);
  hearts[2] = new Heart(90);


  coins = new Coin[50]; // Coin[] coins = new Coin[50], then initialize
  for (int i = 0; i < coins.length; i ++) {
    int coinX;
    if (i < 20) {
      coinX = 1000 + 30*i; // set up evenly spaced coin objects
    } else {
      coinX = 3000 + 30*i;
    }
    coins[i] = new Coin(coinX, 570);
  }

  keyPressTracker = 0;
  jumpTracker = 0;

  click = false;
  clickP = false;
  ptrDown = 0;
  level = 0;
  coinCt = 0;
  totalDeaths = 0;
  gameover = false;

  filej = new SoundFile(this, jumpPath);
  fileb = new SoundFile(this, buttonPath); //button click, menu
  fileh = new SoundFile(this, hitPath); // take damange
  filegame = new SoundFile(this, gameTheme); //jurassic park!

  fileCoin = new SoundFile(this, coinPath);
  fileOver = new SoundFile(this, overPath);
  fileVictory = new SoundFile(this, victoryPath);
  fileWin = new SoundFile(this, winPath);
  fileLoseLife = new SoundFile(this, losePath);



  filegame.loop(.69, .2); // goal: play once at start of each init game.
  soundBuffer = 0.6;
  loseHeartCt = 0;
  deathx = 300;
}

void draw() {

  background(0);

  if (level == 0) {
    pushMatrix();
    initMenu(); 
    pointer.display(ptrDown);
    popMatrix();
  }
  
  
// BEGIN ACTIVE GAME CODE =================================================================================================================================
  if (level == 0 && clickP && ptrDown == 0) { // if user selects START
    level = -1;
  }
  if (level == -1) {  
    initChooseDifficulty();
  } else if (level == 1 || level == 2) {


    initGame();
    hearts[1].display();
    hearts[2].display();
    hearts[0].display();


    // platform can addplatform, displayLine, drawPlatform 
    sasha.display(terrain);

    for (int i = 0; i < coins.length; i ++) {
      coins[i].display();
    }

    for (int i = 0; i < troys.length; i ++) {
      troys[i].display();

      if (sasha.getX() > troys[i].getX()) {
        troys[i].setDirection(1); // shoot bullets in direction of sasha
    }
    }
    
    // attempt to force speed run game for LEVEL 2 challenge.
    //if (deathRun) {
    //  fill(255, 200, 200);
    //  rect(deathx - width*5, 0, width*10, height*2);
    //  deathx += 1;
    //  if (sasha.getX() < deathx + width*5) {
    //    TakeDamage();
    //  }
    //}

   
    // set to only level 2
    if (level == 2) {
    for (int i = 0; i < bullet.length; i ++) { 
      bullet[i].move(sasha);

      if (bullet[i].out(sasha)) { // if bullet leaves map, shoot again by resetting x values to troy enemy.
        bullet[i].reset(troys[i]);
        bullet[i].move(sasha);
      }
    }
    }
    soundTrigger2 = 0;

    for (int i = 0; i < troys.length; i ++) { // handles sasha running into eyeguys: troys[]

      collisionEye = detectCollision(sasha, troys[i]); // if collision detected... (collisionEye is 1 or 2, either kill enemy or sasha takes damage)

      if (collisionEye == 1) {  
        soundTrigger1 = 0;  
        takeHit = true;
       //MAKE THIS FUNCTION ONLY EXECUTE ONCE, by moving sasha back after damage 
        TakeDamage();
        sasha.HitBoost();
        takeHit = false;
      } else if (collisionEye == 2) {
        sasha.JumpBoost();
        troys[i].GetSmushed();
        if (soundTrigger2 == 0) {
          fileb.play();
          soundTrigger2 = 1;
        }
      }
    }

    soundTrigger3 = 0;
    for (int i = 0; i < coins.length; i ++) { 
      // iterate through coin array, check for collision. If detected, then collect coin, score ++, soundFX
      if (detectCoinCollision(sasha, coins[i]))
      { 
        if (!coins[i].isCoinGained()) {
          coins[i].Collected();
          coinCt ++;


          if (soundTrigger3 == 0) {
            fileCoin.play(3, 0.1);
            soundTrigger3 = 1;
          }
        }
      }
    }

  
    terrain.addPlatform(2000, 600, 200, 10); // platform interaction handling
    terrain.drawPlatform(sasha);
    sasha.setToBoundary(terrain);

    sasha.move();
    //sasha.printData();

    soundTrigger4 = 0;
    
    for (int i = 0; i < bullet.length; i ++) {  // determine if any of bullets collide with sasha, takedamage
      
    // dy is 55 and dx is 400
    
      if (bulletCollision(sasha, bullet[i])) {
                bullet[i].stopProj();
                TakeDamage();
        println("bullet hit");

        if (soundTrigger4 == 0) {
          fileh.play(1, soundBuffer);
          soundTrigger4 = 1;
      }
    }
    }

    if (gameover) {
      frameRate = 3;
      if (soundTrigger5 == 0) {
        sasha.JumpBoost();
        fileOver.play(.6, soundBuffer/3);  
        totalDeaths ++;         
        soundTrigger5 = 1;
      }

      GameOver(level);
      frameRate = 60;
    }


    if (passFlag(sasha, f)) {
      levelNew = 1;
      WinDialog();
      // resetObjects()
      // game reset dialog
      // quit to menu or next level
      //
      // level ++
    }
// END ACTIVE GAME CODE =================================================================================================================================

    //more menu options
  } else if (clickP && ptrDown == 1) {  //OPTIONS- DISPLAY CONTROLS
    image(options, 0, 0);

    //return to menu button
    ReturnButton();
    
    //FUTURE IDEAS:
    // add mute button?
    // if user clicks button, then mute sound effects
    // mute: soundBuffer = 0;
    
  } else if (clickP && ptrDown == 2) {  //DISPLAY STATISTICS
    fill(0);
    rect(width/2, height/2, width, height);
    textFont(gamefont);
    textAlign(CENTER);
    fill(255);
    text("Statistics", width/2, height/3);
    image(bat, width/2 - 230, height/3 - 50);
    image(bat, width/2 + 180, height/3 - 50);
    textSize(28);
    textAlign(RIGHT);


    text("Total coins collected: ", width/2, height/2 - 50);
    text("Total deaths: ", width/2, height/2 + 50);
    text("Survival Rate: ", width/2, height/2 + 150);
    if (coinCt > 50) {
      textAlign(CENTER);
      fill(255, 0, 0);
       text("achievement: get those coins!", width/2, height - 200);
       image(sashass, width/2 - 370, height - 290);
    }


    fill(255, 0, 0);
    textAlign(LEFT);
    textSize(36);
    text(coinCt, width/2 + 100, height/2 - 50);
    text(totalDeaths, width/2 + 100, height/2 + 50);
    float survival = (float) totalWins / (float) totalGames;
    text(survival, width/2 + 100, height/2 + 150);

    //Display coins collected, numDeaths,
    //num retries
    //reveal special badge for all coins collected

    //return to menu button
    ReturnButton();
  } else if (clickP && ptrDown == 3) {  //EXIT message and exit()
    frameRate(1);
    fill(0);
    rect(width/2, height/2, width, height) ;

    translate(width/2, height/2);
    textFont(gamefont);
    textAlign(CENTER);
    fill(c[4]);
    text("Goodbye", 0, 0);

    exit();
  }
}// end of draw


void ReturnButton() { // button for use in OPTIONS and STATS of menu
  textSize(20);
  textAlign(LEFT);
  if (mouseX < width && mouseX > 650) {
    if (mouseY > 0 && mouseY < 75) {
      fill (muted[4]);
      rect(800, 0, 300, 150);
    }
  }
  if (mousePressed) {
    if (mouseX < width && mouseX > 650) {
      if (mouseY > 0 && mouseY < 75) {
        click = false;
        clickP = false;
        ptrDown = 0;
        level = 0;
      }
    }
  }
  fill(255);
  text("Return to Menu", 700, 50);
}


void TakeDamage() {
  // loseheart function, increment number of hearts lost and play soundbite 
 
    if (soundTrigger1 == 0) {
      fileh.play(1.2, soundBuffer);
      soundTrigger1 = 1;
    }

    if (loseHeartCt == 2) { // if player has lost 3 hearts, end game
      levelNew = 2;
      hearts[loseHeartCt].endHeart();
      gameover = true;
      //reset game values
    } else {
      hearts[loseHeartCt].endHeart();
      loseHeartCt ++;
    }
  
}
void GameReset() { //reset all variables that changed during game (refer to setup/draw), including position/states of objects

  soundTrigger1 = 0; // prevent sound from looping and sounding like death
  soundTrigger2 = 0;
  soundTrigger3 = 0;
  soundTrigger4 = 0;
  soundTrigger6 = 0;
  keyPressTracker = 0;
  jumpTracker = 0;

  click = false;
  clickP = false;
  ptrDown = 0;
  loseHeartCt = 0;
  deathx = 300;
  deathRun = false;

  hearts[1].restoreHeart();
  hearts[2].restoreHeart();
  hearts[0].restoreHeart();
  sasha.SetPos(400, 500);

  for (int i = 0; i < coins.length; i ++) {
    coins[i].CoinRestore();
  }
  for (int i = 0; i < troys.length; i ++) {
    troys[i].Restore();
  }
    for (int i = 0; i < bullet.length; i ++) { 
    bullet[i].reset(troys[i]);
  } //reset bullets here
}



void GameOver(int currLvl) { // reset game values, end game, player UI
  GameReset();
  //options: try again - back to level 1, or quit to menu

  fill (0);
  rect(width/2, height/2, width, height);
  fill(muted[2]);

  //if mouse is within display, highlight text with rect underneath
  if (mouseY < height/3 + 130 && mouseY > height/3 + 30) { // + or - 50
    if (mouseX > width/2 - 150 && mouseX < width/2 + 150) {
      rect(width/2, height/3 + 80, 300, 100);
    }
  } else if (mouseY < height/3 + 250 && mouseY > height/3 + 150) { //+ or - 50
    if (mouseX > width/2 - 150 && mouseX < width/2 + 150) {
      rect(width/2, height/3 + 200, 500, 100);
    }
  }
  fill(c[4]);
  textSize(50);
  textAlign(CENTER);
  text(":( Game Over :(", width/2, height/3);
  text("Try Again", width/2, height/3 + 100);
  text("Return to Menu", width/2, height/3 + 220);

  //if mouse clicked, select option
  if (mousePressed) {
    fileb.play();
    if (levelNew == 2) {
      if (mouseY < height/3 + 130 && mouseY > height/3 + 30) {
        if (mouseX > width/2 - 150 && mouseX < width/2 + 150) {
          gameover = false;
          totalGames ++;          
          level = currLvl;
          soundTrigger5 = 0;
        }
      } else if (mouseY < height/3 + 250 && mouseY > height/3 + 150) {
        if (mouseX > width/2 - 250 && mouseX < width/2 + 250) {

          level = 0;
          gameover = false;
          totalGames ++;
          soundTrigger5 = 0;
          //reset soundtrigger5 here only because we are sent out of game over, so soundOver cannot loop(crash)
        }
      }
    }
  }
}

void WinDialog() {  // play victory sound, and say press c to continue. if player releases c, increment wins, games, and reset variables.

  if (soundTrigger6 == 0) { 
    fileVictory.play();
    soundTrigger6 = 1;
  }

  fill (c[1]);
  rect(width/2, height/2, width, height);

  textFont(gamefont);
  textAlign(CENTER);
  fill(255);
  text("YOU MADE IT!", width/2, height/2);
  textSize(30);
  if (frameCount % 100 > 50)
    text("press 'c' to continue...", width/2, height/2 + 100);

}


void keyPressed() { // handle UI with keyboard arrows & c key

  // soundbite play once
  if ( level == 0 && (key == 'c'|| key == 'C')) {
    fileb.play();
    clickP = true;
  }
  if (level == 1 || level == 2) {

    if (keyCode == RIGHT) {
      keyPressTracker ++; // tells us if the user JUST pressed the key.
      sasha.runForward(keyPressTracker);
    } else if (keyCode == LEFT) {

      keyPressTracker ++; // tells us if the user JUST pressed the key.
      sasha.runBackward(keyPressTracker);
    }
    if (keyCode == UP && sasha.getY() + 50 >= terrain.getY(sasha)) { 
      // only activates if sasha Y > groundY of terrain object
      jumpTracker++;
      if (jumpTracker == 1) {
        filej.play(1, soundBuffer);
        sasha.jump(jumpTracker);
      }
    }
  }
}

void keyReleased() { // use to end run/select options
  jumpTracker = 0;
  keyPressTracker = 0;
  click = true;
  // 1. menu -> pointer up and down
  // 2. player movement -> LEFT RIGHT UP(jump) 

  if ( levelNew == 1 && (key == 'c'|| key == 'C')) { // if in winDialog and user presses c, reset values and return to menu
    GameReset();
    fileb.play();
    level = 0;
    clickP = false;
    totalWins ++;
    totalGames ++;
    levelNew = 0;
  }
  if (key == CODED) {

    if (level == 0) { // if on menu display, then traverse options based on key
      if (keyCode == DOWN) {
        if (ptrDown == 3) {
          ptrDown = 0;
        } else {
          ptrDown ++;
        }
      } else if (keyCode == UP) {
        if (ptrDown == 0) {
          ptrDown = 3;
        } else { 
          ptrDown --;
        }
      }
    }
    if (level == 1 || level == 2) {    
      if (keyCode == DOWN) {
      }
    } 
    // stops run sequence when key not pressed
    if (keyCode == RIGHT) {
      sasha.stopRun();
    } else if (keyCode == LEFT) {
      sasha.stopRun();
    }
  }
}


// ============================= COLLISION DETECTION FUNCTIONS ==================================================================================== \\

int detectCollision(Player p, EyeEnemy e) { // return int: 0 means no collision, 1 means collision, and 2 means on top side.
  // when dist < s1 + s2 /2 of images, collision
  float d = dist(p.getX() - 20, p.getY()- 60, e.getX() - 40, e.getY());  // calculations based on where figures appear in transparent image bounds
  //boolean collision = false;
  float dy = p.getY() - e.getY() - 50;
  float dx =  p.getX() - e.getX();
  int collisionCode = 0; // no collision

  if (d <= 90) { 
    if (dy < -60  && p.getVY() > 0) {
      collisionCode = 2; // bonk, kill eye enemy
    } else {
    if (p.getVY() >= 0) {  
    if (dx > - 100 && dx < 0) // only if in close range (appear to overlap)
      collisionCode = 1; // take damage
      print ("Eyeguy says: die!");
    }
    }
  
  }


  return collisionCode;
}

boolean detectCoinCollision(Player p, Coin c) { // determines whether player has collected a coin or not
  // when dist < s1 + s2 /2 of images, collision 
  float d = dist(p.getX() - 60, p.getY() + 50, c.getX(), c.getY()); 
  float dx = p.getX() - 50 - c.getX() ;

  if (d <= 40 && (dx < 30 && dx > -15 )) {
    return true;
  } else if (sasha.getSpeed()== 0) {
    float s = dist(p.getX() - 40, p.getY() + 40, c.getX() + 10, c.getY() + 10); 
    if (s <= 60 ) {
      return true;
    } else return false;
  } else return false;
}

boolean passFlag(Player p, Flag f) { // determines if player passed the flag --> use to determine if win
  float d = p.getX() - f.getX(); 

  if (d >= 150) {
    return true;
  } else return false;
}

boolean bulletCollision(Player p, Projectile b) { // FIXME
  // when dist < s1 + s2 /2 of images, collision
  //println("player: " + p.getX() + " bullet: " + b.getX());
  float dy = p.getY() - b.getY();
  //println("dy: " + dy);
  float dx = b.getX() - (p.getX() + 60);
  if (dy > -50 && (dx < 370 && dx > 350 )) { // if dy goes further negative oand
    return true;
  }
  else return false;
}


void initChooseDifficulty() { 
  // user must pick easy vs hard.
  // game is at state -1
  clickP = false;

  fill(c[4]);
  rect(width/2, height/2, width, height);
  fill(c[2]);
  
//if mouse is within bounding box, highlight text.
  if (mouseY < height/3 + 130 && mouseY > height/3 + 30) { // + or - 50
    if (mouseX > width/2 - 150 && mouseX < width/2 + 150) {
      rect(width/2, height/3 + 80, 300, 100);
    }
  } else if (mouseY < height/3 + 250 && mouseY > height/3 + 150) { //+ or - 50
    if (mouseX > width/2 - 150 && mouseX < width/2 + 150) {
      rect(width/2, height/3 + 200, 300, 100);
    }
  }
  fill(0);
  text("Difficulty: ", width/2, height/3);
  text("I. Easy", width/2, height/3 + 100);
  text("II. Hard", width/2, height/3 + 220);

//if player selects while hovering over box, play button noise and move to next stage by changing the value of level
// draw goes into next loop at level 1, activating the game.
  if (mousePressed) {
    fileb.play();
    if (level == -1) {
      if (mouseY < height/3 + 130 && mouseY > height/3 + 30) {
        if (mouseX > width/2 - 150 && mouseX < width/2 + 150) {
          level = 1;
        }
      } else if (mouseY < height/3 + 250 && mouseY > height/3 + 150) {
        if (mouseX > width/2 - 150 && mouseX < width/2 + 150) {
          level = 2;
        }
      }
    }
  }
}

void initGame() { //sets up map, display flag, as well as text in top right.
  // LEVEL IS 1 OR 2

  rectMode(CENTER);
  tint (255, 255);
  fill (0);

  rect(width/2, height/2, width, height);
  image(backgroundNight, 150 - sasha.getX()/2, 0); // set background image to move behind sasha

  for ( int i = 0; i < width*9; i += 200) {
    image(cobblestone, i - sasha.getX(), height - 100 + i); // stones below sasha, ground, move with reference to sasha
  }
  for ( int i = 0; i < width*9; i += 200) { 
    image(blocks, i - sasha.getX(), height-300);
  }
  f.display();

  fill(255);
  textSize(50);
  textAlign(LEFT);
  if (level == 1) {
    text("Level 1", 0.75 * width, 0.08 * height);
    stroke(0);
  } else if (level == 2) {
    stroke(255);
    text("Level 2", 0.75 * width, 0.08 * height);
  }
  textSize(30);
  text("Lives: ", 0.75 * width, 0.12 * height);
}


void initMenu() { // start menu
  if (frameCount < 510 && level == 0) { // fade in image at very beginning
    fill(muted[4], frameCount/2);
    tint (255, frameCount/2);
    image(menuimg, 0, 0);
  } else image(menuimg, 0, 0);


  image(menuTitle, 0, -250); //display SHADOWS

  translate(width/2, height/2); // display text options
  textFont(gamefont);
  textAlign(CENTER);
  fill(c[4]);
  text("Start", 0, 0);
  text("Options", 0, 70);
  text("Statistics", 0, 140);
  text ("Exit", 0, 210);
}
