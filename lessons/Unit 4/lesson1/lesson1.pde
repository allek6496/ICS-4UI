void setup() {
    Dog x = new Dog("Ollie", "golden retriever", "male", 13);
    Dog y = new Dog("Orey", "swiss mountain dog", "female", 35);

    x.describe();
    y.describe();

    boolean personAtDoor = true;
    boolean oreyNoticed = true;
    int barks = 0;
    while (oreyNoticed) {
        y.bark();
        barks++;

        if(barks > 10) personAtDoor = false;
    } 

    noLoop();    
}
