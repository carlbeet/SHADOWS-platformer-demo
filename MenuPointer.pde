// fully implemented menu UI class

class MenuPointer {
  
  int y;
  int x;
  boolean show;
  int count = 5;
  int down;
  int xdiff;
  color red = color(255, 0, 0);
  
  
  MenuPointer() { // default values
    x = - 140;
    y = - 40;
    show = true;
    down = 0;
    xdiff = 0;
  }
  
  
  void display(int dn) { // display based on dn, ptrdown 0-4 variable from player input
 
   //blink 
    down = dn;
    xdiff = 0;
    if (dn == 1){xdiff = -30;}
    if (dn == 2) {xdiff = -75;}
    if (dn == 3) {xdiff = 20;}
    count++;
    if (count % 100 < 40 && count % 100 > 0)
    {show = false; }
    else {show = true; }
    
    if (show) {
    noStroke();
    fill(red);
    triangle(x + xdiff, y+ (dn*70), x + 40 + xdiff, y +20 + (dn*70), x + xdiff, y + 40 + (dn*70));}
  }


  
  }
