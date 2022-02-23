int r = 500;

int numBeams = 0;
int dBeams = 1;
int maxBeams = 250;

boolean looping = true;

void setup() {
    frameRate(10);
    size(1200, 1200);
}

void draw() {
    background(0);

    fill(0, 0, 0);
    stroke(255, 0, 0);
    circle(width-r, height/2, r*2);

    // draw the lines
    for (int i = 1; i < numBeams+1; i++) {
        float y1 = r - i*2*r/(numBeams+1);
        float theta = asin(y1/r);
        float x1 = r*cos(theta);

        // horizontal lines
        stroke(100, 100, 0);
        line(0, height/2 - y1, x1 + width - r, height/2 - y1);

        // reflected line
        stroke(255, 255, 0);
        float x2 = r*cos(PI+3*theta);
        float y2 = r*sin(PI+3*theta);
        line(x1 + width - r, height/2 - y1, x2 + width - r, height/2 - y2);
    }


    if (numBeams < 0 || maxBeams < numBeams) dBeams *= -1;
    numBeams += dBeams;
}

void keyPressed() {
    if (key == ' ') {
        if (looping) {
            noLoop();
            looping = false;
        } else {
            loop();
            looping = true;
        }
    }
}