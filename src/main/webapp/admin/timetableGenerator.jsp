<%
        String username = (String) session.getAttribute("adminId");
    if (username == null) {
        response.sendRedirect("/TimeTableManagement/login.jsp");
        return;
    }
    
// Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<%@page import="com.timetable.utils.DatabaseConnection"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Timetable Generator</title>
        <style>
            /* Modern and Clean CSS Styling */
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f0f2f5;
                color: #333;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .container {
                width: 600px;
                background: #ffffff;
                padding: 20px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
            }

            h2 {
                text-align: center;
                margin-bottom: 20px;
            }

            form {
                display: flex;
                flex-direction: column;
            }

            label {
                margin-bottom: 10px;
                font-weight: bold;
            }

            select, input {
                padding: 10px;
                margin-bottom: 20px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }
            button[type="submit"], .back-button {
                width: 100%;
                padding: 15px;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                margin-bottom: 3px;
            }
            button[type="submit"] {
                background-color: #4CAF50;
            }
            button[type="submit"]:hover {
                background-color: #45a049;
            }
            .back-button {
                background-color: #007bff;
            }
            .back-button:hover {
                background-color: #0056b3;
            }
            .actions {
                margin-top: 5px;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            /* Go Back Button Styles */
            .back-button {
                display: block;
                width: 100%;
                max-width: 200px;
                margin: 10px auto;
                padding: 12px 20px;
                background-color: #007bff;
                color: #fff;
                text-align: center;
                text-decoration: none;
                font-size: 16px;
                font-weight: bold;
                border-radius: 5px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border: none;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            .back-button:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Generate Timetable</h2>

            <%-- Display success message if available --%>
            <%
                String successMessage = (String) session.getAttribute("successMessage");
                String errorMessage = (String) session.getAttribute("errorMessage");

                if (successMessage != null) {
            %>
            <div class="success-message">
                <%= successMessage%>
            </div>
            <% session.removeAttribute("successMessage"); %>
        <% } else if (errorMessage != null) { %>
            <div class="error-message">
                <%= errorMessage %>
            </div>
            <% session.removeAttribute("errorMessage"); %>
        <% } %>

            <form action="${pageContext.request.contextPath}/TimeTableServlet" method="post">
                <label for="day">Select Day:</label>
                <select name="day" required>
                    <option value="Monday">Monday</option>
                    <option value="Tuesday">Tuesday</option>
                    <option value="Wednesday">Wednesday</option>
                    <option value="Thursday">Thursday</option>
                    <option value="Friday">Friday</option>
                </select>

                <label for="period">Select Period:</label>
                <input type="number" name="period" min="1" max="10" required>

                <label for="subject">Select Subject:</label>
                <select name="subject_name">
                    <%-- Dynamically fetch subjects from the database --%>
                    <%
                        DatabaseConnection db = new DatabaseConnection();
                        java.sql.Connection con = (java.sql.Connection) db.getConnection();
                        java.sql.Statement stmt = con.createStatement();
                        java.sql.ResultSet rs = stmt.executeQuery("SELECT * FROM subjects");
                        while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("subject_name")%>"><%= rs.getString("subject_name")%></option>
                    <% } %>
                </select>

                <label for="classroom">Select Classroom:</label>
                <select name="classroom_id">
                    <%
                        rs = stmt.executeQuery("SELECT * FROM classrooms");
                        while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("classroom_id")%>"><%= rs.getInt("classroom_id")%></option>
                    <% } %>
                </select>

                <label for="faculty">Select Faculty:</label>
                <select name="faculty_name">
                    <%
                        rs = stmt.executeQuery("SELECT * FROM faculty");
                        while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("faculty_name")%>"><%= rs.getString("faculty_name")%></option>
                    <% }%>
                </select>

                <div class="actions">
                    <button type="submit">Generate</button>            
                    <a href="dashboard.jsp" class="back-button">Go Back to Dashboard</a>
                </div>

            </form>
        </div>
    </body>
</html>
