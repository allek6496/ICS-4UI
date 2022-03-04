/*
TODO:
1. generate terrain
2. generate clouds
    2a. spawn clouds
    2b. blow with wind
3. clouds drop rain
    3a. clouds have a capacity which decreases as rain falls
    3b. clouds disappear when empty (possibly shrink as rainfall occurs)
4. rain actions
    4a. rain travels downhill with momentum
    4b. rain picks up sediment

Program Strcuture:
Terrain - global 2d array of finite user-defined size
          values are floats from 0 to 100, with water-level settable
Wind - global variable displayed by image in top left
Clouds - object in global list. containins water quantity, drawn in-line with the grid (can overlap)
         update has a chance to create a new water droplet, adding to global list of droplets
Water - object in global list. contains sediment and momentum, travel logic and stuff
*/

// USER DEFINED
int size = 200;            // number of squares to simulate (0, ~600]

float terrainScale = 0.04; // how small the terrain features are

float waterLevel = 0.3;     // at what point is water level [0, 1] with 0 being no water.
float temperature = 0.1;    // the probability of a water tile making a cloud [0, 1];

// COLORS
color green = #5EF55B;
color orange = #FF5722;
color blue = #1976d2;

float[][] terrain;
float w;
ArrayList<Clouds> clouds;

// only 45 degree angles
PVector wind;

void setup() {
    // configure the noise
    noiseDetail(3, 0.5);

    size(800, 800);
    frameRate(5);
    noStroke();

    w = width/size;

    setupTerrain();

    clouds = new ArrayList<Clouds>();
}

void draw() {
    wind = new PVector(round(random(1)), round(random(1)));

    for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
            // add the noise from to separate noise slices, first small scale second large scale
            float altitude = terrain[x][y];
            if (altitude <= waterLevel) fill(blue);
            else fill(lerpColor(green, orange, map(altitude, waterLevel, 1, 0, 1)));
            square(x*w, y*w, w);

            if (random(1) < temperature) {
                float content = 0;
                for (PVector d : )

                clouds.add(new Cloud(x, y, content));
            }
        }
    }
}

void setupTerrain() {
    terrain = new float[size][size];
    noiseSeed(millis());

    for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
            // add the noise from to separate noise slices, first small scale second large scale
            terrain[x][y] = noise(x*terrainScale, y*terrainScale);
        }
    }
}

void keyPressed() {
    if (key == 'r') {
        setupTerrain();
    }
}