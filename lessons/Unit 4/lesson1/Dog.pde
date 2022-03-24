maleDogs = {
    
}

class Dog {
    // feilds of dog class
    String name;
    String breed;
    String gender;
    float weight;

    // constructor of dog class, assigns feild values
    Dog(String n, String b, String g, float w) {
        this.name = n;
        this.breed = b;
        this.gender = g;
        this.weight = w;
    }

    void describe() {
        println(name, "is a", gender, breed, "who weighs", weight, "pounds");
    }

    void bark() {
        println("WOOF! said", this.name);
    }
}