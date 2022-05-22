float g(float x) {
    if (x <= 0) return 6; // base case

    else return 2*g(x-2) + 5;
}

float h(float x) {
    if (x <= 3) return 12;
    else return 3*h(x/2)+1;
}

void setup() {
    println(g(4));
    println(h(16));

    exit();
}
