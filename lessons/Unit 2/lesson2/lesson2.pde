void setup() {
   exit();
   
   for (float i = -PI/2.0; i < PI/2.0; i+= 0.1) {
       float c = pow(cos(i), 2);
       float s = pow(sin(i), 2);
       println("For i =", i, ":", c, "+", s, "=", c + s);
   }
}

