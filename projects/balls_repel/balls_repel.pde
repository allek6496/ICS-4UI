int num = 500;
int radius = 25;
Particle balls[] = new Particle[num];

void setup() { 
  size(800, 800);
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
