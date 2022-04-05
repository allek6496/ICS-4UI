// in the same file cause thunder is small and uses bolt extensively
class Bolt {
    static final int length = 25;
    static final int maxAge = 10;

    float posX;
    float posY;
    PVector dir; // contant length
    Bolt parent;
    ArrayList<Bolt> children;
    int age;

    // head bolt, no parent
    Bolt(float x, float y) {
        this.posX = x;
        this.posY = y;
        this.dir = new PVector(0, length);

        this.parent = null;
        this.children = new ArrayList<Bolt>();

        this.age = 0;
    }

    Bolt(float x, float y, PVector dir, Bolt parent) {
        this(x, y);
        this.parent = parent;

        // overwrites the dir set in the normal constructor
        this.dir = dir;
    }

    int update() {
        // don't update or wait on bolts below the bottom of the screen
        if (posY >= height) return maxAge;

        age++;

        // keep track of the minimum age of the children, and if they're all diappeared delete the tree
        int minAge = age;
        
        // if this branch was just made don't update the children
        if (age == 1) split();

        // if it's older, update the children and keep track of their minimum ages
        else {
            for (Bolt child : children) minAge = min(minAge, child.update());
        }

        // don't draw it if it's already died
        if (age <= maxAge) {
            stroke(255, 255, 0, 255*(maxAge - age)/maxAge); // alpha value that smoothly goes to 0 as the age reaches maxAge
            strokeWeight(2);
            line(posX, posY, posX + dir.x, posY + dir.y);
        }

        return minAge;
    }

    void split() {
        float x = posX + dir.x;
        float y = posY + dir.y;

        // random number to decide how many branches to make
        int n;
        float r = random(1);

        // very high likelyhood for 1, small chance of 2 and even smaller of 3 (freak occurence). it also has a chance to end the branch spontaneously 
        if (r < 0.005) n = 3;
        else if (r < 0.07) n = 2;
        else if (r < 0.97) n = 1;
        else n = 0;

        for (int i = 0; i < n; i++) {
            PVector newDir = new PVector(0, length);
            newDir.rotate(random(-1*PI/4, PI/4));

            children.add(new Bolt(x, y, newDir, this));
        }
    }
}