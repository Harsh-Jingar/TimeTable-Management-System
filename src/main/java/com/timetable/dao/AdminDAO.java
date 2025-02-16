
package com.timetable.dao;

import com.timetable.models.Admin;
import com.timetable.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class AdminDAO {
    
    public boolean generateTimeTable(String day, int period, String subjectName, int classroomId, String facultyName) {
    boolean isValid = true;

    // Step 1: Check if the same timetable entry already exists
    try (Connection con = DatabaseConnection.getConnection()) {
        String query = "SELECT * FROM timetable WHERE day_of_week = ? AND period = ?";
        PreparedStatement stmt = con.prepareStatement(query);
        stmt.setString(1, day);
        stmt.setInt(2, period);
//        stmt.setInt(3, classroomId);
//        stmt.setString(4, facultyName);

        ResultSet rs = stmt.executeQuery();
        
        // If the result set is not empty, the entry already exists, so return false
        if (rs.next()) {
            isValid = false;
        } else {
            // Step 2: Insert the new timetable entry
            String insertQuery = "INSERT INTO timetable (day_of_week, period, subject_name, classroom_id, faculty_name) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement insertStmt = con.prepareStatement(insertQuery);
            insertStmt.setString(1, day);
            insertStmt.setInt(2, period);
            insertStmt.setString(3, subjectName);
            insertStmt.setInt(4, classroomId);
            insertStmt.setString(5, facultyName);
            int rowsAffected = insertStmt.executeUpdate();
            
            // If the insert was successful, set isValid to true
            if (rowsAffected > 0) {
                isValid = true;
            } else {
                isValid = false;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        isValid = false;
    }
    return isValid;
}


//    public boolean generateTimeTable(String day, int period, String subjectName, int classroomId, String facultyName) {
//        boolean isValid = false;
//        String sql = "INSERT INTO timetable (day_of_week, period, subject_name, classroom_id, faculty_name) VALUES (?, ?, ?, ?, ?)";
//
//        try (Connection connection = DatabaseConnection.getConnection(); PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setString(1, day);
//            ps.setInt(2, period);
//            ps.setString(3, subjectName);
//            ps.setInt(4, classroomId);
//            ps.setString(5, facultyName);
//            ps.executeUpdate();
//            isValid = true;
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return isValid;
//    }
    
    
     public boolean validateAdmin(Admin admin) {
        boolean isValid = false;
        String query = "SELECT * FROM admin WHERE admin_id = ? AND password = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setString(1, admin.getadminId());
            statement.setString(2, admin.getPassword());
            
            ResultSet resultSet = statement.executeQuery();
            
            // Check if the faculty credentials match
            if (resultSet.next()) {
                isValid = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isValid;
    }
}
