class Sun {
    int size;
    int radius;

    PVector pivot;

    Sun() {
        this(20);
    }

    Sun(int size) {
        this.size = size;

        // distance from pivot to the bottom left of the screen
        this.radius = int(dist(skyPivot.x, skyPivot.y, width/8, height));
    }

    void update() {
        noStroke();

        int xPos = int(skyPivot.x + radius*cos((time+day)*2*PI/255));
        int yPos = int(skyPivot.y + radius*sin((time+day)*2*PI/255));

        if (yPos > height) {
            int steps = 2*width/size;
        
            for (int i = 2; i <= steps; i++) {
                fill(255, 80, 0, 255*steps/i*pow(map(yPos, height+width, height, 0.3, 0), 2));
                circle(xPos, yPos, size*i);
            }
        }
        
        fill(#ffeb3b);
        circle(xPos, yPos, size);
    }

    float warmth() {
        // total amount of cloudcover present
        float cloudVolume = 0;
        for (Cloud cloud : clouds) {
            cloudVolume += cloud.size;
        }

        float sunEffect = 10.0/(1+pow(2.71828, (cloudVolume/20.0)-5));
        println(sunEffect);

        // if it's daytime, add warmth reduced by #clouds 
        if (day < time && time < night) {
            return sunEffect;
        } else {
            return -1*sunEffect;
        }
    }
}