class Cloud {
    float content;
    int x;
    int y;
    int age;

    Cloud(int x,int y, float content) {
        this.x = x;
        this.y = y;
        this.content = content;
        age = 0;
    }

    void update() {
        if (content <= 0) clouds.remove(this);

        age++;

        x += directions[wind].x;
        y += directions[wind].y;

        if (x < 0 || y < 0 || size <= x || size <= y) {
            // D: if it's oob, get smaller
            content -= 0.25;
        } else {        
            // TUNE: rain probability and age effect, seems fine but could drop multiple
            while (content >= 1 && random(1) < (terrain[x][y] - waterLevel)*age/30) rain();
        }
    }

    void draw() {
        // draw the cloud
        rectMode(CENTER);
        fill(255, 100);

        // TUNE: size of cloud relative to content
        rect(x*w, y*w, w*content, w*content, w*sqrt(2));
    }

    // create a droplet somewhere under the cloud (but on the terrain), with a momentum of 1
    void rain() {
        int newx = max(0, min(round(random(x-content/2, x+content/2)), size-1));
        int newy = max(0, min(round(random(y-content/2, y+content/2)), size-1));

        droplets.get(newx).add(new Droplet(newx, newy, 1));

        content--;
    }
}

class Droplet {
    // there should only be one droplet per square
    int x;
    int y;

    // momentum is split into two parts, a magnitude and a cardinal direction. this just makes stuff easier
    float momentum;
    PVector direction;

    // how much dirt/rock the droplet carries
    float sediment;

    // stores whether or not this droplet has been updated this frame
    // this is necessary because they move around within the update list, while updating
    boolean updated;

    Droplet(int x, int y, float content) {
        this.x = x;
        this.y = y;

        momentum = content;
        direction = new PVector(0, 0); // don't start with a direction
        
        sediment = 0;

        updated = false;
    }

    void update() {
        updated = true;

        float altitude = terrain[x][y];

        // pick up material from the ground
        // https://www.desmos.com/calculator/sbrme4joy4
        float depth = originalTerrain[x][y] - altitude;
        float material = 0.4*sqrt(momentum)/pow(depth + 1.5, 6);
        float materialCapacity = sqrt(momentum) / 20;

        // if it tries to pick up too much, pick up exactly maximum amount
        if (material + sediment > materialCapacity) {
            // don't let it pick up negative material
            material = max(materialCapacity - sediment, 0);
        }

        sediment += material;
        terrain[x][y] -= material;

        // each number represents the probability of that index in the global array `directions` being chosen as the offset to the new position. this will be normalized to sum to 1
        float[] probabilities = {0, 0, 0, 0, 0, 0, 0, 0};

        // rolling sum for later normalization
        float probSum = 0;

        // add weighting to probabilities based off which square has the greatest drop, with any downhill square being possible
        for (int i = 0; i < directions.length; i++) {
            PVector d = directions[i];

            // add a probability proportional to the square of the drop, make the lowest square most likely
            try {
                float newAlt = terrain[int(x + d.x)][int(y+d.y)];
                
                float altDiff = altitude - newAlt;

                // if this is where the momentum is pushing the droplet, only downhill
                // this could be cleaner but it works
                if (d.heading() == direction.heading() && direction.mag() != 0) {
                    // TUNE: momentum effect
                    // https://www.desmos.com/calculator/ol5cjjdk7b
                    probabilities[i] = 0.05/(1+1/momentum) + altDiff;

                    // don't let it assign a negative probability
                    if (probabilities[i] < 0) probabilities[i] = 0;

                    probSum += probabilities[i];

                // otherwise if it's downhill
                } else if (altDiff > 0) {
                    probabilities[i] += altDiff;
                    probSum += probabilities[i];
                }
            } catch (IndexOutOfBoundsException e) {}
        }

        if (probSum == 0) {
            direction = new PVector(0, 0);
        } else {
            for (int i = 0; i < probabilities.length; i++) {
                probabilities[i] = probabilities[i]/probSum;
            }

            // randomly chose a direction to move in
            float rand = random(1);
            for (int i = 0; i < probabilities.length; i++) {
                rand -= probabilities[i];
                
                if (rand <= 0) {
                    // TUNE: greatly reduce momentum on sharp turns
                    if (PVector.angleBetween(direction, directions[i]) >= 3*PI/4) momentum /= 2;

                    direction = directions[i];
                    break;
                }
            }
        }

        int oldx = x;
        x += direction.x;
        y += direction.y;


        // remove the droplet from the old x position
        droplets.get(oldx).remove(this);

        // if it's hit water level, just remove the droplet
        if (terrain[x][y] <= waterLevel) {
            terrain[x][y] += sediment;
            return;
        }

        // check if it's intersecting with another droplet
        Droplet intersecting = null;
        for (Droplet droplet : droplets.get(x)) {
            if (droplet != this && droplet.y == y) {
                intersecting = droplet;
                break;
            }
        }

        // if it did intersect with something
        if (intersecting != null) {
            // keep the direction of the droplet with highest momentum
            if (momentum > intersecting.momentum) {
                intersecting.direction = direction;
            }

            // combine the momentums and material content
            intersecting.momentum += momentum;
            intersecting.sediment += sediment;

            return;
        }

        // TUNE: momentum dampening
        momentum -= 0.02;

        // TUNE: raise momentum going downhill
        momentum += (altitude - terrain[x][y])/5;

        // put material back down on the ground (similar to above, but not worth making into a function)
        float newMaterialCapacity = sqrt(momentum) / 20;

        // if it has too much, drop exactly to max amount
        if (sediment > newMaterialCapacity) {
            terrain[x][y] += sediment - newMaterialCapacity;
            sediment = newMaterialCapacity;
        }

        // if momentum has fallen to 0 remove the droplet
        // TODO: deposit material on ground
        if (momentum <= 0) return;

        droplets.get(x).add(this);
        draw();
    }

    void draw() {
        // https://www.desmos.com/calculator/0rxocd2kcz
        // modified sigmoid function, approaches no difference as content => +infinity
        // i just like sigmoids, they're handy and robust
        float scaleMod = 1/(1+pow(2.71828, 1.5-momentum));

        fill(sediment*10, sediment*10, 255/pow(sediment+1, 5));
        
        // if there is no matching direction draw circle
        if (direction.mag() == 0) {
            circle(w*(x+0.5), w*(y+0.5), scaleMod*w);

        // otherwise draw a roughly teardrop shape
        } else {
            pushMatrix();

            // center the origin on the middle of the square in question
            translate(w*(x+0.5), w*(y+0.5));
            
            // rotate in the appropriate direction
            rotate(direction.heading() - PI/2);

            // scale only the width
            scale(scaleMod, 1);

            beginShape();
            curveVertex(0, -w/2);
            curveVertex(0, -w/2);

            curveVertex(-w/2, w/6);
            curveVertex(0, w/2);
            curveVertex(w/2, w/6);
            
            curveVertex(0, -w/2);
            curveVertex(0, -w/2);
            endShape();

            popMatrix();
        }
    }
}