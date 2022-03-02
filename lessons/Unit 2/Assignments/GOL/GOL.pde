int startX = 2;   // starting position of the origin on the screen
int startY = 2; 
int startFOV = 5; // number of squares to display horizontally
int speed = 60;   // literally just framerate

Board board;
int xPos, yPos, FOV;

boolean playing = false;

void setup() {
    // must be square
    size(600, 600);
    
    xPos = startX;
    yPos = startY;
    FOV = startFOV;

    board = new Board();

    frameRate(speed);
}

void draw() {
    // board.display() tiles the screen, shouldn't be needed
    background(0);

    if (playing) {
        board.update();
        if (key == ' ') playing = false;
    }
    else board.display();
}

void keyPressed() {
    // the +FOV/x adds scaling to make larger jumps at larger scales
    if (key == 's') yPos -= 1+FOV/5;
    if (key == 'w') yPos += 1+FOV/5;
    if (key == 'd') xPos -= 1+FOV/5;
    if (key == 'a') xPos += 1+FOV/5;

    if (key == 'e') FOV -= 1+FOV/8;
    if (key == 'q' && FOV+1+FOV/10 < width) FOV += 1+FOV/8;

    if (key == 'r') {
        xPos = startX;
        yPos = startY;
        FOV = startFOV;

        board.reset();
    }

    if (key == ' ' || key == ENTER) {
        playing = !playing;
    }
}

void mousePressed() {
    board.toggle();
}

// i'm not going to bother with any kind of optimization to reduce time complexity from O(n^2), it's possible to scale with number of white squares but i can't be bothered
class Board {
    // squares[x][y] = 0 or 1
    ArrayList<ArrayList<Integer>> squares;

    // number of affected squares in a particular direction
    int squaresX;
    int squaresY;

    // which square in squares is designated as the origin
    int originX;
    int originY;

    // init a new board
    Board() {
        // bundled into reset just cause idc, i don't wanna make a new board ever
        reset();
    }

    // converts x, y of the screen into x, y of the square matrix
    int[] screenSquare(int xi, int yi) {
        // assume the screen is square
        int w = width/FOV;

        // index on the screen
        int x = xi/w;
        int y = yi/w;

        // index relative to the origin
        x = x - xPos;
        y = y - yPos;

        // index relative to the 0, 0 of square matrix
        x = x + originX;
        y = y + originY;

        int[] output = {x, y};

        return output;
    }

    void update() {
        // make newSquares 1 larger in every direction, and just add 1 to the x and y before setting
        ArrayList<ArrayList<Integer>> newSquares = new ArrayList<ArrayList<Integer>>();
        for (int x = 0; x < squaresX+2; x++) {
            newSquares.add(new ArrayList<Integer>());

            for (int y = 0; y < squaresY+2; y++) {
                newSquares.get(x).add(0); 
            } 
        }

        // literally retching right now this for structure is disgustang 
        for (int x = 0; x < squaresX; x++) {
            for (int y = 0; y < squaresY; y++) {

                int count = 0;
                for (int a = x-1; a <= x+1; a++) {
                    for (int b = y-1; b <= y+1; b++) {
                        try {
                            if (squares.get(a).get(b) == 1 && (a != x || b != y)) count++;
                        } catch (IndexOutOfBoundsException e) {}
                    }
                }

                // if (count < 2) it dies
                // if it's already alive and has 2 companions keep it alive
                if (squares.get(x).get(y) == 1 && count == 2) newSquares.get(x+1).set(y+1, 1);
                // if 3 neighbours, it's alive no matter what
                if (count == 3) newSquares.get(x+1).set(y+1, 1);
                //if (count > 3) it dies/stays dead

                // expand to the left if there are three in a vertical line
                if (x == 0 && y != 0 && y != squaresY-1 && 
                    squares.get(x).get(y-1) == 1 && squares.get(x).get(y) == 1 && squares.get(x).get(y+1) == 1) {
                        newSquares.get(0).set(y+1, 1);
                }

                // expand right
                if (x == squaresX-1 && y != 0 && y != squaresY-1 && 
                    squares.get(x).get(y-1) == 1 && squares.get(x).get(y) == 1 && squares.get(x).get(y+1) == 1) {
                        newSquares.get(squaresX+1).set(y+1, 1);
                }

                // expand down
                if (y == squaresY-1 && x != 0 && x != squaresX-1 && 
                    squares.get(x-1).get(y) == 1 && squares.get(x).get(y) == 1 && squares.get(x+1).get(y) == 1) {
                        newSquares.get(x+1).set(squaresY+1, 1);
                }

                // expand up
                if (y == 0 && x != 0 && x != squaresX-1 && 
                    squares.get(x-1).get(y) == 1 && squares.get(x).get(y) == 1 && squares.get(x+1).get(y) == 1) {
                        newSquares.get(x+1).set(0, 1);
                }
            }
        }

        // TODO: prune 0 rows/columns from newSquares and set as the new `squares`
        
        // how these variables will be changed if nothing is pruned
        squaresX += 2;
        squaresY += 2;
        originX  += 1;
        originY  += 1;

        while (newSquares.size() > 0 && newSquares.get(0).size() > 1) {
            // tracks if changes have been made, to loop again
            boolean bloated = false;

            // if the first column is fully empty, remove it
            if (newSquares.get(0).indexOf(1) == -1) {
                newSquares.remove(0);
                originX--;
                squaresX--;
                bloated = true;
            } 
            
            // if the last column is fully empty, remove it
            if (newSquares.get(squaresX-1).indexOf(1) == -1) {
                newSquares.remove(squaresX-1);
                squaresX--;
                bloated = true;
            }

            // if the first row is fully empty, remove it
            int sum = 0;
            for (int x = 0; x < squaresX; x++) {
                sum += newSquares.get(x).get(0);
            }

            if (sum == 0) {
                for (int x = 0; x < squaresX; x++) {
                    newSquares.get(x).remove(0);
                }

                originY--;
                squaresY--;
                bloated = true;
            }

            // if the last row is fully empty, remove it
            sum = 0;
            for (int x = 0; x < squaresX; x++) {
                sum += newSquares.get(x).get(squaresY-1);
            }

            if (sum == 0) {
                for (int x = 0; x < squaresX; x++) {
                    newSquares.get(x).remove(squaresY-1);
                }
                squaresY--;
                bloated = true;
            }

            if (!bloated) break;
        }

        squares = newSquares;
        display();
    }

