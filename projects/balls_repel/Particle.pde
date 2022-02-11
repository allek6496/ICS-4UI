class Particle {
  float charge = 30;
  float mouseCharge = 1000;
  float temp = 1;
  float x, y, velx, vely, accx, accy;
  int radius;
  
  Particle (float x, float y, int radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
  }
  
  void update(Particle[] others) {
    // dampen the velocity
    velx *= 0.5;
    vely *= 0.5;
    
    accx *= 0.2;
    accy *= 0.2;
    
    // be affected by other particles
    for (Particle other : others) {
      if (this != other) {
        affect(other.x, other.y, other.charge);  
      }
    }
    
    // be affected by the mouse
    if (mousePressed) {
      affect(mouseX, mouseY, -mouseCharge);
    } else {
      affect(mouseX, mouseY, mouseCharge);
    }
    
    // be strongly affected by the walls
    velx += pow(1.2, radius/2 - x) - pow(1.2, x - width + radius/2);
    vely += pow(1.2, radius/2 - y) - pow(1.2, y - height + radius/2);
    
    // keep from going out of bounds
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
    
    jitter();
    
    // change the velocity according to the acceleration
    velx += accx;
    vely += accy;
    
    // change the position according to velocity
    x += velx;
    y += vely;
    
    display();
  }
  
  private void affect(float oX, float oY, float oCharge) {    
    // vector from the other particle to this one
    PVector d = new PVector(x - oX, y - oY);
    
    // scale it's magnitude accordingly
    d.setMag(charge*abs(oCharge) / pow(d.mag(), 2)).limit(2);
    
    // if charge is negative, invert the direction of force to pull it towards
    if (oCharge < 0) {
      d.rotate(PI);
    }
    
    // force affects acceleration
    accx += d.x;
    accy += d.y;
  }
  
  private void jitter() {
    accx += random(-temp, temp);
    accy += random(-temp, temp);
  }
  
  private void display() {
    fill(100);
    circle(x, y, radius);
  }

}
