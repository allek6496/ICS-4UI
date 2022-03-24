class Teacher {
    String name;
    int age;
    ArrayList<Course> courses;
    
    // rating from -5 to 5
    float rating;
    float ratings;

    Teacher(name, age) {
        this.name = name;
        this.age = age;
        this.rating = 0;
        this.ratings = 0;
        this.courses = new ArrayList<Course>();
    }

    void displaySchedule() {
        println(name, "has the following schedule:");
        for (Course c : courses) {
            println(course.time, "-", course.code);
        }
    }

    void rate(float score) {
        rating = (rating*ratings + min(max(-5, score), 5))/(ratings+1);
        ratings++;
    }
}

class Student {
    String name;
    int age;
    ArrayList<Course> courses;

    int range = 10;
    int intelligence;
    int grade;

    Student(name, age, grade, intelligence) {
        this.name = name;
        this.age = age;
        this.grade = grade;
        this.intelligence = intelligence;

        this.courses = new ArrayList<Course>();
    }

    // does a test, returning a random mark on the test, +/- range from intelligence
    int doTest(float difficulty) {
        return round(difficulty * random(max(0, intelligence-range), min(100, intelligence+range)));
    }

    void displaySchedule() {
        println(name, "is", age, "years old, is in grade", grade, ", and has the following schedule:");
        for (Course c : courses) {
            println(course.time, "-", course.code, "\tMark:", course.getMark(this));
        }
    }

    float average() {
        int markSum = 0;
        for (Course c : courses) {
            markSum += c.getMark(this);
        }

        float average = markSum/courses.size();
        return round(average*10)/10.0;
    }
}