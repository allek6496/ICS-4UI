// significant amount of algorithmic logic taken from http://arborjs.org/docs/barnes-hut
// all code is original

// class to hold the quad-tree used in the algorithm
class BarnesHutt {
    QuadNode head;

    // create a new tree based off the list of particles
    BarnesHutt(ArrayList<Particle> particles) {
        head = new QuadNode(width/2, height/2, width, height);

        // insert each particle one by one into the tree
        for (Particle particle : particles) {
            head.insert(particle);
        }

        // println(head.totalCharge);
    }

    // TODO: find list of possible 
    PVector force(Particle p) {
        return head.force(p);
    }

    void display() {
        strokeWeight(2);
        stroke(0);
        head.display();
    }
}

class QuadNode {
    // how much to approximate. higher = faster but worse
    float maxTheta = 1;

    // center values
    float x, y;

    // width and height 
    float w, h; 

    // stores the total charge in a node, and the center of charge for the node
    float totalCharge, chargex, chargey;

    Particle contains = null;

    boolean parent = false;
    QuadNode[] children = new QuadNode[4]; // store the 4 children nodes

    QuadNode(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    void insert(Particle p) {
        // if it already has a particle inside of it
        if (parent) { // if it's a parent node
            for (QuadNode child : children) {
                if (child.hasParticle(p)) child.insert(p); // this shouldn't happen multiple times
            }
        } else if (contains == null) {
            contains = p;
            // println("Particle added to node at", x, y);
        } else if (contains != null) {
            parent = true;

            int next = 0;
            float[] xvals = {x-w/4, x+w/4};
            float[] yvals = {y-h/4, y+h/4};
            for (float newx : xvals) {
                for (float newy : yvals) {
                    children[next] = new QuadNode(newx, newy, w/2, h/2);
                    
                    // if the new quadrant contains either particle, add the particle to that quadrant
                    if (children[next].hasParticle(contains)) children[next].insert(contains);
                    if (children[next].hasParticle(p)) children[next].insert(p);

                    next++;
                }
            }

            contains = null;
        } 

        // update center of charge
        chargex = (chargex*totalCharge + p.charge*p.x)/(totalCharge + p.charge);
        chargey = (chargey*totalCharge + p.charge*p.y)/(totalCharge + p.charge);
        totalCharge += p.charge;
    }

    boolean hasParticle(Particle p) {
        return (x - w/2 < p.x && p.x <= x + w/2 &&
                y - h/2 < p.y && p.y <= y + h/2);
    }

    // calculates net force from this node onto the particle
    PVector force(Particle p) {      
        // if it is a "leaf" and has a particle which isn't the one in question
        if (!parent && contains != null && contains != p) { 
            float mag = abs(p.charge)*abs(contains.charge)/pow(dist(p.x, p.y, contains.x, contains.y), 2);

            // vector pointing from the contained particle to the particle in question
            PVector f = new PVector(p.x - contains.x, p.y - contains.y);
            
            // set the magnitude appropriately
            f.setMag(mag);
            
            // if same sign, keep it the same to repel, if opposite sign multiply by -1 to point from p to "contains"
            f.mult((p.charge/abs(p.charge)) * (contains.charge/abs(contains.charge)));

            return f;
        // if it's a parent but not far away enough to approximate contents
        } else if (parent && theta(p) > maxTheta) {
            PVector f = new PVector(0, 0);

            for (QuadNode child : children) f.add(child.force(p));

            return f;

        // this is where the time save comes into effect. if it's far enough, just use center of charge to approximate every included particle
        } else if (parent && theta(p) < maxTheta) {
            float mag = abs(p.charge)*abs(totalCharge)/pow(dist(p.x, p.y, chargex, chargey), 2);

            // vector pointing from the contained particle to the particle in question
            PVector f = new PVector(p.x - chargex, p.y - chargey);
            
            // set the magnitude appropriately
            f.setMag(mag);
            
            // if same sign, keep it the same to repel, if opposite sign multiply by -1 to point from p to "contains"
            f.mult((p.charge/abs(p.charge)) * (totalCharge/abs(totalCharge)));

            return f;
        } else {
            return new PVector();
        }
    }

    // calculates θ to a specific particle
    // size of the quadrant divided by the distance from the particle to the center of charge of the quandrant
    float theta(Particle p) {
        return w/dist(p.x, p.y, chargex, chargey);
    }

    // recursively shows boundary lines for each section
    void display() {
        line(x-w/2, y-h/2,  x-w/2, y+h/2);
        line(x-w/2, y+h/2,  x+w/2, y+h/2);
        line(x+w/2, y-h/2,  x+w/2, y+h/2);
        line(x-w/2, y-h/2,  x+w/2, y-h/2);

        if (parent) {
            for (QuadNode child : children) child.display();
        }
    }
}
