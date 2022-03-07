// testing code for the water droplets in CellularAutomata
int num = 4;
int w;

void setup() {
  PVector test = new PVector(0, 0);
  println(test.heading());

  size(400, 400);
  noLoop();
  // background(100);

  w = width/num;
}

void draw() {
  for (int x = 0; x < num; x++) {
    for (int y = 0; y < num; y++) {
      strokeWeight(5);
      fill(100);
      square(x*w, y*w, w);
    }
  }

  // draw a teardrop

  int x = 0;
  int y = 1;
  float content = 1;
  float rotation = 0;

  fill(0, 0, 255);
  stroke(100, 100, 255);

  pushMatrix();
  
  translate(w*(x+0.5), w*(y+0.5));
  
  // https://www.desmos.com/calculator/0rxocd2kcz
  // modified sigmoid function, approaches no difference as content => +infinity
  rotate(-1*rotation/8*TWO_PI);
  scale(1/(1+pow(2.71828, 1.5-content)), 1);

  beginShape();
  curveVertex(0, -w/2);
  curveVertex(0, -w/2);

  curveVertex(-w/2, w/6);
  curveVertex(0, w/2);
  curveVertex(w/2, w/6);
  
  curveVertex(0, -w/2);
  curveVertex(0, -w/2);
  endShape();

  popMatrix();
}
