void setup() {
    println(parse("(-10, 20.34534)"));
}

PVector parse(String pair) {
    float first = float(pair.substring(1, pair.indexOf(",")));
    float second = float(pair.substring(pair.indexOf(",")+2, pair.length()-1));
    return new PVector(first, second); 
}
