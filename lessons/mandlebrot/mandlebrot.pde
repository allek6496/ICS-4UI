import java.math.BigDecimal;
import java.math.RoundingMode;

// leftover bit from: https://stackoverflow.com/questions/13649703/square-root-of-bigdecimal-in-java
private static final BigDecimal SQRT_DIG = new BigDecimal(150);

float zoom = 200; 

Double aCenter = -0.5d;
Double bCenter = 0d;

// dots per frame
int dpf = 1000;

int startRes = 3;
int resolution = startRes;
int xPos = 0;
int yPos = 0;

void setup() {
    size(800, 800);

    frameRate(120);
    noSmooth();
    textSize(20);
    textAlign(LEFT, TOP);
}

void draw() {
    fill(0);
    text(nf(zoom, 0, 0) + 'x', 0, 0);

    for (int i = 0; i < dpf; i++) {
        if (resolution == 0) return;

        stroke(0);
        if ((resolution == 1 && zoom > 10000) || zoom > 100000) stroke(mandlebrotMedium(xPos, yPos));
        else stroke(mandlebrotFast(xPos, yPos));

        if (resolution == 1) point(xPos, yPos);
        else circle(xPos, yPos, resolution);

        xPos += resolution;
        if (xPos >= width) {
            yPos += resolution;
            xPos = 0;
        } if (yPos >= height) {
            xPos = 0;
            yPos = 0;
        
            resolution--;
        }
    }
}

color mandlebrotFast(int x, int y) {
    float a = float(x);
    float b = float(y);

    a -= width/2;
    b -= height/2;
    a /= zoom;
    b /= -1*zoom;
    a += aCenter;
    b += bCenter;

    float newA = a;
    float newB = b;
    int i = 0;
    while (i < 100 && newA*newA + newB*newB < 4) {
        float aTemp = newA;

        newA = newA*newA - newB*newB;
        newB = 2*aTemp*newB;

        newA += a;
        newB += b;

        i++;
    }

    if (i == 100) return color(0);
    else return rainbow(i, 200);
}

color mandlebrotMedium(int x, int y) {
    Double a = new Double(x);
    Double b = new Double(y);

    a -= width/2;
    b -= height/2;
    a /= zoom;
    b /= -1*zoom;
    a += aCenter;
    b += bCenter;

    Double newA = a;
    Double newB = b;
    int i = 0;
    while (i < 2000 && newA*newA + newB*newB < 4) {
        Double aTemp = newA;

        newA = newA*newA - newB*newB + a;
        newB = 2*aTemp*newB + b;

        i++;
    }

    if (i == 2000) return color(0);
    else return rainbow(i, 1000);
}

// color mandlebrotSlow(int x, int y) {
//     BigDecimal a = new BigDecimal(x);
//     BigDecimal b = new BigDecimal(y);

//     a = a.subtract(new BigDecimal(width/2));
//     b = b.subtract(new BigDecimal(height/2));

//     a = a.divide(new BigDecimal(zoom), 10, RoundingMode.HALF_DOWN);
//     b = b.divide(new BigDecimal(-1*zoom), 10, RoundingMode.HALF_DOWN);

//     a = a.add(new BigDecimal(aCenter));
//     b = b.add(new BigDecimal(bCenter)); 

//     BigDecimal newA = a.add(BigDecimal.ZERO);
//     BigDecimal newB = b.add(BigDecimal.ZERO);
//     int i = 0;
//     // up to 200 iterations, or when it goes outside circle radius 2
//     while (i < 50 && newA.pow(2).add(newB.pow(2)).compareTo(BigDecimal.valueOf(4)) <= 0) {
//         BigDecimal aTemp = newA.add(BigDecimal.ZERO);

//         newA = newA.multiply(newA).subtract(newB.multiply(newB)).add(a);
//         newB = aTemp.multiply(newB).multiply(BigDecimal.valueOf(2)).add(b);
//         i++;
//         if (i > 10) println(i);
//     }

//     if (i == 200) return color(0);
//     else return rainbow(i);
// }

void keyPressed() {
    if (key == 'w') {
        bCenter += 100.0/zoom;
    } else if (key == 's') {
        bCenter -= 100.0/zoom;
    } else if (key == 'a') {
        aCenter -= 100.0/zoom;
    } else if (key == 'd') {
        aCenter += 100.0/zoom;
    } else if (key == 'q') {
        zoom /= 1.5;
        // aCenter /= 1.5;
        // bCenter /= 1.5;
    } else if (key == 'e' && zoom < 10000000000f) { // max zoom, no further detail after this point
        zoom *= 1.5;
        // aCenter *= 1.5;
        // bCenter *= 1.5;
    } else if (key == 'r') {
        zoom = 200;
        aCenter = -0.5d;
        bCenter = 0d;
    }

    // reset the variables
    resolution = startRes;
    xPos = 0;
    yPos = 0;
    background(255);
}


color rainbow(float t, int n) {
    t = t % n;

    return color(255*sin(t*TWO_PI/200), 255*sin(t*TWO_PI/200 + TWO_PI/3), 255*sin(t*TWO_PI/200 + TWO_PI*2/3));
}
