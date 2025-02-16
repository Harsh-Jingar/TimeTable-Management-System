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


<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.timetable.dao.TimeTableDAO"%>
<%@page import="com.timetable.models.Timetable"%>
<%@page import="com.timetable.dao.AttendanceDAO"%>
<%@page import="com.timetable.models.Attendance"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Today's Classes</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome/css/font-awesome.min.css">
<style>
    /* General Styles */
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f0f4f8; /* Light Blue-Grey Background */
        color: #333;
        margin: 0;
        padding: 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 100vh;
        animation: fadeIn 0.5s ease-in-out;
    }

    @keyframes fadeIn {
        0% {
            opacity: 0;
        }
        100% {
            opacity: 1;
        }
    }

    /* Heading Style */
    .heading {
        font-size: 34px;
        margin-bottom: 20px;
        font-weight: 700;
        color: #1f4e79; /* Dark Blue */
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    }

    /* Container Styles */
    .container {
        width: 90%;
        max-width: 1000px;
        background-color: #ffffff; /* White Background */
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        border-radius: 12px;
        padding: 20px 30px;
        border-top: 5px solid #1f4e79; /* Accent Dark Blue Border */
    }

    .container:hover {
        transform: translateY(-5px);
        transition: all 0.3s ease;
    }

    /* Welcome Message */
    .welcome {
        text-align: center;
        font-size: 18px;
        color: #1f4e79; /* Dark Blue */
        margin-bottom: 15px;
    }

    /* Table Styles */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
        font-size: 16px;
        color: #333;
        border-radius: 12px;
        overflow: hidden;
    }

    th, td {
        padding: 16px;
        border-bottom: 1px solid #dfe3e8; /* Light Grey Border */
    }

    th {
        background-color: #1f4e79; /* Dark Blue */
        color: #ffffff; /* White Text */
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    td {
        background-color: #f8fafc; /* Very Light Blue */
        color: #333;
    }

    tr:nth-child(even) td {
        background-color: #eaf2f8; /* Light Blue Alternate Rows */
    }

    tr:hover td {
        background-color: #cce4f7; /* Lighter Blue on Hover */
        cursor: pointer;
        transition: background 0.2s ease-in-out;
    }

    .no-records {
        text-align: center;
        font-size: 18px;
        color: #555;
        margin-top: 20px;
        padding: 10px;
        background: #d4e2f1; /* Soft Blue Background */
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
    <h2 class="heading">Today's Classes</h2>
    <div class="container">
        <%
            // Get the current day of the week
            Calendar calendar = Calendar.getInstance();
            int currentDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

            // Mapping day of week (Sunday=1, Monday=2, etc.)
            String[] daysOfWeek = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
            String currentDay = daysOfWeek[currentDayOfWeek - 1];

            // Get today's date in a readable format
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String todayDate = sdf.format(calendar.getTime());

            // Initialize DAO to fetch classes and attendance
            TimeTableDAO timetableDAO = new TimeTableDAO();
            AttendanceDAO attendanceDAO = new AttendanceDAO();

            List<Timetable> todayClasses = timetableDAO.getTimetableByDay(currentDay);

            // Mapping periods to time slots
            String[] timeSlots = {
                "9:00 AM - 9:55 AM",   // Period 1
                "10:00 AM - 10:55 AM", // Period 2
                "11:00 AM - 11:55 AM", // Period 3
                "12:00 PM - 12:55 PM", // Period 4
                "Recess (1:00 PM - 2:00 PM)", // Recess
                "2:00 PM - 2:55 PM",   // Period 5
                "3:00 PM - 3:55 PM",   // Period 6
                "4:00 PM - 4:55 PM"    // Period 7
            };

            %>
        <div class="welcome">
            <p>Today is <strong><%= currentDay %></strong>, <strong><%= todayDate %></strong>.</p>
        </div>

        <%
            if (todayClasses != null && !todayClasses.isEmpty()) {
        %>
        <table>
            <thead>
                <tr>
                    <th>Timing</th>
                    <th>Subject</th>
                    <th>Classroom</th>
                    <th>Faculty Name</th>
                    <th>Attendance Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Timetable timetable : todayClasses) {
                        int period = Integer.parseInt(timetable.getPeriod());
                        String timing = (period >= 1 && period <= 4) ? timeSlots[period - 1] :
                                        (period == 5) ? "Recess (1:00 PM - 2:00 PM)" :
                                        (period >= 6 && period <= 8) ? timeSlots[period - 1] : "Unknown Period";
                        
                        if (period == 5) continue; // Skip Recess
                        
                        String studentId = (String) session.getAttribute("studentId");
                        // Fetch attendance status
                        String status = attendanceDAO.getAttendancestatus(timetable.getId(), todayDate, studentId);
                        if (status == null) {
                            status = "Not Marked";
                        }
                %>
                <tr>
                    <td><%= timing %></td>
                    <td><%= timetable.getSubjectName() %></td>
                    <td><%= timetable.getClassroomId() %></td>
                    <td><%= timetable.getFacultyName() %></td>
                    <td><%= status %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <%
            } else {
        %>
        <div class="no-records">No classes scheduled for today.</div>
        <% } %>
        
        <!-- Go Back Button -->
        <button class="go-back-btn" onclick="window.history.back();">
            <i class="fa fa-arrow-left"></i> Go Back
        </button>
    </div>
</body>
</html>
