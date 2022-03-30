// settings:
float delay = 5;
int starCount = 200;

// global weather variables
float humidity; // between 0 and 1
float temp; // between -10 and 40
float wind; // between -1 and 1

// day from 64 to 191, night from 0-63 and 192-255, smooth transition over like 32
float time;
int dayNightFade = 16;

// weather objects
/** 
Sun sun = new Sun(45, 20);
 */

// keeps the sky different each run, but the same every night
int randomS = millis();

void setup() {
    time = 0;
    humidity = 0;
    temp = 0;
    wind = 0;

    size(600, 600);
}

void draw() {
    time = (time+1) % 256;
    mouseAffect();
    println(time, humidity, wind);
    drawSky();
}

// draws the sky with stars
void drawSky() {
    // black sky
    background(0);

    // draw the stars
    fill(255);
    randomSeed(randomS);
    for (int i = 0; i < starCount; i++) {
        circle(random(width), random(height), sqrt(random(16)));
    }
    
    // fill transparent
    fill(0, 0);

    // could do some really fancy function but this is easier to understand
    // smooths the color fade from day to night
    if (64 - dayNightFade < time && time < 64 + dayNightFade) fill(3, 169, 244, map(time, 64-dayNightFade, 64+dayNightFade, 0, 255));
    if (192 - dayNightFade < time && time < 192 + dayNightFade) fill(3, 169, 244, map(time, 192-dayNightFade, 192+dayNightFade, 255, 0));
    
    // if it's not fading just fill with sky
    if (64 + dayNightFade <= time && time <= 192 - dayNightFade) fill(3, 169, 244);

    rect(0, 0, width, height);
}

void mouseAffect() {
    // HUMIDITY --------------------
    float targetHumidity;

    // top quarter has no humidity
    if (mouseY < height/4) targetHumidity = 0;

    // bottom quarter has max humidity
    else if (mouseY > 3*height/4) targetHumidity = maxHumidity();

    // even map between them
    else targetHumidity = map(mouseY, height/4, 3*height/4, 0, maxHumidity());

    humidity += (targetHumidity - humidity)/delay;

    if (humidity < 0.0001) humidity = 0;

    // WIND ------------------------
    float targetWind;
    
    // how far is it from the center from 0 to 1
    float n = abs(mouseX - width/2)/(width/2);
    println(n);

    if (n < 0.2) targetWind = 0;
    else if (n < 0.6) targetWind = map(n, 0.2, 0.6, 0, 1);
    else targetWind = 1;

    // affected by the direction of the mouse from the center
    if (targetWind != 0) targetWind *= (mouseX - width/2)/abs(mouseX - width/2);

    wind += (targetWind - wind)/delay;
    if (wind < 0.0001) wind = 0;
}

// maximum humidity given temperature
float maxHumidity() {
    // maps temperature to humidity, with max always positive
    return map(temp, -10, 40, 0.1, 1);
}