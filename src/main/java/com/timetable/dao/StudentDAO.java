package com.timetable.dao;

import com.timetable.models.Student;
import com.timetable.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // Method to get students by timetable ID
    public List<String> getStudentsByTimetableId(int timetableId) {
        List<String> studentList = new ArrayList<>();
        String query = "SELECT s.name FROM students s "
                + "JOIN timetable t ON s.class = t.class_section "
                + "WHERE t.timetable_id = ?";

        try (Connection conn = DatabaseConnection.getConnection(); 
                PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, timetableId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                studentList.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return studentList;
    }
    
    
      public boolean validateStudent(Student student) throws SQLException {
        String query = "SELECT * FROM students WHERE student_id = ? AND password = ?";
        Connection conn = DatabaseConnection.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, student.getStudentId());
            stmt.setString(2, student.getPassword());
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // Return true if student exists with the given credentials
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getStudentById(String studentId) throws SQLException {
        String student = null;
        String query = "SELECT name FROM students WHERE student_id = ?";
        Connection conn = DatabaseConnection.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, studentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                 student = rs.getString("name");

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return student; // Return null if no student is found
    }
}
