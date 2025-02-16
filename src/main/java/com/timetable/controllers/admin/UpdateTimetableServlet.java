package com.timetable.controllers.admin;

import com.timetable.dao.TimeTableDAO;
import com.timetable.models.Timetable;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdateTimetableServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Retrieve the updated timetable data from the request
        int id = Integer.parseInt(request.getParameter("id"));
        String dayOfWeek = request.getParameter("day_of_week");
        String period = request.getParameter("period");
        String subjectName = request.getParameter("subject_name");
        String classroomId = request.getParameter("classroom_id");
        String facultyName = request.getParameter("faculty_name");

        // Create a Timetable object with the updated data
        Timetable timetable = new Timetable(id, dayOfWeek, period, subjectName, classroomId, facultyName);

        // Call the DAO to update the timetable entry
        TimeTableDAO timetableDAO = new TimeTableDAO();
        boolean isUpdated = timetableDAO.updateTimetable(timetable);

        // Redirect based on the success of the update operation
        if (isUpdated) {
            // Update successful, redirect to the timetable view page
            response.sendRedirect("admin/manageTimeTable.jsp");
        } else {
            // Update failed, show an error message
            response.sendRedirect("dashboard.jsp");
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
        return "Servlet to update a timetable entry";
    }
}
