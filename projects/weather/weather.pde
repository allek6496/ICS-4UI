// TODO: the sun sunset and sky fade timings are all janky
// they work, but can't be changed. Make it all decided on where the sun is in the sky


// settings:
float delay = 5;
int starCount = 1000;
int dayNightFade = 10; // breaks if this becomes too large, depends on dayLength
int dayLength = 128; // strictly less than 255

// global weather variables
float humidity; // between 0 and 1
float temp; // between -10 and 40
float wind; // between -1 and 1

// day length based on dayLength, night from 0-day and night-255, smooth transition over like dayNightFade
float time;
float day;
float night;

PVector skyPivot;

// weather objects
Sun sun;
ArrayList<Cloud> clouds;

// keeps the sky different each run, but the same every night
int randomS = millis();

void setup() {
    size(600, 600);

    time = 0;
    day = 128-dayLength/2;
    night = 128+dayLength/2;

    humidity = 0;
    temp = 10;
    wind = 0;

    skyPivot = new PVector(width*2, height*3/4);

    sun = new Sun(20);
    clouds = new ArrayList<Cloud>();
}

// quick disclaimer that the numbers and formulas are somewhat janky due to lots of tweaking. 
void draw() {
    println(map(3, 1, 3, 0, 1));
    time = (time+0.2) % 256;

    mouseAffect();
    drawSky();

    sun.update();

    // affected temperature for this draw cycle only
    float tempTemp = temp + sun.warmth();

    // make fog
    if (humidity > maxHumidity() && 0.1 < abs(wind) && abs(wind) < 0.8 && abs(time-day) < dayNightFade*2) {
    
    // make thundercloud
    } else if (0 < tempTemp && tempTemp < 20 && wind == 1 && humidity >= maxHumidity()) {
        if (random() < humidity/2 + 0.25) {
            float h = random(humidity, humidity*20);
            clouds.add(new Cloud(-1*(sign(wind)/2.0 - 0.5)*width, random(0.1, 0.25)*height, h, "thunder"));
        }
    // chance to make a cloud
    } else if (height/4 < mouseY && wind != 0) {
        // probabilities vary proportional to humididty but inversely with temperature. this makes higher and lower temperatures make fewer clouds
        if (random(map()) < humidity/3 + 0.05) {
            float h = random(humidity, humidity*20);
            clouds.add(new Cloud(-1*(sign(wind)/2.0 - 0.5)*width, random(0.33)*height, h, "rain"));
            
            // subtract this cloud's size from the current humidity, don't let it go negative
            humidity = max(0, humidity - h/20.0);
        }
    }

    // update the rain first
    for (Cloud cloud : clouds) {
        cloud.updateRain();
    }

    // then update all the clouds
    for (int i = clouds.size() - 1; i >= 0; i--) {
        clouds.get(i).update();
    }
}

// draws the sky with stars
void drawSky() {
    // black sky
    background(0);

    // draw the stars
    pushMatrix();
    translate(skyPivot.x, skyPivot.y);
    rotate(time*TWO_PI/255);

    fill(255);
    randomSeed(randomS);

    // fill stars into a giant square with side lenght equal to twice the distance from the pivot to (0, 0)
    int sideLength = int(dist(skyPivot.x, skyPivot.y, 0, 0));

    for (int i = 0; i < starCount; i++) {
        circle(random(-sideLength, sideLength), random(-sideLength, sideLength), sqrt(random(16)));
    }
    
    popMatrix();
    
    // fill transparent
    fill(0, 0);

    // could do some really fancy function but this is easier to understand
    // smooths the color fade from day to night
    if (day - dayNightFade < time && time < day + dayNightFade) fill(3, 169, 244, map(time, day-dayNightFade, day+dayNightFade, 0, 255));
    if (night - dayNightFade < time && time < night + dayNightFade) fill(3, 169, 244, map(time, night-dayNightFade, night+dayNightFade, 255, 0));
    
    // if it's not fading just fill with sky
    if (day + dayNightFade <= time && time <= night - dayNightFade) fill(3, 169, 244);

    rectMode(CORNER);
    rect(0, 0, width, height);

    // reset the random seed for use elsewhere
    randomSeed(millis()*10);
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

    if (abs(humidity-targetHumidity) < 0.005) humidity = targetHumidity;

    // WIND ------------------------
    float targetWind;
    
    // how far is it from the center from 0 to 1
    float n = abs(mouseX - width/2)/float(width/2);

    if (n < 0.15) targetWind = 0;
    else if (n < 0.8) targetWind = map(n, 0.15, 0.8, 0, 1);
    else targetWind = 1;

    // affected by the direction of the mouse from the center
    if (targetWind != 0) targetWind *= (mouseX - width/2)/abs(mouseX - width/2);

    wind += (targetWind - wind)/delay;
    if (abs(wind-targetWind) < 0.005) wind = targetWind;
}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    
    if (-10 <= temp - e && temp - e <= 40) {
        temp -= e;
        // println(temp);
    }
}

// maximum humidity given temperature
float maxHumidity() {
    // maps temperature to humidity, with max always positive
    // i'm aware 
    return map(temp + sun.warmth(), -20, 50, 0.1, 1);
}

float sign(float num) {
    if (num == 0) return 0;
    
    return abs(num)/num;
}