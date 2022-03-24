class Course {
    String code;
    String time;
    HashMap<Student, int> students;
    Teacher teacher;

    // never have any tests already
    int tests = 0;

    Course(code, time, teacher) {
        this.code = code;
        this.time = time;
        this.teacher = teacher;
        this.students = new ArrayList<Student>();
    }

    void addStudent(Student s) {
        students.put(s, 100);
    }

    void addStudent(Student s, int mark) {
        students.put(s, mark);
    }

    void displayStudents() {
        float average = 0;

        println(code, "runs at", time)
        for (Map.Entry<Student, int> s : students.entrySet()) {
            
        }
    }

    int getMark(Student s) {
        return students.get(s);
    }

    // tests every student in the course, difficulty from 0 to 1 modifies the student's mark
    void test(float difficulty) {
        for(Map.Entry<Student, int> s : students.entrySet()) {
            Student student = s.getKey();
            int average = s.getValue();
            int mark = student.test(difficulty);

            students.replace(student, (average*tests + mark)/(tests+1));
        }
    }
}