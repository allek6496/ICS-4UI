String uName = "";
boolean uEnter = false;

String pass = "";
boolean passEnter = false;

String status = "entering";

String letters = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";

void setup() {
    size(600, 600);

    textSize(50);
    textAlign(CENTER, CENTER);
}

void draw() {
    background(230, 255, 230);
    
    fill(0);
    text("Username:", 300, 50);
    if (uEnter) fill(255, 255, 0);
    text(uName, 300, 110);

    fill(0);
    text("Password:", 300, 170);
    if (uEnter) fill(255, 255, 0);
    text(pass, 300, 230);

    if (status == "valid") {
        background(0, 255, 0);
        fill(0);
        text("ACCESS GRANTED", 300, 300);
    } else if (status == "invalid") {
        fill(0);
        background(255, 0, 0);
        text("ACCESS DENIED", 300, 300);
    }
}

void keyPressed() {
    if (!uEnter) {
        if (key == ENTER) {
            uEnter = true;
        } else if (key == BACKSPACE && uName.length() > 0) {
            uName = uName.substring(0, uName.length()-1);
        } else if (letters.indexOf(str(key)) != -1) {
            uName += key;
        }
    } else if (!passEnter) {
        if (key == ENTER) {
            passCheck();
        } else if (key == BACKSPACE && pass.length() > 0) {
            pass = pass.substring(0, pass.length()-1);
        } else if (letters.indexOf(str(key)) != -1) {
            pass += key;
        }
    }
}

void passCheck() {
    String[] users = loadStrings("noContents/passwords.txt");

    for (String user : users) {
        String[] parsed = user.split(",");
        println(uName, parsed[0], pass, parsed[1]);

        if (uName.equals(parsed[0]) && pass.equals(parsed[1])) status = "valid"; 
    }

    if (status == "entering") status = "invalid";
}