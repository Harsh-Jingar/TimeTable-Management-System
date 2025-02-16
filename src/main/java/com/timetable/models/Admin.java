package com.timetable.models;

public class Admin {
    private String adminId;
    private String password;

    // Constructor
    public Admin(String adminId, String password) {
        this.adminId = adminId;
        this.password = password;
    }

    // Getters and setters
    public String getadminId() {
        return adminId;
    }

    public void setadminId(String adminId) {
        this.adminId = adminId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
