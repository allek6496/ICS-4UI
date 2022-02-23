void setup() {
    exit();

    PrintWriter pw = createWriter("info/results.txt");

    String[] countryData = loadStrings("info/medalCounts.txt");

    for (String country : countryData) {
        String[] countryRow = country.split(",");

        String name = countryRow[0];
        int gold = int(countryRow[1]);
        int silver = int(countryRow[2]);
        int bronze = int(countryRow[3]);

        int total = gold + silver + bronze;

        pw.println(name + " has won " + str(total) + " medals so far!");
    }

    pw.close();
}

void draw() {
    
}
