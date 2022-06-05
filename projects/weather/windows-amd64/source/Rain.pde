class Rain {
    float posX;
    float posY;
    boolean snow;
    boolean frozen;

    // always has magnitude 1, shows what direction it's currently travelling in by small air currents
    // this isn't affected by wind and is random
    PVector dir;

    // used to make snow spin
    float snowRotation;

    // parent cloud
    Cloud cloud;

    Rain(float posX, float posY, Cloud cloud) {
        this.posX = posX;
        this.posY = posY;
        this.cloud = cloud;

        dir = new PVector(0, 1);

        // if the temp < 0, make it snow
        if (temp + sun.warmth() < 0) {
            this.snow = true;

            this.frozen = true;
        }
    }

    void update() {
        noStroke();

        float tempTemp = temp + sun.warmth();

        // freezes in the air (this should probably use tempTemp, but it looks better using temp, because it freezes midair less often)
        if (!frozen && temp < 0 && random(1) > 0.975) frozen = true;

        // if temp is high, melt the snow or frozen rain
        if (frozen && tempTemp > 0 && random(1) > 0.95) {
            snow = false;
            frozen = false;
        }

        if (dir.heading() < PI*3/4) dir.rotate(random(-0.05, 0.1));
        if (dir.heading() > PI*3/4) dir.rotate(random(-0.1, 0.05));

        // Move and draw the rain based on its state
        if (snow) {
            // snow is extra chaotic, greater dir influence
            posY += 3 + dir.y*3;
            posX += wind*10 + dir.x*3;

            stroke(255);
            strokeWeight(2);

            pushMatrix();
            
            translate(posX, posY);
            rotate(snowRotation);

            // draw a small cross
                            point(0, -1);   
            point(-1, 0);   point(0, 0);    point(1, 0);
                            point(0, 1);

            popMatrix();

            // turn it for next time
            snowRotation = (snowRotation + 0.05) % TWO_PI;

        // freezing rain/hail
        } else if (frozen) {
            // not random and drops quickly, nasty stuff
            posY += 15;
            posX += wind;

            rectMode(CENTER);

            fill(100, 0, 255, 200);
            square(posX, posY, 5);

        // rain
        } else {
            posY += 10 + dir.y;
            posX += wind*2 + dir.x;

            fill(0, 0, 255);

            // draws a droplet
            // copy pasted from my cellular automata
            pushMatrix();

            float w = 5;
  
            translate(posX, posY);
            rotate(-1*wind*PI/4 );

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

        if (height < posY) cloud.removeRain(this);
    }
}
