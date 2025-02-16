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

<%@page import="java.util.List"%>
<%@page import="com.timetable.dao.StudentDAO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mark Attendance</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome/css/font-awesome.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        .heading {
            text-align: center;
            font-size: 30px;
            color: #333;
            margin-bottom: 20px;
        }

        .container {
            width: 90%;
            max-width: 800px;
            background-color: #fff;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            padding: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 16px;
            text-align: center;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
        }

        th {
            background-color: #007bff;
            color: #fff;
        }

        .status-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .btn {
            padding: 8px 15px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            color: #fff;
            text-decoration: none;
            transition: opacity 0.2s ease;
        }

        .btn-present {
            background-color: #4CAF50;
        }

        .btn-absent {
            background-color: #f44336;
        }

        .btn:hover {
            opacity: 0.85;
        }

        .submit-button {
            display: block;
            width: 100%;
            max-width: 200px;
            margin: 20px auto 0;
            padding: 12px 20px;
            background-color: #007bff;
            color: #fff;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .submit-button:hover {
            background-color: #0056b3;
        }

        /* Alert styles */
        .alert {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }

        .alert-success {
            background-color: #4CAF50;
            color: white;
        }

        .alert-danger {
            background-color: #f44336;
            color: white;
        }

        .go-back-button {
            display: inline-block;
            margin-top: 10px;
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .go-back-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h2 class="heading">Mark Attendance</h2>

    <!-- Show success or error message -->
    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
    %>

    <div class="container">
        <% if (success != null && success.equals("true")) { %>
            <div class="alert alert-success">Attendance marked successfully!</div>
        <% } else if (error != null && error.equals("true")) { %>
            <div class="alert alert-danger">An error occurred while marking attendance. Please try again.</div>
        <% } else if (error != null && error.equals("alreadyMarked")) { %>
            <div class="alert alert-danger">Attendance for this class has already been marked for today.</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/MarkAttendanceServlet" method="POST">
            <input type="hidden" name="timetableId" value="<%= request.getParameter("id") %>">
            <table>
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Attendance Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String facultyName = (String) session.getAttribute("facultyName");
                        int timetableId = Integer.parseInt(request.getParameter("id"));
                        StudentDAO studentDAO = new StudentDAO();
                        List<String> studentList = studentDAO.getStudentsByTimetableId(timetableId);

                        for (String studentName : studentList) {
                    %>
                    <tr>
                        <td><%= studentName %></td>
                        <td class="status-buttons">
                            <label>
                                <input type="radio" name="attendance_<%= studentName %>" value="Present" required>
                                <span class="btn btn-present">Present</span>
                            </label>
                            <label>
                                <input type="radio" name="attendance_<%= studentName %>" value="Absent" required>
                                <span class="btn btn-absent">Absent</span>
                            </label>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <button type="submit" class="submit-button">Submit Attendance</button>
        </form>

                <a href="viewTimeTable.jsp" class="go-back-button">Go Back</a>
    </div>
</body>
</html>
