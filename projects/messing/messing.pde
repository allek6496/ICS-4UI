//Play with this program for a while
float aMin, aMax, bMin, bMax;
float zoomFactor = 1.0;

boolean showTrace = false;
boolean showMandelbrotSet = true;

float animatedZoomFactor = 1.10;

float aRange, bRange;
float aCentre, bCentre;
float unitsPerPixel; //the ratio (aMax-aMin)/width;
float pixelsPerUnit; //the reciprocal of unitsPerPixel
float k = PI/512;

int orbitSize = 20;

ComplexNumber orbitCenter;
ComplexNumber[] orbit = new ComplexNumber[orbitSize];
ArrayList<PVector> trace = new ArrayList<PVector>();

boolean mouseMoved = false;


void setup() {
  size(700, 700);
  background(255);
  noLoop();
  resetStartingValues(); //Sets aMin=-1.8, aMax = 0.5, bMin = -1.15, bMax = 1.15
  resetRatios();
  if( showMandelbrotSet )
    drawMandelbrotSet();
}


void drawMandelbrotSet() {
  background(255);

  ComplexNumber c, z;
  int n;

  for (float x = 0; x < width; x++) {
    float a = get_a( x );

    for (float y = 0; y < height; y++) {
      float b = get_b( y );

      c = new ComplexNumber(a, b);
      z = c;
      n = 0;

      while (z.absoluteValueSquared() < 4 && n < 200) {
        z = z.multiply(z).add(c);
        n++;
      }

      if ( n >= 200) {
        stroke(0);  
        point(x, y);
      }
    }
  }
  saveFrame("data/Mandelbrot set background.tiff");
}


void draw() {
  if( mouseMoved ) {
    background(255);
    fill(255, 255, 0);
   
    if( showMandelbrotSet ) {
      PImage mandelbrotSetBackground = loadImage("data/Mandelbrot set background.tiff");
      image(mandelbrotSetBackground, 0, 0);
    }
   
    float x1=0, y1=0, x2=0, y2=0;
   
    fill(0);
    noStroke();
   
    if( showTrace ) {
      int n = trace.size();
     
      for(int i=0; i < n; i++) {
        PVector v = trace.get(i);
        circle(v.x, v.y, 30);
      }
    }
   
    for(int i = 1; i < orbitSize; i++) {
      x1 = get_x( orbit[i-1].realPart );
      y1 = get_y( orbit[i-1].imagPart );
      x2 = get_x( orbit[i].realPart );
      y2 = get_y( orbit[i].imagPart );
     
      stroke(255,0,0);
      line(x1, y1, x2, y2);
     
      noStroke();
      fill(0,255,0);
      circle(x1, y1, 8);
    }
    circle(x2, y2, 8);
  }
}


void mouseMoved() {
  float aMouse = get_a(mouseX);
  float bMouse = get_b(mouseY);
 
  ComplexNumber orbitCenter = new ComplexNumber(aMouse, bMouse);
  ComplexNumber z = orbitCenter;
  trace.add( new PVector(mouseX, mouseY ));
 
  for(int i = 0; i < orbitSize; i++) {
    orbit[i] = z;
    z = z.multiply(z).add(orbitCenter);
  }
 
  mouseMoved = true;
  redraw();
}


void keyPressed() {
  trace = new ArrayList<PVector>();
}




class ComplexNumber {
  //FIELDS
  float realPart; //a    Why not int?
  float imagPart; //b
 
  //CONSTRUCTOR
  ComplexNumber( float rp, float ip ) {
    this.realPart = rp;
    this.imagPart = ip;
  }
 
  //METHODS
  void printMe() {
    println( this.realPart + "+" + this.imagPart + "i" );  //For now this is fine.
  }
 
 
  float absoluteValue() {  // |z| = sqrt(a^2 + b^2)
    return sqrt( pow(this.realPart,2) + pow(this.imagPart,2) ) ;
  }
 
 
  float absoluteValueSquared() {  // |z| = sqrt(a^2 + b^2)
    return pow(this.realPart,2) + pow(this.imagPart,2);
  }
 
  ComplexNumber add( ComplexNumber other ) {
    float newReal = this.realPart + other.realPart;
    float newImag = this.imagPart + other.imagPart;
   
    ComplexNumber newCN = new ComplexNumber(newReal, newImag);
   
    return newCN;
  }
 
 
  ComplexNumber multiply( ComplexNumber other ) {
    float newRealPart = this.realPart*other.realPart - this.imagPart*other.imagPart;
    float newImagPart =  this.realPart*other.imagPart + this.imagPart*other.realPart;
   
    ComplexNumber answer = new ComplexNumber( newRealPart, newImagPart);    
   
    return answer;
  }
 
}


void resetRatios() {
  unitsPerPixel = (aMax-aMin)/width;
  pixelsPerUnit = width/(aMax-aMin);
 
  aRange = aMax - aMin;
  bRange = bMax - bMin;
 
  aCentre = (aMin + aMax)/2;
  bCentre = (bMin + bMax)/2;
}


void resetStartingValues() {
  aMin = -1.8;
  aMax = 0.5;
  bMin = -1.15;
  bMax = 1.15;
 
 //aMin = 0.3770; //left edge of screen
 //aMax = 0.37705; //right edge of screen
 //bMax = 0.1730; //top edge of screen
 //bMin = 0.17295; //bottom edge of screen

  resetRatios();
}


float get_a(float x) {
  return aMin + x*unitsPerPixel;
}


float get_b(float y) {
  return bMax - y*unitsPerPixel;
}


float get_x(float a) {
  return (a-aMin)* pixelsPerUnit;
}

float get_y(float b) {
  return (bMax-b)* pixelsPerUnit;
}