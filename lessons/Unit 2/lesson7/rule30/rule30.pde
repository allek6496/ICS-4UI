// idk i made some changes but it's still not perfect and im tired of this

int steps = 11;

boolean[] squares;
int length;
int w;
int i;

void settings() {
    w = ceil(300.0/steps);

    size(2*w*steps, w*steps);

    println(w);
}

void setup() {
    squares = new boolean[steps*2];

    frameRate(ceil(steps/10.0));
    background(100);

    if (w < 3) noStroke();

    // start conditions
    squares[steps] = true;
    
    // how many rows have been rendered
    i = 0;
}

void draw() {
    // stop looping on last frame
    if (i == steps-1) noLoop();

    for (int j = 0; j < steps*2; j++) {
        if (squares[j]) fill(255);
        else fill(0);

        square(w*j, w*i, w);
    }

    i++;
    updateSquares();
}

void updateSquares() {
    boolean[] newVals = new boolean[steps*2];

    for (int i = 1; i < steps*2-1; i++) {
        newVals[i] = rule(squares[i-1], squares[i], squares[i+1]);
    }

    squares = newVals;
}

// a is left, b is middle and c is right
boolean rule(boolean a, boolean b, boolean c) {
    // rule 30 logic
    if ((a && b) || (a && c) || (!a && !b && !c)) return false;
    else return true;
}