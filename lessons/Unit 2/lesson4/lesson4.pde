void setup() {
    exit();

    int[] m = {90, 91, 93, 86, 50};

    int sum = 0;

    for (int i = 0; i < m.length; i++) {
        sum += m[i];
    }

    // println(sum/m.length);

    // how to make an array if you don't know the values in advance
    int[] xPos = new int[100];

    // fill xPos with random values
    for (int i = 0; i < xPos.length; i++) {
        xPos[i] = round(random(0, 1));
    }

    // printArray(xPos);

    // how to make an array if you don't know its length
    int[] yPos;

    int randomLength = round(random(5, 20));
    yPos = new int[randomLength];

    for (int y = 0; y < yPos.length; y++) {
        yPos[y] = round(random(0, 1));
    }

    printArray(yPos);
}

void draw() {
    
}
