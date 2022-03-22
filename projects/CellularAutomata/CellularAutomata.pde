/*
Program Strcuture:
Terrain - global 2d array of finite user-defined size
          values are floats from 0 to 100, with water-level settable
Wind - global variable displayed by image in top left
Clouds - object in global list. containins water quantity, drawn in-line with the grid (can overlap)
         update has a chance to create a new water droplet, adding to global list of droplets
Water - object in global list. contains sediment and momentum, travel logic and stuff
*/

// USER DEFINED
int size = 100;            // number of squares to simulate (0, ~600]
int speed = 20;

float terrainScale = 0.05; // how small the terrain features are {0.03}

float waterLevel = 0.35;     // at what point is water level [0, 1] with 0 being no water. {0.35}
float temperature = 0.001;    // the probability of a water tile making a cloud [0, 1]; {0.001}
int terrainHardness = 4;  // the higher, the harder the terrain is

float windChaos = 0.05;     // probability that the wind changes direction {0.05}

// COLORS
color green = #5EF55B;
color orange = #FF5722;
color blue = #1976d2;
color darkBlue = #202F8F;
color brown = #646939;

// wind indicator arrow
PImage arrow;

// whether the wind is random or mouse-controlled
boolean mouseControl;

float[][] originalTerrain;
float[][] terrain;
float w;
ArrayList<Cloud> clouds;

// size by n array containing all the droplets at a particular x value, for quicker collision searching
ArrayList<ArrayList<Droplet>> droplets;

// only 45 degree angles
int wind;
PVector[] directions = {
    new PVector(0, 1),
    new PVector(1, 1),
    new PVector(1, 0),
    new PVector(1, -1),
    new PVector(0, -1),
    new PVector(-1, -1),
    new PVector(-1, 0),
    new PVector(-1, 1)
};

void setup() {
    // configure the noise
    noiseDetail(2, 0.5);

    size(800, 800);
    frameRate(speed);
    noStroke();

    w = width/size;
    mouseControl = false;

    setupTerrain();

    arrow = loadImage("./arrow.png");
}

void draw() {
    if (mouseControl) {
        for (int i = 0; i < directions.length; i++) {
            PVector mouseVector = new PVector(mouseX-width/2, mouseY-height/2);

            // find the direction closest to the mouse's position from the screen center
            if (PVector.angleBetween(mouseVector, directions[i]) < PI/8) {
                wind = i;
                break;
            }
        }
    } else {
        // change the wind directions randomly
        if (random(1) < windChaos) {
            // randomly either add or subtract one from the wind direction, to create an adjacent angle
            wind += round(random(1))*2 - 1; 

            // don't let it overflow
            if (wind == -1) wind = directions.length-1;
            wind = wind%directions.length;
        }
    }

    // draw all terrain squares
    rectMode(CORNER);
    for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
            // color differently based off altitude (height) of terrain
            float altitude = terrain[x][y];

            // if below the water level, make it blue, otherwise green though orange to represent height
            if (altitude <= waterLevel) fill(lerpColor(darkBlue, blue, map(altitude, 0, waterLevel, 0, 1)));
            else fill(lerpColor(green, orange, map(altitude, waterLevel, 1, 0, 1)));

            // draw in the square
            square(x*w, y*w, w);

            // random chance to make a cloud
            if (altitude <= waterLevel && random(1) < temperature) {
                // find the approximate minimum distance to land by looping in each cardinal directions
                int minDistance = size;
                for (PVector d : directions) {
                    PVector location = new PVector(x, y); 
                    int distance = 0;
                    try {
                        while(terrain[int(location.x)][int(location.y)] <= waterLevel) {
                            distance++;
                            location.add(d);
                        }
                    } catch (IndexOutOfBoundsException e) {}

                    if (distance < minDistance) minDistance = distance;
                }

                // TUNE: how big to make the clouds
                float content = minDistance;
                
                clouds.add(new Cloud(x, y, content));
            }
        }
    }

    // update all clouds first, backwords looping cause they can delete themselves
    // this spawns droplets but won't draw the clouds yet
    for (int i = clouds.size()-1; i >= 0; i--) {
        clouds.get(i).update();
    }

    int dropletCount = 0;
    // update every droplet at every x value
    for (int x = 0; x < size; x++) {
        for (int i = droplets.get(x).size()-1; i >= 0; i--) {
            Droplet droplet = droplets.get(x).get(i);
            // if it hasn't already been updated, update it again
            if (!droplet.updated) {
                droplet.update();
                dropletCount++;
            }
        }
    }

    // draw the clouds on top of everything
    for (Cloud cloud : clouds) cloud.draw();

    // reset the updated flag for next draw cycle
    for (int x = 0; x < size; x++) {
        for (int i = 0; i < droplets.get(x).size(); i++) {
            droplets.get(x).get(i).updated = false;
        }
    }

    // draw the arrow to show wind direction
    imageMode(CENTER);

    pushMatrix();
    translate(30, 30);
    rotate(directions[wind].heading());
    image(arrow, 0, 0, 60, 45);
    popMatrix();
}

// initializes the terrain and resets droplet and cloud lists
void setupTerrain() {
    wind = int(random(directions.length));

    terrain = new float[size][size];
    noiseSeed(millis());

    for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
            // add the noise from to separate noise slices, first small scale second large scale
            terrain[x][y] = pow(noise(x*terrainScale, y*terrainScale), 0.8);
        }
    }

    // might not work
    originalTerrain = terrain;

    clouds = new ArrayList<Cloud>();
    
    droplets = new ArrayList<ArrayList<Droplet>>();
    for (int i = 0; i < size; i++) {
        droplets.add(new ArrayList<Droplet>());
    }
}

void keyPressed() {
    if (key == 'r') {
        setupTerrain();
    }
}

// when they click the mouse transfer mouse control
void mousePressed() {
    mouseControl = !mouseControl;
}