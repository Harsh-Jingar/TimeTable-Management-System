<%
    String username = (String) session.getAttribute("studentName");
    if (username == null) {
        response.sendRedirect("/TimeTableManagement/login.jsp");
        return;
    }
    // Prevent the back button from accessing this page after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.
%>
<%@page import="com.timetable.models.AttendanceTracker"%>
<%@page import="java.util.List"%>
<%@page import="com.timetable.dao.AttendanceDAO"%>
<%@page import="com.timetable.models.Attendance"%>
<%@page import="com.timetable.models.Student"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Tracker</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome/css/font-awesome.min.css">
    <style>
        /* General Styles */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7fc; /* Light Background */
            color: #333;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        .heading {
            font-size: 34px;
            color: #1f4e79; /* Dark Blue */
            margin-bottom: 20px;
            text-align: center;
            font-weight: 700;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
        }

        /* Container */
        .container {
            width: 90%;
            max-width: 1000px;
            background-color: #fff;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            padding: 20px 30px;
            border-top: 5px solid #1f4e79;
        }

        .container:hover {
            transform: translateY(-5px);
            transition: all 0.3s ease;
        }

        /* Welcome Message */
        .welcome {
            text-align: center;
            font-size: 18px;
            color: #1f4e79;
            margin-bottom: 20px;
        }

        /* Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 16px;
            color: #333;
            border-radius: 12px;
            overflow: hidden;
        }

        th, td {
            padding: 16px;
            border-bottom: 1px solid #dfe3e8;
        }

        th {
            background-color: #1f4e79;
            color: #ffffff;
            font-weight: 600;
            text-transform: uppercase;
        }

        td {
            background-color: #f8fafc;
            color: #333;
        }

        tr:nth-child(even) td {
            background-color: #eaf2f8;
        }

        tr:hover td {
            background-color: #cce4f7;
            cursor: pointer;
            transition: background 0.2s ease-in-out;
        }

        .no-records {
            text-align: center;
            font-size: 18px;
            color: #555;
            margin-top: 20px;
            padding: 10px;
            background: #d4e2f1;
            border-radius: 8px;
        }

        /* Button Styles */
        button {
            padding: 10px 20px;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            background: #1f4e79;
            color: #fff;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        button:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        button:active {
            transform: scale(0.98);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        /* Go Back Button Styles */
        .go-back-btn {
            margin-top: 20px;
            padding: 10px 25px;
            font-size: 18px;
            background-color: #f39c12; /* Orange Color */
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s, transform 0.2s;
        }

        .go-back-btn:hover {
            background-color: #e67e22; /* Darker Orange */
            transform: scale(1.05);
        }

        .go-back-btn:active {
            background-color: #d35400; /* Even darker orange */
            transform: scale(0.98);
        }
    </style>
</head>
<body>

    <h2 class="heading">Attendance Tracker</h2>

    <div class="container">

<%
    String studentId = (String) session.getAttribute("studentId");
//    String studentId = "1"; // Replace with dynamic student ID from session or authentication system
    AttendanceDAO attendanceDAO = new AttendanceDAO();
    
    // Fetch the student's attendance for all subjects
    List<AttendanceTracker> attendanceList = attendanceDAO.getAttendanceByStudentId(studentId);

    // Fetch the overall attendance percentage for the student
    double overallAttendance = attendanceDAO.getOverallAttendance(studentId);

    DecimalFormat df = new DecimalFormat("#.##");
%>

<h3>Overall Attendance: <%= df.format(overallAttendance) %>%</h3>

<table border="1" cellpadding="5" cellspacing="0">
    <thead>
        <tr>
            <th>Subject Name</th>
            <th>Attended Classes</th>
            <th>Total Classes</th>
            <th>Attendance Percentage</th>
        </tr>
    </thead>
    <tbody>
        <%
            for (AttendanceTracker attendance : attendanceList) {
                String subjectName = attendance.getSubjectName();
                int attendedClasses = attendance.getAttendedClasses();
                int totalClasses = attendance.getTotalClasses();
                double subjectPercentage = totalClasses > 0 ? (attendedClasses * 100.0) / totalClasses : 0;
        %>
        <tr>
            <td><%= subjectName %></td>
            <td><%= attendedClasses %></td>
            <td><%= totalClasses %></td>
            <td><%= df.format(subjectPercentage) %>%</td>
        </tr>
        <% } %>
    </tbody>
</table>

        <%-- If no attendance data is found --%>
        <%
            if (attendanceList == null || attendanceList.isEmpty()) {
        %>
            <div class="no-records">No attendance records found for this student.</div>
        <%
            }
        %>

        <!-- Go Back Button -->
        <button class="go-back-btn" onclick="window.history.back();">
            <i class="fa fa-arrow-left"></i> Go Back
        </button>
    </div>

</body>
</html>
