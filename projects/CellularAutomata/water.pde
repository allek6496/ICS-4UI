class Cloud {
    // how many droplets are inside this cloud
    float content;

    // location
    int x;
    int y;

    // how many generations the cloud has existed for
    int age;

    Cloud(int x, int y, float content) {
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
            // if it's oob, get smaller
            content -= 0.25;
        } else {        
            // TUNE: rain probability and age effect
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

    // create a droplet somewhere under the cloud, with a momentum of 0.1
    void rain() {
        int newx = max(0, min(round(random(x-content/2, x+content/2)), size-1));
        int newy = max(0, min(round(random(y-content/2, y+content/2)), size-1));

        droplets.get(newx).add(new Droplet(newx, newy, 0.1));

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

    // don't let it pick up material when it spawns or sitting still
    boolean moved;

    Droplet(int x, int y, float content) {
        this.x = x;
        this.y = y;

        momentum = content;
        direction = new PVector(0, 0); 
        
        sediment = 0;

        updated = false;
        moved = false;
    }

    void update() {
        updated = true;

        float altitude = terrain[x][y];

        // only pick up material if it's moved
        if (moved) {
            // pick up material from the ground
            // https://www.desmos.com/calculator/avri8fot0e
            float depth = originalTerrain[x][y] - altitude;
            float material = 0.01*sqrt(momentum)/pow(depth + 1.2, 4);

            // maximum amount that it can hold
            float materialCapacity = sqrt(momentum) / 10;

            // if it tries to pick up too much, pick up exactly maximum amount
            if (material + sediment > materialCapacity) {
                // don't let it pick up negative material
                material = max(materialCapacity - sediment, 0);
            }

            sediment += material;
            terrain[x][y] -= material;
        }

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
                float newAlt2 = terrain[int(x + 2*d.x)][int(y + 2*d.y)];
                
                float altDiff = altitude - newAlt;
                float altDiff2 = altitude - newAlt2;

                // add probability proportional to how steep. slight uphill values can be balanced by steep downhill on the other side            
                probabilities[i] += altDiff;

                // lesser effect from two squares away, to smooth out the movement
                probabilities[i] += altDiff2/1.5;

                // don't let it assign a negative probability
                if (probabilities[i] < 0) probabilities[i] = 0;
                else {
                    // square to reduce randomness
                    probabilities[i] = pow(probabilities[i], 2);
                    probSum += probabilities[i];
                }
            } catch (IndexOutOfBoundsException e) {}
        }

        // if nowhere is downhill at all, don't move
        if (probSum == 0) {
            direction = new PVector(0, 0);
            moved = false;
        } else {
            // it's fine to update moved now, it has to move somewhere
            moved = true;

            // normalize the probabilities, make the sum of every direction 1
            for (int i = 0; i < probabilities.length; i++) {
                probabilities[i] = probabilities[i]/probSum;
            }

            // randomly chose a direction to move in
            float rand = random(1);
            for (int i = 0; i < probabilities.length; i++) {
                rand -= probabilities[i];
                
                if (rand <= 0) {
                    // greatly reduce momentum on sharp turns, to prevent oscillations
                    if (PVector.angleBetween(direction, directions[i]) >= 3*PI/4) momentum /= 2;

                    direction = directions[i];
                    break;
                }
            }
        }

        // remove the droplet from the old x position
        droplets.get(x).remove(this);

        x += direction.x;
        y += direction.y;

        // if it's OOB, just delete it 
        if (x < 0 || size <= x || y < 0 || size <= y) return;

        // if it's hit water level, move the sediment to a local minima
        if (terrain[x][y] <= waterLevel) {
            
            // if it's not moving or at a local minima (i.e. a one square water spot)
            if (direction.mag() == 0) {
                terrain[x][y] += sediment;

            // find the first local minima and add the sediment to that point
            } else {
                PVector p = new PVector(x, y);

                boolean done = false;
                while (!done) {
                    // keep track of the lowest of the neighbouring squares
                    PVector minPoint = new PVector(p.x, p.y);
                    float minHeight = terrain[int(p.x)][int(p.y)];

                    for (PVector d : directions) {
                        // get the square in this direction
                        PVector newPoint = new PVector(p.x, p.y);
                        newPoint.add(d);

                        // find the height of the square in this direction
                        float newHeight = 1;
                        try {
                            newHeight = terrain[int(newPoint.x)][int(newPoint.y)];    
                        } catch (IndexOutOfBoundsException e) {}
                        
                        // if it's lower, update the new minimum variables
                        if (newHeight < minHeight) {
                            minPoint = newPoint;
                            minHeight = newHeight; 
                        }
                    }

                    // if the point hasn't changed, this is a local minima
                    if (minPoint.x == p.x && minPoint.y == p.y) {
                        done = true;
                    } else {
                        p = minPoint;
                    }
                }

                // after the minima was found, add *some* of the sediment there
                // while this does make it lossy, it balances the removal of lakes that are too small and the preservation of the larger lakes
                terrain[int(p.x)][int(p.y)] += sediment/5;
            } 

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

        // TUNE: momentum dampening and evaporation
        momentum -= 0.2;

        // TUNE: raise momentum going downhill
        // varies with terrainScale so the shallower slopes of large areas don't make the droplets dry up too fast
        momentum += (altitude - terrain[x][y])/(terrainScale*2.5);

        // if momentum has fallen to 0 remove the droplet
        // TODO: deposit material on ground
        if (momentum <= 0) {
            terrain[x][y] += sediment;
            return;
        }

        // put material back down on the ground (must be the same above, but not worth making into a proper function)
        // float newMaterialCapacity = min(0.2, sqrt(momentum) / 10);
        float newMaterialCapacity = sqrt(momentum)/10;

        // if it has too much, drop exactly to max amount
        if (sediment > newMaterialCapacity) {
            terrain[x][y] += sediment - newMaterialCapacity;
            sediment = newMaterialCapacity;
        }

        // if it hasn't run out of momentum, add it back to the list for updating next frame
        droplets.get(x).add(this);

        draw();
    }

    void draw() {
        // https://www.desmos.com/calculator/0rxocd2kcz
        // modified sigmoid function, approaches no difference as content => +infinity
        // i just like sigmoids, they're handy and robust
        float scaleMod = 1/(1+pow(2.71828, 1.5-momentum));

        // sediment varies between 0 and 0.1, so this is faster than using map()
        fill(lerpColor(blue, brown, sediment*10));

        // if there is no matching direction draw circle
        if (direction.mag() == 0) {
            circle(w*(x+0.5), w*(y+0.5), w*scaleMod*2);

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