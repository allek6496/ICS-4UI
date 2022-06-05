class Sun {
    int size;
    int radius;

    PVector pivot;

    Sun() {
        this(30);
    }

    Sun(int size) {
        this.size = size;

        // distance from pivot to the bottom left of the screen
        this.radius = int(dist(skyPivot.x, skyPivot.y, width/8, height));
    }

    void update() {
        noStroke();

        int xPos = int(skyPivot.x + radius*cos((time+day-dayNightFade)*2*PI/255));
        int yPos = int(skyPivot.y + radius*sin((time+day-dayNightFade)*2*PI/255));

        if (yPos > height) {
            int steps = 2*width/size;
        
            for (int i = 2; i <= steps; i++) {
                fill(255, 80, 0, 255*steps/i*pow(map(yPos, height+width, height, 0.3, 0), 2));
                circle(xPos, yPos, size*i);
            }
        } else {
            int steps = width/size/2;

            for (int i = 2; i <= steps; i++) {
                fill(255, 230, 0, 255*steps/i*pow(map(max(height/2, yPos), height, height/2, 0, 0.2), 2));
                circle(xPos, yPos, size*i/2);
            }
        }
        
        fill(#ffeb3b);
        circle(xPos, yPos, size);
    }

    float warmth() {
        float sunEffect = 10 - cloudCover();

        // if it's night, make it cold 
        if (time <= day - dayNightFade) {
            return -1*sunEffect;

        // fade the temperature in the morning
        } else if (day - dayNightFade < time && time <= day + dayNightFade) {
            return sunEffect * (2/(1+pow(2.71828, -7*(time-day)/dayNightFade)) - 1);
        
        // full effect during the day
        } else if (day + dayNightFade < time && time <= night - dayNightFade) {
            return sunEffect;
        
        // fade the effect in the evening
        } else if (night - dayNightFade < time && time <= night + dayNightFade) {
            return sunEffect * (-2/(1+pow(2.71828, -7*(time-night)/dayNightFade)) + 1);
        
        // full negative effect in overnight
        } else {
            return -1*sunEffect;
        }
    }
}
