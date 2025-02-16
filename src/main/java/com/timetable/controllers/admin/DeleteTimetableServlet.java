package com.timetable.controllers.admin;

import com.timetable.dao.TimeTableDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteTimetableServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the ID of the timetable entry to be deleted
        int id = Integer.parseInt(request.getParameter("id"));

        // Call the DAO to delete the timetable entry
        TimeTableDAO timetableDAO = new TimeTableDAO();
        try {
            timetableDAO.deleteTimetable(id);
            response.sendRedirect("admin/manageTimeTable.jsp");  // After deletion, show timetable
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");  // If an error occurs, show an error page
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to delete a timetable entry";
    }
}
