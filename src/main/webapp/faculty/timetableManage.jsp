<%
         String username = (String) session.getAttribute("facultyName");
    if (username == null) {
        response.sendRedirect("/TimeTableManagement/login.jsp");
        return;
    }
    
// Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<%@page import="com.timetable.dao.TimeTableDAO"%>
<%@page import="com.timetable.models.Timetable"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Timetable</title>
        <link rel="stylesheet" href="styles.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f7fc;
                padding: 20px;
            }
            h2 {
                text-align: center;
                color: #333;
            }
            form {
                width: 80%;
                max-width: 600px;
                margin: auto;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }
            label {
                font-weight: bold;
                margin-top: 10px;
                display: block;
            }
            input[type="text"], select {
                width: 100%;
                padding: 8px;
                margin-top: 5px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            button[type="submit"], .back-button {
                width: 100%;
                padding: 10px;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                margin-bottom: 10px;
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
                margin-top: 20px;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            /* Go Back Button Styles */
.back-button {
    display: block;
    width: 100%;
    max-width: 200px;
    margin: 30px auto;
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

        <h2>Update Timetable Entry</h2>
        
        <%
            String id = request.getParameter("id");
            TimeTableDAO timetableDAO = new TimeTableDAO();
            Timetable timetable = timetableDAO.getTimetableById(Integer.parseInt(id));

            // Fetch lists for dropdowns
            List<String> subjects = timetableDAO.getSubjects();
            List<String> classrooms = timetableDAO.getClassrooms();
            List<String> facultyNames = timetableDAO.getFacultyNames();

            request.setAttribute("subjects", subjects);
            request.setAttribute("classrooms", classrooms);
            request.setAttribute("facultyNames", facultyNames);
        %>

        <form action="${pageContext.request.contextPath}/UpdateTimeTableServlet" method="post">
            <input type="hidden" name="id" value="<%= timetable.getId() %>" />

            <label for="day_of_week">Day of Week:</label>
            <input type="text" id="day_of_week" name="day_of_week" value="<%= timetable.getDayOfWeek() %>"><br>

            <label for="period">Period:</label>
            <input type="text" id="period" name="period" value="<%= timetable.getPeriod() %>"><br>

            <label for="subject_name">Subject Name:</label>
            <select id="subject_name" name="subject_name" required>
                <%
                    List<String> subjectsList = (List<String>) request.getAttribute("subjects");
                    for (String subject : subjectsList) {
                %>
                    <option value="<%= subject %>" <%= timetable.getSubjectName().equals(subject) ? "selected" : "" %>><%= subject %></option>
                <%
                    }
                %>
            </select><br>

            <label for="classroom_id">Classroom ID:</label>
            <select id="classroom_id" name="classroom_id" required>
                <%
                    List<String> classroomsList = (List<String>) request.getAttribute("classrooms");
                    for (String classroom : classroomsList) {
                %>
                    <option value="<%= classroom %>" <%= timetable.getClassroomId().equals(classroom) ? "selected" : "" %>><%= classroom %></option>
                <%
                    }
                %>
            </select><br>

            <label for="faculty_name">Faculty Name:</label>
            <select id="faculty_name" name="faculty_name" required>
                <%
                    List<String> facultyList = (List<String>) request.getAttribute("facultyNames");
                    for (String faculty : facultyList) {
                %>
                    <option value="<%= faculty %>" <%= timetable.getFacultyName().equals(faculty) ? "selected" : "" %>><%= faculty %></option>
                <%
                    }
                %>
            </select><br>

            <div class="actions">
                <button type="submit">Update</button>
                <a href="dashboard.jsp" class="back-button">Go Back to Dashboard</a>
            </div>
        </form>

    </body>
</html>
