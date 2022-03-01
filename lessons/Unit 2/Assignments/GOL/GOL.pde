int startX = 0;
int startY = 0; 
int startFOV = 2;

Board board;
int xPos, yPos, FOV;

void setup() {
    // must be square
    size(600, 600);
    
    xPos = startX;
    yPos = startY;
    FOV = startFOV;

    board = new Board();

    frameRate(1);
}

void draw() {
    // board.display() tiles the screen, shouldn't be needed
    background(0);

    board.display();
}

void keyPressed() {
    if (key == 'w') yPos -= 1;
    if (key == 's') yPos += 1;
    if (key == 'a') xPos -= 1;
    if (key == 'd') xPos += 1;

    if (key == 'q') FOV -= 1;
    if (key == 'e') FOV += 1;

    if (key == ' ') {
        xPos = startX;
        yPos = startY;
        FOV = startFOV;
    }
}

void mouseButton() {
    
}

// i'm not going to bother with any kind of optimization to reduce time complexity from O(n^2), it's possible to scale with number of white squares but i can't be bothered
class Board {
    // squares[x][y] = 0 or 1
    ArrayList<IntList> squares;

    // number of affected squares in a particular direction
    int squaresX;
    int squaresY;

    // which square in squares is designated as the origin
    int originX;
    int originY;

    // init a new board
    Board() {
        squares = new ArrayList<IntList>();
        // squares.append(new IntList());
        squares.add(new IntList());
        squares.get(0).append(0);

        // origins in the middle
        originX = 0;
        originY = 0;
        squaresX = 1;
        squaresY = 1;
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

    // x and y are the cartesian ofsets of the origin from the top right, FOV is how many squares across the screen
    void display() {
        // just assume it's square
        float w = width/FOV;
        // printArray(screenSquare(0, 0));

        // draw all the visible squares with values (if set)
        noStroke();
        for (int x = 0; x < width; x += w) {
            for (int y = 0; y < height; y += w) {
                int[] s = screenSquare(x, y);
                println(x, y, "goes to", s[0], s[1]);

                // determine the value safely
                int value;
                if (0 <= s[0] && s[0] < squaresX && 0 <= s[1] && s[1] < squaresY) value = squares.get(s[0]).get(s[1]);
                else value = 0;

                // yellow tinge on origin node
                if (s[0] == originX && s[1] == originY) fill(value*200+55, value*200+55, 0);
                else fill(value*255);
                
                square(x*w, y*w, w);
            }
        }

        // draw lines on top, afterwards
        stroke(127);
        for (int xi = 0; xi < FOV; xi++) {
            line(xi*w, 0, xi*w, height);
        }   

        for (int yi = 0; yi < FOV; yi++) {
            line(0, yi*w, width, yi*w);
        }
    }

    // find and toggle the square under the mouse
    void toggle() {
        int w = width/FOV;

        int xi = mouseX/w;
        int yi = mouseY/w;

        int x = xi - xPos;
        int y = yi - xPos;



        // // create a new positive node  
        // if (0 <= x && x < squaresX && 0 <= y && y < squaresY)) {
        //     // expand the grid in the x direction
        //     while (x < squaresX) {
        //         squares.add(new IntList());
        //         // add a new x-row
        //         for (int i = 0; i < squaresY; i++) {
        //             // add a value for every y we've found, updating squaresY later
        //             squares.get(squaresX).append(0); 
        //         } 
        //     }

        //     while (y < )

        // } 

        // // if the square must exist so just change the value
        // if (squares.get(x).get(y) == 0) squares.get(x).set(y, 1);
        // else squares.get(x).set(y, 0);
    }
}