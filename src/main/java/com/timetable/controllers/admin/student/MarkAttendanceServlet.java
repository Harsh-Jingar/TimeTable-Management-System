package com.timetable.controllers.admin.student;

import com.timetable.dao.StudentDAO;
import com.timetable.utils.DatabaseConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class MarkAttendanceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int timetableId = Integer.parseInt(request.getParameter("timetableId"));
        String date = new java.sql.Date(System.currentTimeMillis()).toString(); // Current date
        StudentDAO studentDAO = new StudentDAO();
        List<String> studentList = studentDAO.getStudentsByTimetableId(timetableId);

        // Database connection
        try (Connection conn = DatabaseConnection.getConnection()) {
            
            // Check if attendance has already been marked for this timetable and date
            if (isAttendanceMarkedForToday(conn, timetableId, date)) {
                // Redirect with an error if attendance is already marked
                response.sendRedirect("faculty/markAttendance.jsp?id=" + timetableId + "&error=alreadyMarked");
                return;
            }
            
            String query = "INSERT INTO attendance (timetable_id, student_id, date, taken, status) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(query);

            // Loop through the student list to mark attendance
            for (String studentName : studentList) {
                String status = request.getParameter("attendance_" + studentName);

                // Fetch student_id using student name
                int studentId = getStudentIdByName(conn, studentName);

                if (studentId != -1) {
                    ps.setInt(1, timetableId);
                    ps.setInt(2, studentId);
                    ps.setString(3, date);
                    ps.setString(4,"marked");
                    ps.setString(5, status);
                    ps.addBatch();
                }
            }

            // Execute batch update
            ps.executeBatch();
            response.sendRedirect("faculty/viewTimeTable.jsp?id=" + timetableId + "&success=Attendance Marked Successfully...");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("faculty/viewTimeTable.jsp?id=" + timetableId + "&error=Technical Error! Try Again");
        }
    }

    // Helper method to check if attendance has already been marked for the given timetable and date
    private boolean isAttendanceMarkedForToday(Connection conn, int timetableId, String date) throws SQLException {
        String query = "SELECT COUNT(*) FROM attendance WHERE timetable_id = ? AND date = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, timetableId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // If the count is greater than 0, attendance is already marked
            }
        }
        return false; // No attendance marked yet
    }

    // Helper method to fetch student ID by name
    private int getStudentIdByName(Connection conn, String studentName) throws SQLException {
        String query = "SELECT student_id FROM students WHERE name = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, studentName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("student_id");
            }
        }
        return -1; // Return -1 if student not found
    }
}
