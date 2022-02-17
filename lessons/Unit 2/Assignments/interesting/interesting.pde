// Goal: Have lots of frictionless objects without gravity. Clicking adds a bunch 

ArrayList<Particle> particles = new ArrayList<Particle>();

int startNum = 100;
int clickAdd = 25;
int radius = 3; // keep small -- no collision

void setup() {
    size(800, 800);
    noStroke();    
    textSize(25);
    textAlign(LEFT, TOP);

    for (int i = 0; i < startNum; i ++) {
        particles.add(new Particle(random(0, width), random(0, width), random(-10, 10)));
    }
}

void draw() {
    background(200);
    text(particles.size(), 0, 0);

    // update particles
    for (Particle particle : particles) {
        particle.display();
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