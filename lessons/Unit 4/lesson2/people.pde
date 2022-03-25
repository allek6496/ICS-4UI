class Teacher {
    String name;
    int age;
    ArrayList<Course> courses;
    
    // rating from -5 to 5
    float rating;
    float ratings;

    Teacher(String name, int age) {
        this.name = name;
        this.age = age;
        this.rating = 0;
        this.ratings = 0;
        this.courses = new ArrayList<Course>();
    }

    void displaySchedule() {
        // dont display age cause nobody knows how old teachers are
        println(name, "has the following schedule:");
        for (Course c : courses) {
            println(c.time, "-", c.code);
        }
        println();
    }

    void rate(float score) {
        rating = (rating*ratings + min(max(-5, score), 5))/(ratings+1);
        ratings++;
    }

    void addCourse(Course c) {
        if (courses.size() == 0) courses.add(c);
        else {
            // parse the time for the new course
            int colonIndex = c.time.indexOf(":");
            int hour = int(c.time.substring(0, colonIndex));
            int minute = int(c.time.substring(colonIndex+1));
            
            // no courses run after 4pm or beforer 4am, so make sure 1pm and 2pm are compared correctly. 3pm is allowable to give functionality for clubs
            if (hour <= 4) hour += 20;

            boolean added = false;
            for (int i = 0; i < courses.size(); i++) {
                // parse the time for this course
                int thisColonIndex = c.time.indexOf(":");
                int thisHour = int(c.time.substring(0, thisColonIndex));
                int thisMinute = int(c.time.substring(thisColonIndex+1));
                
                // no courses run after 4, so make sure 1pm and 2pm are all correct. 3pm is allowable to give functionality for clubs
                if (thisHour >= 4) hour += 20;
                
                // compare to the other course, if this course is later, insert the new course just before
                if (thisHour >= hour && thisMinute > minute) {
                    courses.add(i, c);
                    added = true;
                    break;
                }
            }

            // if it hasn't added, add it to the end
            if (!added) courses.add(c);
        }
    }

}

class Student {
    String name;
    int age;
    ArrayList<Course> courses;

    int range = 10;
    int intelligence;
    int grade;

    Student(String name, int age, int grade, int intelligence) {
        this.name = name;
        this.age = age;
        this.grade = grade;
        this.intelligence = intelligence;

        this.courses = new ArrayList<Course>();
    }

    // does a test, returning a random mark on the test, +/- range from intelligence
    int doTest(float difficulty) {
        return max(0, min(100, round(difficulty * random(intelligence-range, intelligence+range))));
    }

    void status() {
        String emotion;
        if (this.average() >= 97) emotion = "happy";
        else emotion = "sad";

        println(name, "is", emotion, "because they have a", this.average(), "average.");
        println("They are", age, "years old and in grade", grade);
        displaySchedule();
    }

    void displaySchedule() {
        println(name, "has the following schedule:");
        for (Course c : courses) {
            println(c.time, "-", c.code, "\tMark:", c.getMark(this));
        }

        println();
    }

    float average() {
        if (courses.size() == 0) return 100;

        int markSum = 0;
        for (Course c : courses) {
            markSum += c.getMark(this);
        }

        float average = markSum/courses.size();
        return round(average*10)/10.0;
    }

    // returns true if this student is already in a particular course
    boolean enrolled(Course course) {
        for (Course c : courses) {
            if (c.code == course.code && c.time == course.time) return true;
        }

        return false;
    }

    void addCourse(Course c) {
        if (this.enrolled(c)) {
            println("broke");
            return;
        }

        c.addStudent(this);

        if (courses.size() == 0) courses.add(c);
        else {
            // parse the time for the new course
            int colonIndex = c.time.indexOf(":");
            int hour = int(c.time.substring(0, colonIndex));
            int minute = int(c.time.substring(colonIndex+1));
            
            // no courses run after 4, so make sure 1pm and 2pm are all correct. 3pm is allowable to give functionality for clubs
            if (hour >= 4) hour += 20;

            boolean added = false;
            for (int i = 0; i < courses.size(); i++) {
                // parse the time for this course
                int thisColonIndex = c.time.indexOf(":");
                int thisHour = int(c.time.substring(0, thisColonIndex));
                int thisMinute = int(c.time.substring(thisColonIndex+1));
                
                // no courses run after 4, so make sure 1pm and 2pm are all correct. 3pm is allowable to give functionality for clubs
                if (thisHour >= 4) hour += 20;
                
                // compare to the other course, if this course is later, insert the new course just before
                if (thisHour >= hour && thisMinute > minute) {
                    courses.add(i, c);
                    break;
                }
            }

            if (!added) courses.add(c);
        }
    }
}