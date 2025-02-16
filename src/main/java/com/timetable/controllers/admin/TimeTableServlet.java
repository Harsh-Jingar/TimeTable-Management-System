/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.timetable.controllers.admin;

import com.timetable.dao.AdminDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class TimeTableServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String day = request.getParameter("day");
        int period = Integer.parseInt(request.getParameter("period"));
        String subjectName = request.getParameter("subject_name");
        int classroomId = Integer.parseInt(request.getParameter("classroom_id"));
        String facultyName = request.getParameter("faculty_name");

        AdminDAO admin = new AdminDAO();
        boolean isValidate = admin.generateTimeTable(day, period, subjectName, classroomId, facultyName);

        if (isValidate) {
            // Successful insertion
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Timetable updated successfully!");

            // Redirect back to timetable generator page
            response.sendRedirect("admin/timetableGenerator.jsp");
        } else {
            // Error: Entry already exists
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Error: The timetable entry already exists for the selected day and period");

            // Redirect to the same page to show error message
            response.sendRedirect("admin/timetableGenerator.jsp");
        }
    }


// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
/**
 * Handles the HTTP <code>GET</code> method.
 *
 * @param request servlet request
 * @param response servlet response
 * @throws ServletException if a servlet-specific error occurs
 * @throws IOException if an I/O error occurs
 */
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
