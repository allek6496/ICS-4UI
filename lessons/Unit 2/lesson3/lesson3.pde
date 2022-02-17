PFont f1;

void setup() {
  // println(PFont.list());
  size(600, 600);
  background(0);

  f1 = createFont("Comic Sans MS", 36);

  String msg = "your mom";

    fill(255, 255, 255);
    textFont( f1 );
    textAlign(CENTER);

  for (int y = 18; y < height-18; y += 36) {
    text( msg, 300, y);
  }
}
