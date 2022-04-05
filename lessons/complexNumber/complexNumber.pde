void setup() {
    cN z = new cN(2, 7); // 2 + 7i

    z.display();
    println(z.abs());
    
    exit();
}

static class cN {
    float a;
    float b;

    cN(float a, float b) {
        this.a = a;
        this.b = b;
    }

    void display() {
        println(a, "+", b + "i");
    }

    float abs() {
        return sqrt(pow(a, 2) + pow(b, 2));
    }

    cN add(cN z) {
        return new cN(a + z.a, b + z.b);
    }

    static cN add(cN z, cN w) {
        return new cN(z.a + w.a, z.b + w.b);
    }
}