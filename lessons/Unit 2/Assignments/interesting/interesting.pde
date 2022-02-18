// Goal: Have lots of frictionless objects without gravity. Clicking adds a bunch 

ArrayList<Particle> particles = new ArrayList<Particle>();

int lastTime;
int deltaT;
IntList prevDeltas;

int startNum = 100;
int clickAdd = 100;
int radius = 2; // keep small -- no collision

boolean slow = false;

void setup() {
    size(800, 800);
    noStroke();    
    textSize(25);
    textAlign(LEFT, TOP);

    prevDeltas = new IntList();

    for (int i = 0; i < startNum; i ++) {
        particles.add(new Particle(random(0, width), random(0, width), random(-10, 10)));
    }
}

void draw() {
    deltaT = millis() - lastTime;
    lastTime = millis();
    prevDeltas.append(deltaT);

    background(200);

    fill(0);
    String PARTICLES = " particles";
    text(str(particles.size()) + PARTICLES, 0, 0);
    
    if (prevDeltas.size() > 20) {
        prevDeltas.remove(0);

        int deltaSum = 0;
        for (int delta : prevDeltas) deltaSum += delta;

        text(str(round(1000/(deltaSum/prevDeltas.size()))) + " fps", 0, 25);
    }

    if (slow) {
        deltaT /= 10;
    }

    BarnesHutt bh = new BarnesHutt(particles);

    // toggle to show the grid lines (don't for many particles)
    // bh.display();

    // update particles
    for (Particle particle : particles) {
        particle.update(bh.force(particle));
    }
}

void mousePressed() {
    // negative on left click
    if (mouseButton == LEFT) {
        float angle = TWO_PI/float(clickAdd);
        float r = clickAdd*radius/TWO_PI;
        for (int i = 0; i < clickAdd; i++) {
            particles.add(new Particle(mouseX + r*cos(i*angle), mouseY + r*sin(i*angle), random(Particle.minCharge, 0)));
        }
    }

    if (mouseButton == RIGHT) {
        float angle = TWO_PI/float(clickAdd);
        float r = clickAdd*radius/TWO_PI;
        for (int i = 0; i < clickAdd; i++) {
            particles.add(new Particle(mouseX + r*cos(i*angle), mouseY + r*sin(i*angle), random(0, Particle.maxCharge)));
        }
    }
}

void keyPressed() {    
    if (key == ' ') {
        slow = true;
        frameRate(30);
    }
}

void keyReleased() {
    if (key == ' ') {
        slow = false;
        frameRate(60);
    }
}