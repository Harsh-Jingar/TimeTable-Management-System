package com.timetable.models;

public class AttendanceTracker {
    private String subjectName;
    private int attendedClasses;
    private int totalClasses;

    public AttendanceTracker(String subjectName, int attendedClasses, int totalClasses) {
        this.subjectName = subjectName;
        this.attendedClasses = attendedClasses;
        this.totalClasses = totalClasses;
    }

    // Getters and Setters
    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public int getAttendedClasses() {
        return attendedClasses;
    }

    public void setAttendedClasses(int attendedClasses) {
        this.attendedClasses = attendedClasses;
    }

    public int getTotalClasses() {
        return totalClasses;
    }

    public void setTotalClasses(int totalClasses) {
        this.totalClasses = totalClasses;
    }
}
