int r = 250;

int numBeams = 0;
int dBeams = 1;
int maxBeams = 100;

void setup() {
    frameRate(1);
    size(600, 600);
}

void draw() {
    background(0);

    fill(0, 0, 0);
    stroke(255, 0, 0);
    circle(width-r, height/2, r*2);

    // draw the lines
    fill(255, 255, 0);
    for (int i = 1; i < numBeams+1; i++) {
        // horizontal lines
        float y1 = width/2-r + i*2*r/(numBeams+1);
        println(y1);
        float theta = asin(y1/r);
        float x1 = r*cos(theta);
        line(0, y1, x1, y1);

        // reflected line
        float x2 = r*cos(180+3*theta);
        float y2 = r*sin(180+3*theta);
        line(x1, y1, x2, y2);

        // radius
        fill(255, 0, 0);
        line(width-r, height/2, x1, y1);
    }


    if (numBeams < 0 || maxBeams < numBeams) dBeams *= -1;
    numBeams += dBeams;
}