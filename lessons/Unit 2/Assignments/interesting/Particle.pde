class Particle {
    float x, y, xVel, yVel, charge;

    static final int minCharge = -10;
    static final int maxCharge = 10;

    color pos = color(255, 80, 0);
    color nut = color(0, 0, 255);
    color neg = color(0, 255, 80);
    Particle(float x, float y, float charge) {
        this.x = x;
        this.y = y;

        if (charge > maxCharge) this.charge = maxCharge;
        else if (charge < minCharge) this.charge = minCharge;
        else this.charge = charge;
    }

    void display() {
        // if negative, fill green
        if (charge < 0) fill(lerpColor(neg, nut, map(charge, minCharge, maxCharge, 0, 1)));
        // otherwise fill red
        else fill(lerpColor(nut, pos, map(charge, minCharge, maxCharge, 0, 1)));

        circle(x, y, radius);
    }
}