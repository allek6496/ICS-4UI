void setup() {
  String p;
  
  p = "(1367.2, -54.999)"; 
  println("The point " + p + " is " + getPoint(p));

  p = "(0, -4)"; 
  println("The point " + p + " is " + getPoint(p));
  
  p = "(62.5, 0.03)"; 
  println("The point " + p + " is " + getPoint(p));

  p = "(28.541, 150.7)"; 
  println("The point " + p + " is " + getPoint(p));

  
  // for (float x = -5; x <= 5; x++) {
  //   for (float y = -5; y <= 5; y++) {
  //     println("(", x, ",", y, ") is at", getLocation(x, y));
  //   }
  // }
}

PVector getPoint(String s) {
  println(s.length());
  float first = float(s.substring(1, s.indexOf(",")));
  println(first);
  float second = float(s.substring(s.indexOf(",") + 2, s.length()-1));
  println(second);

  return new PVector(first, second);
}

String getLocation(float x, float y) {
  if (x > 0 && y > 0) return "Quadrant 1";
  else if (x < 0 && y > 0) return "Quadrant 2";
  else if (x < 0 && y < 0) return "Quadrant 3";
  else if (x > 0 && y < 0) return "Quadrant 4";
  else if (x == 0 && y == 0) return "Origin";
  else if (x == 0) return "Y-axis";
  else if (y == 0) return "X-axis";
  else return "Deep into the third dimension";   
}
