void setup() {
    Teacher wilhelm = new Teacher("Wilhelm", 420);
    Teacher schattman = new Teacher("Schattman", 69);

    wilhelm.rate(4.5);

    Student kegan = new Student("Kegan", 17, 12, 95);
    Student emre = new Student("Emre", 17, 12, 95);
    Student minseo = new Student("Minseo", 18, 12, 90);
    Student jeffrey = new Student("Jeffrey", 17, 12, 93);

    Course cs = new Course("ICS-4UI", "11:50", schattman);
    Course data = new Course("MDF-4UI", "8:30", wilhelm);
    Course calculus = new Course("MCV-4UI", "1:00", wilhelm);

    cs.addStudent(kegan);
    emre.addCourse(cs);
    minseo.addCourse(cs);
    jeffrey.addCourse(cs);

    emre.addCourse(calculus);
    minseo.addCourse(calculus);

    jeffrey.addCourse(data);
    emre.addCourse(data);

    wilhelm.displaySchedule();
    emre.displaySchedule();

    cs.test(0.9);
    data.test(0.75);
    calculus.test(0.6);
    cs.test(1);

    schattman.rate(4.7);
    wilhelm.rate(1);
    wilhelm.rate(-0.5);

    kegan.status();
    emre.status();
    cs.displayStudents();

    exit();
}