package com.timetable.models;

public class Faculty {
    private String facultyId;
    private String password;

    // Constructor
    public Faculty(String facultyId, String password) {
        this.facultyId = facultyId;
        this.password = password;
    }

    // Getters and setters
    public String getFacultyId() {
        return facultyId;
    }

    public void setFacultyId(String facultyId) {
        this.facultyId = facultyId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
