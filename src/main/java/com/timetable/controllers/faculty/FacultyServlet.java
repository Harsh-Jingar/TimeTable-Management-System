/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.timetable.controllers.faculty;

import com.timetable.dao.FacultyDAO;
import com.timetable.models.Faculty;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class FacultyServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        // Retrieve form parameters
        String facultyId = request.getParameter("facultyId");
        String password = request.getParameter("facultyPassword");

        // Create a Faculty object with the input data
        Faculty faculty = new Faculty(facultyId, password);

        // Check credentials using FacultyDAO
        FacultyDAO facultyDAO = new FacultyDAO();
        boolean isValidFaculty = facultyDAO.validateFaculty(faculty);

        if (isValidFaculty) {
            // Fetch faculty details including name
           String facultyDetails = facultyDAO.getFacultyDetails(facultyId);
            // Successful login
            HttpSession session = request.getSession();
            session.setAttribute("facultyId", facultyId);  // Store faculty ID in session

            if (facultyDetails != null) {
                // Store faculty name in session
                session.setAttribute("facultyName", facultyDetails);
            }

            // Redirect to faculty dashboard
            response.sendRedirect("faculty/dashboard.jsp");
        } else {
            // Invalid credentials
            request.setAttribute("errorMessage", "Invalid Faculty ID or Password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
