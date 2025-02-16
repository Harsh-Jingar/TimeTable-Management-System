package com.timetable.models;

public class Student {
    private String studentId;
    private String name;
    private String studentClass;
    private String password;

    public Student(String studentId, String name, String studentClass, String password) {
        this.studentId = studentId;
        this.name = name;
        this.studentClass = studentClass;
        this.password = password;
    }

    public Student(String studentId, String password) {
       this.studentId = studentId;
       this.password = password;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStudentClass() {
        return studentClass;
    }

    public void setStudentClass(String studentClass) {
        this.studentClass = studentClass;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
