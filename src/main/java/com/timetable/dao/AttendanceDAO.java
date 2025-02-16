package com.timetable.dao;

import com.timetable.models.Attendance;
import com.timetable.models.AttendanceTracker;
import com.timetable.utils.DatabaseConnection;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class AttendanceDAO {

    // Method to check if attendance is marked for a particular timetable entry
    public String getAttendanceStatus(int timetableId, String todayDate) {
        String status = null;
        String query = "SELECT taken FROM attendance WHERE timetable_id = ? and date = ?";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, timetableId);
            stmt.setString(2, todayDate);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    status = rs.getString("taken");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return status; // Returns "marked" or null (or any other status if applicable)
    }

    // Method to mark attendance for students
    public boolean markAttendance(int timetableId, List<Integer> studentIds, String date) {
        String query = "INSERT INTO attendance (timetable_id, student_id, date, taken) VALUES (?, ?, ?, ?)";
        boolean success = true;

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            for (int studentId : studentIds) {
                stmt.setInt(1, timetableId);
                stmt.setInt(2, studentId);
                stmt.setString(3, date);
                stmt.setString(4, "marked");
                stmt.addBatch();
            }
            stmt.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
            success = false;
        }

        return success;
    }

    // Method to fetch all attendance records for a given timetable entry
    public List<Attendance> getAttendanceByTimetable(int timetableId) {
        List<Attendance> attendanceList = new ArrayList<>();
        String query = "SELECT student_id, date, taken FROM attendance WHERE timetable_id = ?";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, timetableId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Attendance attendance = new Attendance();
                    attendance.setStudentId(rs.getInt("student_id"));
                    attendance.setDate(rs.getString("date"));
                    attendance.setStatus(rs.getString("taken"));
                    attendanceList.add(attendance);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return attendanceList;
    }

    public String getAttendancestatus(int timetableId, String date, String studentId) {
        String status = null;
        try {
            Connection conn = DatabaseConnection.getConnection();
            String query = "SELECT status FROM attendance WHERE timetable_id = ? AND date = ? AND student_id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, timetableId);
            ps.setString(2, date);
            ps.setString(3, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                status = rs.getString("status");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Method to fetch the attendance details of a student for all subjects
    public List<AttendanceTracker> getAttendanceByStudentId(String studentId) {
        List<AttendanceTracker> attendanceList = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();) {
            String query = "SELECT " +
                     "t.subject_name, " +
                     "SUM(CASE WHEN a.taken = 'marked' AND a.status = 'Present' THEN 1 ELSE 0 END) AS attended_classes, " +
                     "COUNT(CASE WHEN a.taken = 'marked' THEN 1 ELSE NULL END) AS total_classes " +
                     "FROM attendance a " +
                     "JOIN timetable t ON a.timetable_id = t.timetable_id " +
                     "WHERE a.student_id = ? " +
                     "GROUP BY t.subject_name"; // Query to fetch attendance by subject

            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, studentId);  // Set student_id
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String subjectName = rs.getString("subject_name");
                    int attendedClasses = rs.getInt("attended_classes");
                    int totalClasses = rs.getInt("total_classes");
                    attendanceList.add(new AttendanceTracker(subjectName, attendedClasses, totalClasses));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return attendanceList;
    }

    // Method to get overall attendance for a student (across all subjects)
    public double getOverallAttendance(String studentId) {
        int totalAttended = 0;
        int totalClasses = 0;

        try (Connection conn = DatabaseConnection.getConnection();) {
            String query = "SELECT "
                     + "SUM(CASE WHEN a.taken = 'marked' AND a.status = 'Present' THEN 1 ELSE 0 END) AS attended_classes, "
                     + "COUNT(CASE WHEN a.taken = 'marked' THEN 1 ELSE NULL END) AS total_classes "
                     + "FROM attendance a "
                     + "WHERE a.student_id = ?";
 // Query to fetch total attendance for the student

            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, studentId); // Set student_id
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    totalAttended = rs.getInt("attended_classes");
                    totalClasses = rs.getInt("total_classes");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalClasses > 0 ? (totalAttended * 100.0) / totalClasses : 0;
    }
}
