class Cloud {
    float content;
    int x;
    int y;
    int age;

    Cloud(x, y, content) {
        this.x = x;
        this.y = y;
        this.content = content;
        age = 0;
    }

    void update() {
        x += wind.x;
        y += wind.y;

        // TUNE: rain probability and age effect
        if (random(1) < terrain[x][y] + age/100) rain();
    }

    void rain() {
        // create a new raindrop and decrease content
    }
}