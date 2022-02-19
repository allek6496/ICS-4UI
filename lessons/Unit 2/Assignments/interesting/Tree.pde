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
        strokeWeight(1);
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

    // stores the total positive and negative charge within a node, and the center of that charge for the node
    // it's important to run separate calculations for positive and negative charges
    float negCharge, negChargeX, negChargeY;
    float posCharge, posChargeX, posChargeY;

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
        // if it's a parent node, add the particle to the relavent child
        if (parent) { 
            for (QuadNode child : children) {
                if (child.hasParticle(p)) child.insert(p); // this shouldn't happen multiple times
            }

        // if it doesn't contain a particle, just add this one
        } else if (contains == null) {
            contains = p;

        // if it contains exactly one particle, create 4 child nodes and place both the new and previous particles into the relavent children
        } else if (contains != null) {
            parent = true;

            int next = 0;

            // just saves space by looping through the four children
            float[] xvals = {x-w/4, x+w/4};
            float[] yvals = {y-h/4, y+h/4};
            for (float newx : xvals) {
                for (float newy : yvals) {
                    // create this child and store it under the parent
                    children[next] = new QuadNode(newx, newy, w/2, h/2);
                    
                    // if the new quadrant contains either particle, add the particle to that quadrant
                    if (children[next].hasParticle(contains)) children[next].insert(contains);
                    if (children[next].hasParticle(p)) children[next].insert(p);

                    next++;
                }
            }

            // make sure to note that the contained particle is no longer under this node, to prevent duplication
            contains = null;
        } 

        // update center of charge
        if (0 < p.charge) {
            // update the positive center of charge, math done in notebook
            posChargeX = (posChargeX*posCharge + p.charge*p.x)/(posCharge + p.charge);
            posChargeY = (posChargeY*posCharge + p.charge*p.y)/(posCharge + p.charge);

            // add to the total positive charge contained within the node
            posCharge += p.charge;

        // similarly for negative charges
        } else {
            // update the positive center of charge, math done in notebook
            negChargeX = (negChargeX*negCharge + p.charge*p.x)/(negCharge + p.charge);
            negChargeY = (negChargeY*negCharge + p.charge*p.y)/(negCharge + p.charge);

            // add to the total positive charge contained within the node
            negCharge += p.charge;
        }
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

        // this is where the time save comes into effect. if it's far enough, just use two centers of charge to approximate every included particle
        } else if (parent && theta(p) < maxTheta) {
            // calculate positive and negative charges differently, and sum the resultant forces
            float posMag = abs(p.charge)*posCharge/pow(dist(p.x, p.y, posChargeX, posChargeY), 2);

            // vector from the center of positive charge to the particle in question
            PVector posF = new PVector(p.x - posChargeX, p.y - posChargeY)
            .setMag(posMag)
            // if the particle in question is negatively charged, invert the vector to point from that particle to the center of positive charge (attraction)
            .mult(p.charge/abs(p.charge));


            // similarly for negative charges
            float negMag = abs(p.charge)*abs(negCharge)/pow(dist(p.x, p.y, negChargeX, negChargeY), 2);

            PVector negF = new PVector(p.x - negChargeX, p.y - negChargeY)
            .setMag(negMag)
            // if the particle in question is positively charged, invert the vector to point from that particle to the center of positive charge (attraction)
            .mult(-1*p.charge/abs(p.charge));


            // calculate net force by adding the two forces together
            posF.add(negF);
            return posF;
        
        // this shouldn't happen
        } else {
            return new PVector();
        }
    }

    // calculates θ to a specific particle
    // size of the quadrant divided by the minimum distance from the particle to a center of charge of the quandrant 
    float theta(Particle p) {
        return w/min(dist(p.x, p.y, posChargeX, posChargeY), dist(p.x, p.y, negChargeX, negChargeY));
    }

    // recursively shows boundary lines for each section
    void display() {
        stroke(0);
        line(x-w/2, y-h/2,  x-w/2, y+h/2);
        line(x-w/2, y+h/2,  x+w/2, y+h/2);
        line(x+w/2, y-h/2,  x+w/2, y+h/2);
        line(x-w/2, y-h/2,  x+w/2, y-h/2);

        // draw centers of charge
        /*
        fill(200);

        stroke(255, 0, 0);
        circle(posChargeX, posChargeY, 8);

        stroke(0, 255, 0);
        circle(negChargeX, negChargeY, 8);
        */

        if (parent) {
            for (QuadNode child : children) child.display();
        }
    }
}
