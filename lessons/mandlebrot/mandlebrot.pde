import java.math.BigDecimal;
import java.math.RoundingMode;

float zoom = 200; 

float aCenter = -0.5;
float bCenter = 0;

// dots per frame
int dpf = 1000;

int startRes = 3;
int resolution = startRes;
int xPos = 0;
int yPos = 0;

void setup() {
    size(600, 600);

    frameRate(120);
}

void draw() {
    for (int i = 0; i < dpf; i++) {
        if (resolution == 0) return;

        stroke(0);
        if (resolution == 1) stroke(mandlebrotSlow(xPos, yPos));
        else stroke(mandlebrotFast(xPos, yPos));

        point(xPos, yPos);

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
    while (i < 200 && sqrt(newA*newA + newB*newB) < 2) {
        float aTemp = newA;

        newA = newA*newA - newB*newB;
        newB = 2*aTemp*newB;

        newA += a;
        newB += b;

        i++;
    }

    if (i == 200) return color(0);
    else return rainbow(i);
}

color mandlebrotSlow(int x, int y) {
    BigDecimal a = new BigDecimal(x);
    BigDecimal b = new BigDecimal(y);

    a = a.subtract(new BigDecimal(width/2));
    b = b.subtract(new BigDecimal(height/2));

    a = a.divide(new BigDecimal(zoom), 2*SQRT_DIG.intValue(), RoundingMode.HALF_DOWN);
    b = b.divide(new BigDecimal(-1*zoom), 2*SQRT_DIG.intValue(), RoundingMode.HALF_DOWN);

    a = a.add(new BigDecimal(aCenter));
    b = b.add(new BigDecimal(bCenter)); 

    BigDecimal newA = a.add(BigDecimal.ZERO);
    BigDecimal newB = b.add(BigDecimal.ZERO);
    int i = 0;
    // up to 200 iterations, or when it goes outside circle radius 2
    while (i < 200 && bigSqrt(newA.multiply(newA).add(newB.multiply(newB))).compareTo(new BigDecimal(2)) <= 0) {
        BigDecimal aTemp = newA.add(BigDecimal.ZERO);

        newA = newA.multiply(newA).subtract(newB.multiply(newB));
        newB = aTemp.multiply(newB).multiply(new BigDecimal(2));

        newA = newA.add(a);
        newB = newB.add(b);
        i++;
    }

    if (i == 200) return color(0);
    else return rainbow(i);
}

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
    } else if (key == 'e') {
        zoom *= 1.5;
        // aCenter *= 1.5;
        // bCenter *= 1.5;
    }

    // reset the variables
    resolution = startRes;
    xPos = 0;
    yPos = 0;
    background(255);
}


color rainbow(float t) {
    t = t*5 % 200;

    return color(255*sin(t*TWO_PI/200), 255*sin(t*TWO_PI/200 + TWO_PI/3), 255*sin(t*TWO_PI/200 + TWO_PI*2/3));
}

/**
 * Private utility method used to compute the square root of a BigDecimal.
 * 
 * @author Luciano Culacciatti 
 * @url http://www.codeproject.com/Tips/257031/Implementing-SqrtRoot-in-BigDecimal
 */ 
private static final BigDecimal SQRT_DIG = new BigDecimal(150);
private static final BigDecimal SQRT_PRE = new BigDecimal(10).pow(10);

static BigDecimal sqrtNR  (BigDecimal c, BigDecimal xn, BigDecimal precision){
    BigDecimal fx = xn.pow(2).add(c.negate());
    BigDecimal fpx = xn.multiply(new BigDecimal(2));
    BigDecimal xn1 = fx.divide(fpx,2*SQRT_DIG.intValue(),RoundingMode.HALF_DOWN);
    xn1 = xn.add(xn1.negate());
    BigDecimal currentSquare = xn1.pow(2);
    BigDecimal currentPrecision = currentSquare.subtract(c);
    currentPrecision = currentPrecision.abs();
    if (currentPrecision.compareTo(precision) <= -1){
        return xn1;
    }
    return sqrtNR(c, xn1, precision);
}

static BigDecimal bigSqrt(BigDecimal c) {
		return sqrtNR(c,new BigDecimal(1),new BigDecimal(1).divide(SQRT_PRE));
}