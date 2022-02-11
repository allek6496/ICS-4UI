float x, y, velx, vely;
int radius;

void setup() {
  x = 300;
  y = 300;
  radius = 30;
  
  size(600, 600);
}

void draw() {
  background(255);
  noStroke();
  
  // dampening
  vely *= 0.5;
  velx *= 0.5;
  
  // repel from the walls
  velx += pow(2.71828, radius/2 - x) - pow(2.71828, x - width + radius/2);
  vely += pow(2.71828, radius/2 - y) - pow(2.71828, y - height + radius/2);
  
  if (0 < mouseX && mouseX < width && 
      0 < mouseY && mouseY < height) {
    // vector from the mouse to the ball
    PVector d = new PVector(x - mouseX, y - mouseY);
    
    // keeping same direction, invert the magnitude, so closer is stronger
    d.setMag(30/d.mag());
    
    velx += d.x;
    vely += d.y;
  }
  
  // of OOB, set the velocity to return it quickly
  if (x < -radius) {
    x = -radius;
  } else if (x > width + radius) {
    x = width + radius;
  } 
  
  if (y < -radius) {
    y = -radius;
  } else if (y > height + radius) {
    y = height + radius;
  }
  
  // after modifications, set x value
  x += velx;
  y += vely;
  
  println(x, velx, " - ", y, vely);
  
  fill(100);
  circle(x, y, radius);
  
}
