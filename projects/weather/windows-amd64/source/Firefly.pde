class Firefly {
    float posX;
    float posY;
    float light;
    boolean lightUp; // whether light is coming on or going off
    PVector dir;

    Firefly(float x, float y) {
        this.posX = x;
        this.posY = y;

        lightUp = true;
        this.light = 0;

        this.dir = new PVector(0, -2);
    }

    void update() {
        // if there are clouds forming they run and hide
        boolean areClouds = height/2 < mouseY || clouds.size() > 10;
        
        // otherwise it's clear to move around
        if (!areClouds) {
            // if it's too low
            if (height*11/12 < posY) {
                if (0 <= dir.x) dir.rotate(-0.1);
                else dir.rotate(0.1);
            
            // too high
            } else if (posY < height*5/8) {
                if (0 <= dir.x) dir.rotate(0.1);
                else dir.rotate(-0.1);
            
            // in the middle
            } else {
                dir.rotate(random(-0.1, 0.1));
            }
        }

        // only run and hide if there are clouds
        if (areClouds) {
            posY += 10;
        } else {
            posX += dir.x;
            posY += dir.y;
        }

        // strongly affected by the wind
        posX += wind*3;

        // don't let it travel out of bounds
        if (posX < 0 || width < posX || height < posY) {
            fireflies.remove(this);
        }

        // daytime or if there are clouds it's just a brown fly
        if ((day < time && time < night) || areClouds) {
            fill(#1D120B);
            light = 0;

        // otherwise it must be a clear night
        } else {
            fill(lerpColor(#1D120B, #FFFF00, light));

            if (lightUp) {
                light += 0.05;

                if (light >= 1) lightUp = false;
            } else {
                light -= 0.05;

                if (light <= 0) lightUp = true;
            }
        }

        circle(posX, posY, 3);

        // small chance to reproduce
        if (random(1) < 0.005) {
            fireflies.add(new Firefly(posX, posY));
        }
    }
}
