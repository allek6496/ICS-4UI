class Thunder {

}

// in the same file cause thunder is small and uses bolt extensively
class Bolt {
    int length = 10;
    int maxAge = 20;
    color c = color(255, 255, 0);

    float posX;
    float posY;
    PVector dir; // contant length
    Bolt parent;
    ArrayList<Bolt> children;
    int age;

    // head bolt, no parent
    Bolt(float x, float y, PVector dir) {
        this.posX = x;
        this.posY = y;
        this.dir = dir;

        this.parent = null;
        this.children = new ArrayList<Bolt>();

        this.age = 0;
    }

    Bolt(float x, float y, PVector dir, Bolt parent) {
        this.parent = parent;
        this(x, y, dir);
    }

    void update() {
        if (age == 0) fornicate();
        else {
            for (Bolt child : children) child.update();
        }

        lerpColor(c, color(0, 0, 0, 0), )
    }

    void fornicate() {
        float x = xPos + dir.x;
        float y = yPos + dir.y;

        // random number to decide how many branches to make
        int r = max(1, 3 - int(sqrt(random(9))));
        for (int i = 0; i < r; i++) {
            PVector newDir = new PVector(0, length);
            newDir.rotate(random(-1*PI/4, PI/4));

            children.add(new Bolt(x, y, newDir, this));
        }
    }
}