    // x and y are the cartesian ofsets of the origin from the top right, FOV is how many squares across the screen
    void display() {
        // just assume it's square
        float w = width/FOV;

        // draw all the visible squares with values (if set)
        noStroke();
        for (int x = 0; x < width; x += w) {
            for (int y = 0; y < height; y += w) {
                int[] s = screenSquare(x, y);

                // determine the value safely, distinguishing which are being simulated
                float value;
                if (0 <= s[0] && s[0] < squaresX && 0 <= s[1] && s[1] < squaresY) value = max(0.1f, squares.get(s[0]).get(s[1]));
                else value = 0;

                // yellow tinge on origin node
                if (s[0] == originX && s[1] == originY) fill(value*200+55, value*200+55, 0);
                else fill(value*255);
                
                square(x, y, w);
            }
        }

        // don't draw lines at large scales
        if (FOV < 50) {
            // draw lines on top, afterwards
            stroke(127);
            for (int x = 0; x < width; x += w) {
                line(x, 0, x, height);
            }   

            for (int y = 0; y < height; y += w) {
                line(0, y, width, y);
            }
        }
    }

    // expands the array `squares` to include whatever x and y was
    void addSquare(int x, int y) {
        // if there's nothing to do, do nothing
        if (0 <= x && x < squaresX && 0 <= y && y < squaresY) return;

        // i used while loops for this because I found them more intuitive, but a for loop has no chance of failing to terminate

        // expanded right
        while (squaresX <= x) {
            // add a new x-column
            squares.add(new ArrayList<Integer>());

            // add a value for every y in the current size
            for (int yi = 0; yi < squaresY; yi++) {
                squares.get(squaresX).add(0); 
            } 

            squaresX++;
        } 

        // expanded down
        while (squaresY <= y) {
            // append a 0 to every x column 
            for (int xi = 0; xi < squaresX; xi++) {
                squares.get(xi).add(0);
            }

            squaresY++;
        }

        // iterator variables to how many to move
        int xi = x;
        int yi = y;

        // if it's expanded to the left
        while (xi < 0) {
            ArrayList<Integer> newColumn = new ArrayList<Integer>();
            for (int i = 0; i < squaresY; i++) newColumn.add(0);
            squares.add(0, newColumn);

            squaresX++;
            xi++;
            
            // also note that this causes the origin to move
            originX++;
        }

        // expanded up
        while (yi < 0) {
            for (int i = 0; i < squaresX; i++) squares.get(i).add(0, 0);

            squaresY++;
            yi++;

            originY++;
        }
    }

    // find and toggle the square under the mouse
    void toggle() {
        int[] point = screenSquare(mouseX, mouseY);
        int x = point[0];
        int y = point[1];

        // expand the grid in the positive x direction
        addSquare(x, y);

        // re-set the x and y after adding a square
        point = screenSquare(mouseX, mouseY);
        x = point[0];
        y = point[1];

        // if the square must exist so just change the value
        if (squares.get(x).get(y) == 0) squares.get(x).set(y, 1);
        else squares.get(x).set(y, 0);
    }

    // resets the grid
    void reset() {
        squares = new ArrayList<ArrayList<Integer>>();
        // squares.append(new ArrayList<Integer>());
        squares.add(new ArrayList<Integer>());
        squares.get(0).add(0);

        squaresX = 1;
        squaresY = 1;
        originX = 0;
        originY = 0;
    }
}
