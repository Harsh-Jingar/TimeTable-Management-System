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

<%@page import="java.lang.String"%>
<%@page import="com.timetable.dao.AttendanceDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.timetable.dao.TimeTableDAO"%>
<%@page import="com.timetable.models.Timetable"%>
<%@page import="java.util.Calendar"%> <!-- Import Calendar to get current day -->
<%@page import="java.text.SimpleDateFormat"%> <!-- Import SimpleDateFormat for date formatting -->
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Timetable</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome/css/font-awesome.min.css">
        <style>
            /* General Styles */
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f4f7fc;
                margin: 0;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
                min-height: 100vh;
            }

            /* Heading style */
            .heading {
                text-align: center;
                font-size: 30px;
                color: #333;
                margin-bottom: 20px;
                font-weight: 600;
            }

            /* Container */
            .container {
                width: 90%;
                max-width: 1200px;
                background-color: #fff;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                border-radius: 12px;
                padding: 30px;
                transition: all 0.3s ease;
            }

            .container:hover {
                transform: scale(1.02);
            }

            /* Table Styles */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
                font-size: 16px;
                text-align: center;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            th, td {
                padding: 18px;
                border: 1px solid #ddd;
                color: #333;
            }

            th {
                background-color: #007bff;
                color: #fff;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            tr:hover {
                background-color: #e0f7fa;
            }

            /* Enhanced Strike-through */
            tr[style*="text-decoration: line-through"] {
                text-decoration: line-through solid 2px;
                color: #a9a9a9;
            }

            /* Success and Error Messages */
            .success-message {
                color: #28a745;
                background-color: #d4edda;
                border: 1px solid #c3e6cb;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 20px;
                text-align: center;
            }

            .error-message {
                color: #dc3545;
                background-color: #f8d7da;
                border: 1px solid #f5c6cb;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 20px;
                text-align: center;
            }

            /* Buttons */
            .btn {
                padding: 10px 20px;
                font-size: 14px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                color: #fff;
                text-decoration: none;
                box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }

            /* Individual Button Styles */
            .btn-update {
                background-color: #4CAF50;
            }

            .btn-cancel {
                background-color: #f44336;
            }

            .btn-attendance {
                background-color: #ff9800;
            }

            .btn:hover {
                opacity: 0.85;
                transform: translateY(-2px);
            }

            /* Disabled Button Styles */
            .btn[disabled], .btn-disabled {
                background-color: #b0b0b0;
                cursor: not-allowed;
                pointer-events: none;
            }

            /* Flex Layout for Action Buttons */
            .actions {
                display: flex;
                justify-content: center;
                gap: 12px;
            }

            /* Back Button Styles */
            .back-button {
                display: block;
                width: 100%;
                max-width: 200px;
                margin: 20px auto;
                padding: 12px 20px;
                background-color: #007bff;
                color: #fff;
                text-align: center;
                border-radius: 5px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                cursor: pointer;
            }

            .back-button:hover {
                background-color: #0056b3;
            }

        </style>   
    </head>
    <body>
        <h2 class="heading">View Timetable</h2>

        <div class="container">

            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");

                if (success != null && !success.isEmpty()) {
            %>
            <div class="success-message">
                <%= success%>
            </div>
            <%
                }
                if (error != null && !error.isEmpty()) {
            %>
            <div class="error-message">
                <%= error%>
            </div>
            <%
                }
            %>


            <%
                String facultyName = (String) session.getAttribute("facultyName");

                if (facultyName != null) {
                    TimeTableDAO timetableDAO = new TimeTableDAO();
                    AttendanceDAO attendanceDAO = new AttendanceDAO();

                    // Get current day of the week (Sunday = 1, Saturday = 7)
                    Calendar calendar = Calendar.getInstance();
                    int currentDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

                    // Adjust the current day to match your timetable (Sunday = 1, Monday = 2, ... Saturday = 7)
                    String[] daysOfWeek = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
                    String currentDay = daysOfWeek[currentDayOfWeek - 1]; // Adjust to match array index

                    // Get today's date in desired format
                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
                    String todayDate = sdf.format(calendar.getTime());

                    // Get today's date in desired format
                    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
                    String todayDate1 = sdf1.format(calendar.getTime());

                    // Display welcome message with today's date and day
%>
            <div class="welcome">
                <p>Welcome, <strong><%= facultyName%></strong>! Today is <strong><%= currentDay%></strong>, <strong><%= todayDate%></strong>.</p>
            </div>

            <%
                // Fetch timetable for today
                List<Timetable> timetableList = timetableDAO.getTimetableByFacultyAndDay(facultyName, currentDay);

                // If no classes are scheduled for today
                if (timetableList != null && !timetableList.isEmpty()) {
            %>

            <table>
                <thead>
                    <tr>
                        <th>Day</th>
                        <th>Period</th>
                        <th>Subject</th>
                        <th>Classroom</th>
                        <th>Actions</th>
                        <th>Attendance Taken</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Timetable timetable : timetableList) {
                            String status = attendanceDAO.getAttendanceStatus(timetable.getId(), todayDate1); // Attendance status
                            boolean isMarked = status != null && status.equals("marked");
                            boolean isCancelled = timetable.getCancelledClass() != null && todayDate1.equals(timetable.getCancelledClass());

                    %>
                    <tr style="<%= isCancelled ? "text-decoration: line-through; color: #a9a9a9;" : ""%>">
                        <td><%= timetable.getDayOfWeek()%></td>
                        <td><%= timetable.getPeriod()%></td>
                        <td><%= timetable.getSubjectName()%></td>
                        <td><%= timetable.getClassroomId()%></td>
                        <td class="actions">
                            <a href="timetableManage.jsp?id=<%= timetable.getId()%>" 
                               class="btn btn-update <%= isMarked || isCancelled ? "btn-disabled" : ""%>"
                               <%= isMarked || isCancelled ? "disabled" : ""%>>
                                Update
                            </a>

                            <% if (!isCancelled && !isMarked) {%>
                            <button class="btn btn-cancel" onclick="openCancelModal(<%= timetable.getId()%>)">
                                Cancel
                            </button>
                            <% } else { %>
                            <button class="btn btn-cancel" disabled>Cancelled</button>
                            <% }%>

                            <a href="markAttendance.jsp?id=<%= timetable.getId()%>" 
                               class="btn btn-attendance <%= isMarked || isCancelled ? "btn-disabled" : ""%>"
                               <%= isMarked || isCancelled ? "disabled" : ""%>>
                                Mark Attendance
                            </a>
                        </td>
                        <td>
                            <label>
                                <input type="checkbox" <%= isMarked ? "checked" : ""%> disabled />
                                Attendance <%= isMarked ? "Taken" : "Not Taken"%>
                            </label>
                        </td>
                    </tr>

                    <% } %>
                </tbody>
            </table>

            <%
            } else {
            %>
            <div class="no-records">
                No classes scheduled for today.
            </div>
            <% } %>

            <% } else { %>
            <div class="no-records">Faculty name not found. Please log in again.</div>
            <% }%>

        </div>

        <!-- Back Button -->
        <a href="dashboard.jsp" class="back-button">Go Back to Dashboard</a>
    </body>


    <script>
        let cancelTimetableId = null;
        function openCancelModal(id) {
            cancelTimetableId = id;
            if (confirm("Are you sure you want to cancel today's class?")) {
                window.location.href = "${pageContext.request.contextPath}/CancelClassServlet?id=" + cancelTimetableId;
            }
        }
    </script>

</html>
