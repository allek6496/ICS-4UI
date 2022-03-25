class Course {
    String code;
    String time;
    HashMap<Student, Integer> students;
    Teacher teacher;

    // never have any tests already
    int tests = 0;

    Course(String code, String time, Teacher teacher) {
        this.code = code;
        this.time = time;
        this.teacher = teacher;
        this.students = new HashMap<Student, Integer>();
        
        teacher.addCourse(this);
    }

    /*
    // from https://stackoverflow.com/questions/46444855/checking-if-arraylist-contains-an-object-with-an-attribute
    @Override
    public boolean equals(Object o) {
        if (o instanceof Course) {
            Course p = (Course) o;
            return this.code.equals(p.code);
        } else {
            return false;
        }
    }*/

    // return true if a student of the same name and age is found
    boolean hasStudent(Student student) {
        for(Student s : students.keySet()) {
            if (student.name == s.name && student.age == s.age) return true;
        } return false;
    }

    void addStudent(Student s) {
        if (this.hasStudent(s)) return;

        students.put(s, 100);

        s.addCourse(this);
    }

    void displayStudents() {
        float average = 0;

        println(code, "runs at", time, "and the student list is:");
        for (HashMap.Entry<Student, Integer> s : students.entrySet()) {
            Student student = s.getKey();
            println(student.name, "who has a mark of", this.getMark(student));
        }
        println();
    }

    int getMark(Student s) {
        return students.get(s);
    }

    // tests every student in the course, difficulty from 0 (impossible) to 1 (easy but not free) modifies the student's mark (numbers over 1 technically work but will give a lot of 100s)
    void test(float difficulty) {
        if (difficulty < 0.8) println("Uh oh! Difficult test happening in", this.code);
        else println("Easy test happening in", this.code);
        println();

        for(HashMap.Entry<Student, Integer> s : students.entrySet()) {
            Student student = s.getKey();
            int average = s.getValue();
            int mark = student.doTest(difficulty);

            students.replace(student, (average*tests + mark)/(tests+1));
        }
    }
}