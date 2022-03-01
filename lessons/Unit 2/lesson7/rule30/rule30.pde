boolean[] squares;
int length = 100;
int w;
int i;

void setup() {
    // normal setup
    size(600, 600);
    w = width/length;
    i = 0;

    squares = new boolean[length];

    frameRate(2);
    background(100);

    // start conditions
    squares[50] = true;
}

void draw() {
    // don't keep looping if it won't be shown
    if (i*w >= height) return;

    int y = w*i;
    for (int j = 0; j < length; j++) {
        int x = j*w;

        if (squares[j]) fill(255);
        else fill(0);

        square(x, y, w);
    }

    i++;
    updateSquares();
}

void updateSquares() {
    boolean[] newVals = new boolean[length];

    // positions -1 and length are always false and can't be changed
    for (int i = 0; i < length; i++) {
        boolean a, b, c;
        if (i == 0) a = false;
        else a = squares[i-1];

        b = squares[i];

        if (i == length-1) c = false;
        else c = squares[i+1];

        newVals[i] = rule(a, b, c);
    }

    squares = newVals;
}

// a is left, b is middle and c is right
boolean rule(boolean a, boolean b, boolean c) {
    // rule 30 logic
    if ((a && b) || (a && c) || (!a && !b && !c)) return false;
    else return true;
}