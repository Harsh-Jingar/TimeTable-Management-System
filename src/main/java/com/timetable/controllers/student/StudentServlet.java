package com.timetable.controllers.student;

import com.timetable.dao.StudentDAO;
import com.timetable.models.Student;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve form parameters
        String studentId = request.getParameter("enrollment");
        String password = request.getParameter("studentPassword");

        Student student = new Student(studentId, password);

        // Check credentials using StudentDAO
        StudentDAO studentDAO = new StudentDAO();
        boolean isValidStudent = studentDAO.validateStudent(student);

        if (isValidStudent) {
             // Fetch faculty details including name
           String studentname = studentDAO.getStudentById(studentId);
            // Successful login
            HttpSession session = request.getSession();
            session.setAttribute("studentId", studentId);  // Store student ID in session
            
            if (studentname != null) {
                // Store faculty name in session
                session.setAttribute("studentName", studentname);
            }
            // Redirect to student dashboard
            response.sendRedirect("student/dashboard.jsp");
        } else {
            // Invalid credentials
            request.setAttribute("errorMessage", "Invalid Student ID or Password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    protected void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Invalidate the session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Invalidate the session
        }
        // Redirect to login page after logout
        response.sendRedirect("login.jsp");
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
        // Check if the request is for logout
        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            // Call the logout method if action is "logout"
            logout(request, response);
        } else {
            // Call the processRequest method for other actions
            try {
                processRequest(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(StudentServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
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
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(StudentServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Student Servlet for login and logout";
    }// </editor-fold>

}
