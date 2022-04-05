/**
MOVE THE MOUSE TO CONTORL THE WEATHER

UP-DOWN IS HUMIDITY
LEFT-RIGHT IS WIND
MOUSE WHEEL FOR TEMPERATURE
 */

// adjustable settings isn't in the rubric and many of these break stuff if changed, so just change the number of stars lol
// settings:
int starCount = 1000;

// don't adjust:
float delay = 6;
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

ArrayList<Firefly> fireflies;

// keeps the sky different each run, but the same every night
int randomS = millis();

// smooths out the sky clouding effect over several cycles
int cloudSmoothness = 180; // how many frames to smooth over
float[] cloudBuffer;

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
    
    fireflies = new ArrayList<Firefly>(); 

    cloudBuffer = new float[cloudSmoothness];
}

// quick disclaimer that the numbers and formulas are somewhat janky due to lots of tweaking. 
void draw() {
    time = (time+0.2) % 256;

    mouseAffect();
    drawSky();

    sun.update();

    greySky();

    // fireflies spawn all the time but leave if they're not happy (a.k.a. i can't be bothered to code spawn logic)
    if (random(1) < 0.01) {
        fireflies.add(new Firefly(random(1)*width, random(0.8, 1)*height));
    }

    for (int i = fireflies.size() - 1; i >= 0; i--) {
        fireflies.get(i).update();
    }

    // affected temperature for this draw cycle only
    float tempTemp = temp + sun.warmth();

    // oof giant if block incoming

    // make fog when at max humidity and very little wind or cloud cover, also only during the morning lol
    if (0 < tempTemp && tempTemp < 20 && abs(wind) < 0.25 && cloudCover() < 4 && abs(time-day) <= dayNightFade*2) {
        // most likely at mouse 1/3 of the way down, and even so only 40% chance to be created
        if (random(0.3) > abs(float(mouseY)/height - 0.3) && random(1) < 0.4) {
            float h = random(5, 10);

            // any x position (including slightly off the screen), and height in the bottom half
            clouds.add(new Cloud(random(-0.25, 1.25)*width, random(0.5, 1)*height, h, "fog"));

            // drop humidity very little so it recovers faster and makes fog again sooner
            humidity = max(0, humidity - h/40);
        }
        
    // make thundercloud
    } else if (13 < tempTemp && tempTemp < 33 && abs(wind) == 1 && humidity >= maxHumidity()-0.15) {
        // i don't even know lol
        if (random(0.005*pow(tempTemp - 24, 2)+0.3) < humidity/2 + 0.25) {
            float h = random(humidity*4, humidity*20);

            // any x position and only in a narrow band near the top
            clouds.add(new Cloud(random(-0.25, 1.25)*width, random(0.1, 0.25)*height, h, "thunder"));
        
            // don't drop the humidity as much to promote frequent cloud formation
            humidity = max(0, humidity - h/30.0);
        }

    // rain cloud, requires some wind to form and mouse must not be at the top (not enough humidity)
    } else if (height/4 < mouseY && wind != 0 && humidity/maxHumidity() > 0.2) {
        // probability of creation varies proportional to how high the mouse is
        if (random(1) < (float(mouseY)/height)/1.5 - 0.2) {
            // also proportional to how far from the center, wind can't be 0, but near 0 should have few clouds
            if (random(1) < abs(wind)*2) {
                float h = random(2, 10);

                // any x position and anywhere in the top 1/3 of the screen
                clouds.add(new Cloud(random(-0.25, 1.25)*width, random(0.33)*height, h, "rain"));
                
                // subtract this cloud's size from the current humidity, don't let it go negative
                humidity = max(0, humidity - h/20.0);
            }
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

    thermometer();
}

// draws the sky with stars
void drawSky() {
    // black sky
    background(0);

    // draw the stars
    pushMatrix();
    translate(skyPivot.x, skyPivot.y);
    rotate(time*TWO_PI/256);

    fill(255);
    noStroke();
    randomSeed(randomS);

    // fill stars into a giant square with side lenght equal to twice the distance from the pivot to (0, 0)
    int sideLength = int(dist(skyPivot.x, skyPivot.y, 0, 0));

    for (int i = 0; i < starCount; i++) {
        circle(random(-sideLength, sideLength), random(-sideLength, sideLength), sqrt(random(16)));
    }
    
    popMatrix();
    
    // fill transparent (almost transparent, for some reason alpha = 0 isn't working)
    color sky = color(0, 0, 0, 1);

    // could do some really fancy function but this is easier to understand
    // smooths the color fade from day to night
    if (day - dayNightFade < time && time < day + dayNightFade) sky = color(3, 169, 244, map(time, day-dayNightFade, day+dayNightFade, 0, 255));
    if (night - dayNightFade < time && time < night + dayNightFade) sky = color(3, 169, 244, map(time, night-dayNightFade, night+dayNightFade, 255, 0));
    
    // if it's not fading just fill with sky
    if (day + dayNightFade <= time && time <= night - dayNightFade) sky = color(3, 169, 244);

    fill(sky);
    rectMode(CORNER);
    rect(0, 0, width, height);

    // reset the random seed for use elsewhere
    randomSeed(millis()*10);
}

// greys over the sun and sky with a grey, but still below the clouds and rain
void greySky() {
    float average = 0;
    for (int i = cloudSmoothness - 2; i > 0; i--) {
        average += cloudBuffer[i];
        cloudBuffer[i] = cloudBuffer[i+1]; 
    }

    float currentCover = cloudCover();

    average += currentCover;
    cloudBuffer[cloudSmoothness - 1] = currentCover;
    average /= cloudSmoothness;

    fill(lerpColor(color(0, 0, 0, 0), color(80, 80, 80, 180), sqrt(average/10)));

    rectMode(CORNER);
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

// value from 0 to 10 related to the current cloud cover
float cloudCover() {
    // total amount of cloudcover present
    float cloudVolume = 0;
    for (Cloud cloud : clouds) {
        cloudVolume += cloud.size;

        // thunderstorms are worth double
        if (cloud.type == "thunder") cloudVolume += cloud.size;
    }

    return 10.0/(1+pow(2.71828, -1*((cloudVolume/20.0)-5)));
}

// draws a thermometer on the screen from middle left to bottom left
void thermometer() {
    // body outline
    strokeWeight(15);
    stroke(0);
    line(15, height/2, 15, height-15);

    // body
    strokeWeight(14);
    stroke(150);
    line(15, height/2, 15, height-15);

    // bulb outline
    noStroke();
    fill(0);
    circle(15, height-15, 25);

    // bulb
    fill(255, 0, 0);
    circle(15, height-15, 24);

    // thermometer liquid
    strokeWeight(14);
    stroke(255, 0, 0);
    line(15, height-15, 15, map(temp+sun.warmth(), -20, 50, height-15, height/2));

    // 0 C indicator
    strokeWeight(3);
    stroke(0, 0, 255);
    int y = height/2 + (height-15 - height/2)*5/7; // yes i could've coded this more nicely but it's 9:30 and i've been at this like 5 hours and i'm so tired lol
    line(8, y, 22, y);
}