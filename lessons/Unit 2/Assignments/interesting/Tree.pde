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

        println(head.totalCharge);
    }

    // TODO: find list of possible 
    PVector force(Particle p) {
        return new PVector(0, 0);
    }

    void display() {
        strokeWeight(2);
        stroke(0);
        head.display();
    }
}

class QuadNode {
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

    // QuadNode(float x, float y, float w, float h, Particle p) {
    //     this.x = x;
    //     this.y = y;
    //     this.w = w;
    //     this.h = h;

    //     contains = p;

    //     totalCharge = p.charge;
    //     chargex = p.x;
    //     chargey = p.y;
    // }

    void insert(Particle p) {
        // if it already has a particle inside of it
        if (parent) { // if it's a parent node
            for (QuadNode child : children) {
                if (child.hasParticle(p)) child.insert(p); // this shouldn't happen multiple times
            }
        } else if (contains == null) {
            contains = p;
            println("Particle added to node at", x, y);
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
