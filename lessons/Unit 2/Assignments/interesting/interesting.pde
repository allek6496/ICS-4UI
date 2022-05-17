// Goal: Have lots of frictionless objects without gravity. Clicking adds a bunch 

int lastTime;
int deltaT;
IntList prevDeltas;

ArrayList<Particle> particles;

int startNum = 0;
int clickAdd = 500;
int radius = 10; // keep small -- no collision

String clickAction = "CIRCLE"; // CIRCLE, GRID, RANDOM

boolean slow = false;

void setup() {
    size(1600, 1600);

    textSize(25);
    textAlign(LEFT, TOP);

    particles = new ArrayList<Particle>();
    prevDeltas = new IntList();

    // add all the starting particles
    for (int i = 0; i < startNum; i ++) {
        particles.add(new Particle(random(0, width), random(0, width), random(Particle.minCharge, Particle.maxCharge)));
    }
}

void draw() {
    background(200);

    // keep track of time elapsed for the previous draw loop, and append to prevDeltas to calculate rolling average FPS
    deltaT = millis() - lastTime;
    lastTime = millis();
    prevDeltas.append(deltaT);

    // slow motion just reduces the speed of the particles, and not the speed of calculation
    if (slow) {
        deltaT /= 10;
    }

    int deltaSum = 0;
    int fps = 0;
    // calculate 20 frame rolling average for smooth fps estimation
    if (prevDeltas.size() > 20) {
        prevDeltas.remove(0);

        for (int delta : prevDeltas) deltaSum += delta;

        fps = round(1000/(deltaSum/prevDeltas.size()));
    }

    // remake the tree on every frame (faster than looping through each particle for each particle)
    // time complexity O(nlogn)
    BarnesHutt bh = new BarnesHutt(particles);

    // toggle to show the grid lines, slow and messy when there are a lot of particles
    // bh.display();

    // update particles in a random order
    IntList particleOrder = new IntList();
    for (int i = 0; i < particles.size(); i++) {
        particleOrder.append(i);
    }

    while (particleOrder.size() > 0) {
        int r = int(random(particleOrder.size()));
        int next = particleOrder.get(r);

        particles.get(next).update(bh.force(particles.get(next)));

        particleOrder.remove(r);
    }

    fill(0);
    text(str(particles.size()) + " Particles", 0, 0);

    if(prevDeltas.size() == 20) text(str(fps) + " fps", 0, 25);

    text("Press r to reset", 0, 50);
}

void mousePressed() {
    // negative on left click
    float charge;

    // create the particles in a non-intersecting circle around the mouse
    if (clickAction == "CIRCLE") {
        // set the charge to +/- based off which mouse button was clicked
        if (mouseButton == LEFT) {
            float angle = TWO_PI/float(clickAdd);
            float r = clickAdd*radius/TWO_PI;

            for (int i = 0; i < clickAdd; i++) {
                charge = random(Particle.minCharge, 0);
                particles.add(new Particle(mouseX + r*cos(i*angle), mouseY + r*sin(i*angle), charge));
            }
        }
        else if (mouseButton == RIGHT) {
            float angle = TWO_PI/float(clickAdd);
            float r = clickAdd*radius/TWO_PI;

            for (int i = 0; i < clickAdd; i++) {
                charge = random(0, Particle.maxCharge);
                particles.add(new Particle(mouseX + r*cos(i*angle), mouseY + r*sin(i*angle), charge));
            }
        }
    }

    // create the particles in a grid around the mouse (square nearest to clickAdd);
    else if (clickAction == "GRID") {
        // set the charge to +/- based off which mouse button was clicked
        if (mouseButton == LEFT) {
            for (int x = -int(sqrt(clickAdd)/2); x <= int(sqrt(clickAdd)/2); x++) {
                for (int y = -int(sqrt(clickAdd)/2); y <= int(sqrt(clickAdd)/2); y++) {
                    charge = random(Particle.minCharge, 0); 

                    particles.add(new Particle(mouseX + x*radius, mouseY + y*radius, charge));
                }
            }
        }
        else if (mouseButton == RIGHT) {
            for (int x = -int(sqrt(clickAdd)/2); x <= int(sqrt(clickAdd)/2); x++) {
                for (int y = -int(sqrt(clickAdd)/2); y <= int(sqrt(clickAdd)/2); y++) {
                    charge = random(0, Particle.maxCharge); 

                    particles.add(new Particle(mouseX + x*radius, mouseY + y*radius, charge));
                }
            }
        }
    }

    // just add them in random locations on the screen
    else if (clickAction == "RANDOM") {
        // set the charge to +/- based off which mouse button was clicked
        if (mouseButton == LEFT) {
            for (int i = 0; i < clickAdd; i++) {
                charge = random(Particle.minCharge, 0); 

                particles.add(new Particle(random(0, width), random(0, height), charge));
            }
        }

        else if (mouseButton == RIGHT) {
            for (int i = 0; i < clickAdd; i++) {
                charge = random(0, Particle.maxCharge); 

                particles.add(new Particle(random(0, width), random(0, height), charge));
            }
        }
    }
}

// slow motion on
void keyPressed() {    
    if (key == ' ') {
        slow = true;
        frameRate(30);
    } else if (key == 'r') {
        particles = new ArrayList<Particle>();
    }
}

// slow motion off
void keyReleased() {
    if (key == ' ') {
        slow = false;
        frameRate(60);
    }
}