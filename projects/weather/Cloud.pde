class Cloud {
    static final int sizeMod = 20;
    static final float ageMod = 0.8;

    float posX;
    float posY;
    float size;
    String type;
    ArrayList<Rain> rain;
    ArrayList<Bolt> lightningBolts;
    
    int age;
    boolean empty;

    Cloud(float posX, float posY, float size, String type) {
        this.posX = posX;
        this.posY = posY;
        this.size = size;
        this.type = type;

        this.age = 0;
        this.empty = false;

        rain = new ArrayList<Rain>();
        lightningBolts = new ArrayList<Bolt>();
    }

    void update() {
        // i can't just delete the clouds when they run out cause they handle the rain, so keep them around until all the rain is gone
        if (empty && rain.size() > 0) return;
        else if (empty) {
            clouds.remove(this);
            return;
        } else if (size <= 0) empty = true;

        age++;
        rectMode(CENTER);
        posX += wind*5;

        // delete if it gets too far out of bounds
        if (posX < -1*width/2.0 || width*1.5 < posX) clouds.remove(this);

        if (type == "rain") {
            noStroke();

            // if it's young just make it get bigger
            if (age*ageMod <= size) {
                float s = age*ageMod*sizeMod;

                // two layer drawing, with more opacity in the middle
                fill(100, 75);
                rect(posX, posY, s/1.5, s/1.5, s/12);

                fill(150, 40);
                rect(posX, posY, s, s, s/8);
            
            // otherwise draw and rain and change size
            } else {
                // two layer drawing, with more opacity in the middle
                fill(100, 75);
                rect(posX, posY, size*sizeMod/1.5, size*sizeMod/1.5, size*sizeMod/12);

                fill(150, 40);
                rect(posX, posY, size*sizeMod, size*sizeMod, size*sizeMod/8);

                if (height/2 < mouseY && random(1) < float(mouseY)/height - 0.5) { 
                    rain.add(new Rain(random(posX - size*sizeMod/2, posX + size*sizeMod/2), random(posY - size*sizeMod/2, posY + size*sizeMod/2), this));
                    size -= 0.1;

                
                // even if it can't rain still reduce the size slightly
                } else {
                    size -= 0.05;
                }
            }
        }
        if (type == "thunder") {
            // again, if it's young just grow it
            if (age*ageMod < size) {
                float s = age*ageMod*sizeMod;

                noStroke();

                fill(75, 100);
                rect(posX, posY, s/1.5, s/0.75, s/12);

                fill(100, 60);
                rect(posX, posY, s, s*2, s/8);
            } else {
                // update lightning first, so that it's underneath the cloud (note that this does make it over the previous clouds, but that's fine and makes some logical sense)
                if (lightningBolts.size() > 0) {
                    // iterating backwards so we can delete them as we go
                    for (int i = lightningBolts.size()-1; i > 0; i--) {
                        // if the minimum age of every branch in this bolt is exceeding maxAge, remove the root from the list of bolts
                        // i'm assuming java cleans up all of the children recursively when i do this
                        if (lightningBolts.get(i).update() >= Bolt.maxAge) lightningBolts.remove(i);
                    }
                }

                if (random(1) < 0.01) lightningBolts.add(new Bolt(
                    random(posX - size*sizeMod/2, posX + size*sizeMod/2),
                    random(posY + size*sizeMod - size, posY + size*sizeMod + size)
                ));

                noStroke();

                fill(75, 100);
                rect(posX, posY, size*sizeMod/1.5, size*sizeMod/0.75, size*sizeMod/12);

                fill(100, 60);
                rect(posX, posY, size*sizeMod, size*sizeMod*2, size*sizeMod/8);

                // always rains
                rain.add(new Rain(
                    random(posX - size*sizeMod/2, posX + size*sizeMod/2), 
                    random(posY - size*sizeMod, posY + size*sizeMod), this
                ));

                // holds more rain per size than previous clouds
                size -= 0.025;
            }
        }

        // fog doesn't rain and only dissapates
        if (type == "fog") {
            // if it's young just make it get bigger
            if (age*ageMod <= size) {
                float s = age*ageMod*sizeMod;

                fill(150, 75);
                rect(posX, posY, s/0.25, s/1.5, s/12);

                fill(175, 40);
                rect(posX, posY, s*6, s, s/8);
            
            // otherwise draw and rain and change size
            } else {
                // two layer drawing, with more opacity in the middle
                fill(125, 75);
                rect(posX, posY, size*sizeMod/0.25, size*sizeMod/1.5, size*sizeMod/12);

                fill(175, 40);
                rect(posX, posY, size*sizeMod*6, size*sizeMod, size*sizeMod/8);

                size -= 0.01;
            }

        }
    }

    void updateRain() {
        for (int i = rain.size() - 1; i >= 0; i--) {
            rain.get(i).update();
        }
    }

    void removeRain(Rain r) {
        rain.remove(r);
    }
}