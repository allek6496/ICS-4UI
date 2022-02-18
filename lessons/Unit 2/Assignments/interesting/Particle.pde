class Particle {
    float x, y, charge;
    PVector vel;

    float maxSpeed = 0.5;
    float dampening = 1; // (0, 1]. 1 is no dampening

    static final int minCharge = -10;
    static final int maxCharge = 10;

    color pos = color(255, 80, 0);
    color nut = color(0, 0, 255);
    color neg = color(0, 255, 80);

    Particle(float x, float y, float charge) {
        this.x = x;
        this.y = y;
        vel = new PVector(0, 0);

        if (charge > maxCharge) this.charge = maxCharge;
        else if (charge < minCharge) this.charge = minCharge;
        else this.charge = charge;
    }

    void update(PVector force) {
        vel.add(force).limit(maxSpeed);
        vel.mult(dampening);

        // compensate for the time
        float newx = x + vel.x*deltaT;
        float newy = y + vel.y*deltaT;

        // better wall bounces, stop it from skipping over (still breaks if it skipps over an entire multiple of width, unlikely)
        if (newx < 0) {
            newx *= -1;
            vel.x *= -1;
        }
        if (width < newx) {
            newx = width - (newx - width);
            vel.x *= -1;
        }
        
        if (newy < 0) {
            newy *= -1;
            vel.y *= -1;
        }
        if (height < newy) {
            newy = height - (newy - height);
            vel.y *= -1;
        }

        x = newx; 
        y = newy; 

        // println(x, y);

        display();
    }

    void display() {
        noStroke();

        // if negative, fill green
        if (charge < 0) fill(lerpColor(neg, nut, map(charge, minCharge, maxCharge, 0, 1)));
        // otherwise fill red
        else fill(lerpColor(nut, pos, map(charge, minCharge, maxCharge, 0, 1)));

        circle(x, y, radius);
    }
}
