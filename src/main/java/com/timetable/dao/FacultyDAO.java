package com.timetable.dao;

import com.timetable.models.Faculty;
import com.timetable.utils.DatabaseConnection;

import java.sql.*;

public class FacultyDAO {

    public boolean validateFaculty(Faculty faculty) {
        boolean isValid = false;
        String query = "SELECT * FROM faculty WHERE faculty_id = ? AND password = ?";

        try (Connection connection = DatabaseConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, faculty.getFacultyId());
            statement.setString(2, faculty.getPassword());

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

    // FacultyDAO.java
    public String getFacultyDetails(String facultyId) {
        String faculty = null;
        try {
            Connection con = DatabaseConnection.getConnection(); // Assuming you have a method to get the DB connection
            String query = "SELECT faculty_name FROM faculty WHERE faculty_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, facultyId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                faculty = rs.getString("faculty_name");
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return faculty;
    }

}
