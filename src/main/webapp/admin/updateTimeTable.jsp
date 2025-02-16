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

<%@page import="com.timetable.dao.TimeTableDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.timetable.models.Timetable" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Timetable</title>
        <link rel="stylesheet" href="styles.css">

        <style>
            /* General Styling */
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f4f7fc;
                margin: 0;
                padding: 0;
            }

            h2 {
                text-align: center;
                margin-top: 30px;
                color: #333;
                font-size: 2rem;
            }

            /* Form Container */
            form {
                width: 80%;
                max-width: 600px;
                margin: 30px auto;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            /* Label Styling */
            label {
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 8px;
                display: block;
                color: #555;
            }

            /* Input and Select Field Styling */
            input[type="text"], select {
                width: 100%;
                padding: 10px;
                font-size: 1rem;
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-bottom: 15px;
                box-sizing: border-box;
                background-color: #f9f9f9;
            }

            /* Input Focus Styling */
            input[type="text"]:focus, select:focus {
                border-color: #4CAF50;
                background-color: #fff;
                outline: none;
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


            /* Responsive Design for Smaller Screens */
            @media screen and (max-width: 768px) {
                form {
                    width: 90%;
                    padding: 15px;
                }

                input[type="text"], select {
                    font-size: 0.9rem;
                    padding: 8px;
                }

                button[type="submit"] {
                    font-size: 1rem;
                    padding: 10px;
                }

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

        <form action="${pageContext.request.contextPath}/UpdateTimetableServlet" method="post">
            <input type="hidden" name="id" value="<%= timetable.getId()%>" />

            <label for="day_of_week">Day of Week:</label>
            <input type="text" id="day_of_week" name="day_of_week" value="<%= timetable.getDayOfWeek()%>"><br>

            <label for="period">Period:</label>
            <input type="text" id="period" name="period" value="<%= timetable.getPeriod()%>"><br>

            <label for="subject_name">Subject Name:</label>
            <select id="subject_name" name="subject_name" required>
                <%
                    List<String> subjectsList = (List<String>) request.getAttribute("subjects");
                    for (String subject : subjectsList) {
                %>
                <option value="<%= subject%>" <%= timetable.getSubjectName().equals(subject) ? "selected" : ""%>><%= subject%></option>
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
                <option value="<%= classroom%>" <%= timetable.getClassroomId().equals(classroom) ? "selected" : ""%>><%= classroom%></option>
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
                <option value="<%= faculty%>" <%= timetable.getFacultyName().equals(faculty) ? "selected" : ""%>><%= faculty%></option>
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
