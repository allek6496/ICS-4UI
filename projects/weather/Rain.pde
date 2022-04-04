class Rain {
    float posX;
    float posY;
    boolean snow;
    boolean frozen;

    // parent cloud
    Cloud cloud;

    Rain(float posX, float posY, Cloud cloud) {
        this.posX = posX;
        this.posY = posY;
        this.cloud = cloud;

        // if the temp < 0, make it snow
        if (temp < 0) {
            this.snow = true;

            this.frozen = true;
        }
    }

    void update() {
        // freezes in the air
        if (temp < 0 && !frozen) frozen = true;

        // if temp is high, melt the snow or frozen rain
        if (temp > 5 && frozen) {
            snow = false;
            frozen = false;
        }

        // Move and draw the rain based on its state
        if (snow) {
            posY += 1;
            posX += wind*2;

            // draw snow

        // freezing rain
        } else if (frozen) {

        // rain
        } else {
            posY += 10;
            posX += wind*0.8 + random(-1*wind, wind);

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

        if (height < posX) cloud.removeRain(this);
    }
}