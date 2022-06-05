float[] a;

void setup() {
    a = new float[10];
    a[2] = 2; a[3] = 3; a[8] = 8;
    println(4-0.5);

    plusOne(a);
    printArray(a);
    
    exit();
}

void plusOne(float[] a) {
    for (int n = 0; n < a.length; n++) {
        a[n] += 1;
    }
}