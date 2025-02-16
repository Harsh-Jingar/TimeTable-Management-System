package com.timetable.models;

public class Timetable {
    private int id; // New field for the unique ID
    private String dayOfWeek;
    private String period;
    private String subjectName;
    private String classroomId;
    private String facultyName;
    private String cancelledclass;

    // Default Constructor (Fix for the error)
    public Timetable() {
    }

    // Parameterized Constructor
    public Timetable(int id, String dayOfWeek, String period, String subjectName, String classroomId, String facultyName) {
        this.id = id;
        this.dayOfWeek = dayOfWeek;
        this.period = period;
        this.subjectName = subjectName;
        this.classroomId = classroomId;
        this.facultyName = facultyName;
    }

    // Getters and setters
    
    public String getCancelledClass(){
        return cancelledclass;
    }
    
    public void setCancelledClass(String cancelledclass){
        this.cancelledclass =  cancelledclass;
    }
    
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public String getClassroomId() {
        return classroomId;
    }

    public void setClassroomId(String classroomId) {
        this.classroomId = classroomId;
    }

    public String getFacultyName() {
        return facultyName;
    }

    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }
}
