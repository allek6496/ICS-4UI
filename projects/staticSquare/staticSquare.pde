void setup() {
    size(300, 300);
}

void draw() {
    background(0);
    stroke(255);
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            if (random(1.0) > 0.5) point(x, y);
        }
    }
}
