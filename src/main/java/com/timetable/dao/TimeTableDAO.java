package com.timetable.dao;

import com.timetable.models.Timetable;
import com.timetable.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TimeTableDAO {

    private Connection con;

    // Method to fetch the entire timetable from the database
    public List<Timetable> getAllTimetables() {
        List<Timetable> timetableList = new ArrayList<>();
        try {
            con = DatabaseConnection.getConnection();
            String query = "SELECT * FROM timetable ORDER BY day_of_week, period";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Timetable timetable = new Timetable(
                        rs.getInt("timetable_id"),
                        rs.getString("day_of_week"),
                        rs.getString("period"),
                        rs.getString("subject_name"),
                        rs.getString("classroom_id"),
                        rs.getString("faculty_name")
                );
                timetableList.add(timetable);
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return timetableList;
    }

    public List<Timetable> getTimetableByFacultyAndDay(String facultyName, String dayOfWeek) throws SQLException {
        List<Timetable> timetableList = new ArrayList<>();
        String query = "SELECT * FROM timetable WHERE faculty_name = ? AND day_of_week = ? ORDER BY period";
        con = DatabaseConnection.getConnection();

        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, facultyName);
            ps.setString(2, dayOfWeek);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Timetable timetable = new Timetable();
                timetable.setId(rs.getInt("timetable_id"));
                timetable.setDayOfWeek(rs.getString("day_of_week"));
                timetable.setPeriod(rs.getString("period"));
                timetable.setSubjectName(rs.getString("subject_name"));
                timetable.setClassroomId(rs.getString("classroom_id"));
                timetable.setFacultyName(rs.getString("faculty_name"));
                timetable.setCancelledClass(rs.getString("cancelled_class"));
                timetableList.add(timetable);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return timetableList;
    }

    public void deleteTimetable(int id) throws SQLException {
        try {
            con = DatabaseConnection.getConnection();
            String query = "DELETE FROM timetable WHERE timetable_id = ?";
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, id);  // Use the ID to delete the specific timetable entry
            stmt.executeUpdate();
            stmt.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updateTimetable(Timetable timetable) {
        try {
            con = DatabaseConnection.getConnection();
            String query = "UPDATE timetable SET day_of_week = ?, period = ?, subject_name = ?, classroom_id = ?, faculty_name = ? WHERE timetable_id = ?";
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, timetable.getDayOfWeek());
            stmt.setString(2, timetable.getPeriod());
            stmt.setString(3, timetable.getSubjectName());
            stmt.setString(4, timetable.getClassroomId());
            stmt.setString(5, timetable.getFacultyName());
            stmt.setInt(6, timetable.getId());

            int rowsUpdated = stmt.executeUpdate();
            stmt.close();
            con.close();

            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to get timetable for a specific faculty
    public List<Timetable> getTimetableByFaculty(String facultyName) {
        List<Timetable> timetableList = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            // Establish a connection to the database
            connection = DatabaseConnection.getConnection(); // Assuming DatabaseConnection is a utility class for DB connection

            // SQL query to fetch timetable entries for the specific faculty
            String query = "SELECT timetable_id, day_of_week, period, subject_name, classroom_id, faculty_name "
                    + "FROM timetable WHERE faculty_name = ?";

            // Prepare the statement
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, facultyName);

            // Execute the query
            resultSet = preparedStatement.executeQuery();

            // Process the result set and populate the timetable list
            while (resultSet.next()) {
                int id = resultSet.getInt("timetable_id");
                String dayOfWeek = resultSet.getString("day_of_week");
                String period = resultSet.getString("period");
                String subjectName = resultSet.getString("subject_name");
                String classroomId = resultSet.getString("classroom_id");
                String faculty = resultSet.getString("faculty_name");

                // Create a Timetable object and add it to the list
                Timetable timetable = new Timetable(id, dayOfWeek, period, subjectName, classroomId, faculty);
                timetableList.add(timetable);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Handle exceptions properly, maybe log them in real applications
        } finally {
            // Clean up resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return timetableList;
    }

    public List<String> getSubjects() throws SQLException {
        con = DatabaseConnection.getConnection();
        List<String> subjects = new ArrayList<>();
        String query = "SELECT DISTINCT subject_name FROM subjects";
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        while (rs.next()) {
            subjects.add(rs.getString("subject_name"));
        }
        return subjects;
    }

    public List<String> getClassrooms() throws SQLException {
        con = DatabaseConnection.getConnection();
        List<String> classrooms = new ArrayList<>();
        String query = "SELECT DISTINCT classroom_id FROM classrooms";
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        while (rs.next()) {
            classrooms.add(rs.getString("classroom_id"));
        }
        return classrooms;
    }

    public List<String> getFacultyNames() throws SQLException {
        con = DatabaseConnection.getConnection();
        List<String> facultyNames = new ArrayList<>();
        String query = "SELECT DISTINCT faculty_name FROM faculty";
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        while (rs.next()) {
            facultyNames.add(rs.getString("faculty_name"));
        }
        return facultyNames;
    }

    // Method to cancel a class (delete or mark it as canceled)
    public boolean cancelClass(int classId) throws SQLException {
        con = DatabaseConnection.getConnection();
        String sql = "UPDATE timetable SET status = 'Cancelled' WHERE timetable_id = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, classId);
            int rowsUpdated = statement.executeUpdate();

            // Check if the update was successful
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to reschedule a class (update the day, period, or other details)
    public boolean rescheduleClass(String newDetails, int classId) throws SQLException {
        con = DatabaseConnection.getConnection();
        String[] details = newDetails.split(",");
        String newDayOfWeek = details[0];
        String newPeriod = details[1];
        String newClassroom = details[2];

        String sql = "UPDATE timetable SET day_of_week = ?, period = ?, classroom_id = ? WHERE timetable_id = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, newDayOfWeek);
            statement.setString(2, newPeriod);
            statement.setString(3, newClassroom);
            statement.setInt(4, classId);

            int rowsUpdated = statement.executeUpdate();

            // Check if the update was successful
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to fetch a single timetable entry by ID
    public Timetable getTimetableById(int id) throws SQLException {
        con = DatabaseConnection.getConnection();
        Timetable timetable = null;
        String query = "SELECT * FROM timetable WHERE timetable_id = ?";

        try (PreparedStatement preparedStatement = con.prepareStatement(query)) {

            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                timetable = new Timetable();
                timetable.setId(resultSet.getInt("timetable_id"));
                timetable.setDayOfWeek(resultSet.getString("day_of_week"));
                timetable.setPeriod(resultSet.getString("period"));
                timetable.setSubjectName(resultSet.getString("subject_name"));
                timetable.setClassroomId(resultSet.getString("classroom_id"));
                timetable.setFacultyName(resultSet.getString("faculty_name"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return timetable;
    }

    // Method to fetch timetable entries by specific day and time slot
    public List<Timetable> getTimetableByDayAndTime(String dayOfWeek, String period) {
        List<Timetable> timetableList = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            // Establish connection
            connection = DatabaseConnection.getConnection();

            // SQL query to fetch the timetable for the specified day and period
            String query = "SELECT timetable_id, day_of_week, period, subject_name, classroom_id, faculty_name "
                    + "FROM timetable WHERE day_of_week = ? AND period = ?";

            // Prepare statement
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, dayOfWeek);
            preparedStatement.setString(2, period);

            // Execute query
            resultSet = preparedStatement.executeQuery();

            // Process result set
            while (resultSet.next()) {
                int id = resultSet.getInt("timetable_id");
                String day = resultSet.getString("day_of_week");
                String timePeriod = resultSet.getString("period");
                String subjectName = resultSet.getString("subject_name");
                String classroomId = resultSet.getString("classroom_id");
                String facultyName = resultSet.getString("faculty_name");

                // Create Timetable object and add it to the list
                Timetable timetable = new Timetable(id, day, timePeriod, subjectName, classroomId, facultyName);
                timetableList.add(timetable);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return timetableList;
    }

    public List<Timetable> getTimetableByDay(String dayOfWeek) throws SQLException {
        List<Timetable> timetableList = new ArrayList<>();
        con = DatabaseConnection.getConnection();
        String query = "SELECT * FROM timetable WHERE day_of_week = ?";
        try (PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setString(1, dayOfWeek);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                timetableList.add(new Timetable(
                        rs.getInt("timetable_id"),
                        rs.getString("day_of_week"),
                        rs.getString("period"),
                        rs.getString("subject_name"),
                        rs.getString("classroom_id"),
                        rs.getString("faculty_name")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return timetableList;
    }

}
