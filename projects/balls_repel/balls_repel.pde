int num = 5000;
int radius = 15;
Particle balls[] = new Particle[num];

void setup() { 
  size(1600, 1600);
  noStroke();
  
  for (int i = 0; i < num; i++) {
    balls[i] = new Particle(random(radius, width-radius), random(radius, height-radius), radius);
  }
}

void draw() {
  background(255);
  
  for (Particle ball : balls) {
    //println(ball.x, ball.y);
    ball.update(balls);
  }
}
