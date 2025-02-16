package com.timetable.controllers.faculty;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.timetable.utils.DatabaseConnection;

public class CancelClassServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String timetableId = request.getParameter("id");
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            
            // Get today's date
            Calendar calendar = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String todayDate = sdf.format(calendar.getTime());

            // Update cancelled_class column with today's date
            String sql = "UPDATE timetable SET cancelled_class = ? WHERE timetable_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, todayDate);
            pstmt.setString(2, timetableId);
            
            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("faculty/viewTimeTable.jsp?success=Class cancelled successfully");
            } else {
                response.sendRedirect("faculty/viewTimeTable.jsp?error=Failed to cancel class");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("faculty/viewTimeTable.jsp?error=An error occurred");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
