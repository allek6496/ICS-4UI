float x, y, vely, r;
int col;
Boolean rUp;

void setup() {
  // ur mom
  //println("CS is an interesting course"); 
  x = 300; y = 300; vely=0;
  r = 50;
  rUp = true;
  col = 0;
  size(600, 500);
}

void draw() {
  background(0, 80, 180);
  
  if (rUp) {
    r += 1;
    if (r >= 80) rUp = false;
  } else {
    r -= 0.5;
    if (r <= 10) rUp = true; 
  }
  
  y += vely;
  
  vely += 0.1;
  
  if (y >= height-r/2) {
    vely = -vely;
    col += 30;
    col = col %255;
    y = height + r/2;
  }
  
  fill(0, 0, col);
  
  //println(x, " ", y);
  circle(x, y, r);
  
  square(500, 400, 100);
  fill(0, 10, 0);
  
  triangle (0,0, 100,100, 200, 150);
}
