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
        x += directions[wind].x;
        y += directions[wind].y;

        if (x < 0 || y < 0 || size <= x || size <= y) {
            // D: if it's oob, kill itself (it will diappear while half onscreen but catch me caring lol)
            content -= 0.05;
        } else {
            // TUNE: rain probability and age effect
            if (random(1) < terrain[x][y] - waterLevel + age/100) rain();

            // draw the cloud
            rectMode(CENTER);
            fill(255, 100);

            // TUNE: size of cloud relative to content
            square(x*w, y*w, int(w*content));
        }
    }

    void rain() {
        // create a new raindrop and decrease content
    }
}