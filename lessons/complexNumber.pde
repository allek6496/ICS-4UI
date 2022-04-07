class cN {
    float a;
    float b;

    cN() {
        this.a = 0;
        this.b = 0;
    }

    cN(float a, float b) {
        this.a = a;
        this.b = b;
    }

    boolean mandlebrot() {
        cN temp = new cN(a, b);
    }

    void display() {
        println(a, "+", b + "i");
    }

    // sets the location to the coresponding screen location
    void setLoc(int x, int y) {
        a = float(x);
        b = float(y);

        a -= width/2;
        b -= height/2;

        a /= zoom;
        b /= -1*zoom;

        a -= aCenter;
        b -= bCenter; 
    }

    float abs() {
        return sqrt(pow(a, 2) + pow(b, 2));
    }

    cN add(cN z) {
        return new cN(a + z.a, b + z.b);
    }
    
    PVector screenLoc() {
        PVector p = new PVector(a, b);

        p.add(aCenter, bCenter);

        p.mult(zoom);
        p.y *= -1;

        p.add(width/2, height/2);

        return p;
    }

    void multiply(cN z) {
        float newA = a*z.a - b*z.b;
        float newB = a*z.b + b*z.a;

        a = newA;
        b = newB;
    }
}