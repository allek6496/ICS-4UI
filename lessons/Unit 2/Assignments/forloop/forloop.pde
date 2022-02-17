void setup() {
    size(1000, 600);
    imgSquare();
}

void imgSquare() {
    background(255);

    PImage art = loadImage("waifus/artWaifu.png");    
    PImage eng = loadImage("waifus/engWaifu.png");    
    PImage env = loadImage("waifus/envWaifu.png");    
    PImage health = loadImage("waifus/healthWaifu.png");    
    PImage math = loadImage("waifus/mathWaifu.png");    
    PImage sci = loadImage("waifus/sciWaifu.png");

    PImage[] waifus = {art, eng, env, health, math, sci};

    for (int x = 0; x <= width-93; x += 100) {
        for (int y = 0; y <= height-93; y += 100) {
            image(waifus[int(random(6))], x, y, 92, 92);
        }
    }
}

void halfAngle() {
    // will become false and stay false as soon as a case fails to equate LHS and RHS
    boolean works = true;

    // check for every degree from 0 to 30 inclusive
    for (float theta = 0; theta <= 30; theta += 1) {
        // convert to radians
        float rad = theta*PI/180;

        // find the left and right-hand side of the identity
        // abs is here because of +/- in the formula
        float LHS = abs( sin(rad / 2) );
        float RHS = abs( sqrt( (1 - cos(rad)) / 2 ) );

        // keep track of whether or not they all work (measure similarity rather than equivalency because of floating point precision)
        works &= abs(LHS - RHS) < 0.000001;

        // print for visual comparison
        println(theta, '-', RHS, '=', LHS);
    }

    // display if they all held true
    if (works) println("It works :D");
    else println("It doesn't work :(");
}

void tripleAngle() {
    // will become false and stay false as soon as a case fails to equate LHS and RHS
    boolean works = true;

    // check for every degree from 0 to 30 inclusive
    for (float theta = 0; theta <= 30; theta += 1) {
        // convert to radians
        float rad = theta*PI/180;

        // find the left and right-hand side of the identity
        float LHS = sin(3*rad);
        float RHS = 3*sin(rad) - 4*pow(sin(rad), 3);

        // keep track of whether or not they all work (measure similarity rather than equivalency because of floating point precision)
        works &= abs(LHS - RHS) < 0.000001;

        // print for visual comparison
        println(theta, '-', RHS, '=', LHS);
    }

    // display if they all held true
    if (works) println("It works :D");
    else println("It doesn't work :(");
}

void prices() {
    // keep track of the total price
    float total = 0;

    // sum every price from $5 to $100 at $0.50 increments
    for (float price = 5; price <= 100; price += 0.5) {
        total += price;
    }

    println(total);
}