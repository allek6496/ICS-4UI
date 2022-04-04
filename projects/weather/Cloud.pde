class Cloud {
    int sizeMod = 20;

    float posX;
    float posY;
    float size;
    String type;
    ArrayList<Rain> rain;

    Cloud(float posX, float posY, float size, String type) {
        this.posX = posX;
        this.posY = posY;
        this.size = size;
        this.type = type;

        rain = new ArrayList<Rain>();
    }

    void update() {
        rectMode(CENTER);
        posX += wind*5;

        // delete if it gets too far out of bounds
        if (posX < -1*width/2.0 || width*1.5 < posX) clouds.remove(this);

        if (type == "rain") {
            // two layer drawing, with more opacity in the middle
            fill(100, 75);
            rect(posX, posY, size*sizeMod/1.5, size*sizeMod/1.5, size*sizeMod/12);

            fill(150, 40);
            rect(posX, posY, size*sizeMod, size*sizeMod, size*sizeMod/8);

            if (height/2 < mouseY && random(1) < humidity/4 + 0.1) { 
                rain.add(new Rain(random(posX - size*sizeMod/2, posX + size*sizeMod/2), random(posY - size*sizeMod/2, posY + size*sizeMod/2), this));
                size -= 0.1;

                if (size <= 0) clouds.remove(this);
            }
        }
        if (type == "thunder") {
            fill(75, 100);
            rect(posX, posY, size*sizeMod/1.5, size*sizeMod/0.75, size*sizeMod/12);

            fill(100, 60);
            rect(posX, posY, size*sizeMod, size*sizeMod*2, size*sizeMod/8);

            // always rains
            rain.add(new Rain(random(posX - size*sizeMod/2, posX + size*sizeMod/2), random(posY - size*sizeMod, posY + size*sizeMod), this));

            // holds more rain per size
            size -= 0.025;

            if (size <= 0) clouds.remove(this);
        } 
        // if (type == "fog") {
            
        // }
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