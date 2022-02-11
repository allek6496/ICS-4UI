void setup() {
    exit();
    prices();
}

void prices() {
    float total = 0;
    for (float price = 5; price <= 100; price += 0.5) {
        total += price;
    }
    println(total);
}