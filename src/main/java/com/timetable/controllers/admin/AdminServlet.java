package com.timetable.controllers.admin;

import com.timetable.dao.AdminDAO;
import com.timetable.models.Admin;
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

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve form parameters
        String adminId = request.getParameter("adminId");
        String password = request.getParameter("adminPassword");

        Admin admin = new Admin(adminId, password);

        // Check credentials using AdminDAO
        AdminDAO adminDAO = new AdminDAO();
        boolean isValidAdmin = adminDAO.validateAdmin(admin);

        if (isValidAdmin) {
            // Successful login
            HttpSession session = request.getSession();
            session.setAttribute("adminId", adminId);  // Store admin ID in session

            // Redirect to admin dashboard
            response.sendRedirect("admin/dashboard.jsp");
        } else {
            // Invalid credentials
            request.setAttribute("errorMessage", "Invalid Admin ID or Password");
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
                Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Servlet for login and logout";
    }// </editor-fold>

}
