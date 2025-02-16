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
s
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.timetable.dao.TimeTableDAO" %>
<%@ page import="com.timetable.models.Timetable" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Computer Engineering Timetable</title>
        <style>
            /* Global Styles */
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(to right, #e3f2fd, #ffffff);
                color: #333;
                margin: 0;
                padding: 0;
            }

            /* Container Styling */
            .container {
                max-width: 100%;
                margin: 10px auto;
                padding: 10px;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
                animation: fadeIn 0.8s ease-in-out;
                box-sizing: border-box;
            }

            /* Heading Styling */
            h3 {
                text-align: center;
                color: #007bff;
                font-size: 1.8rem;
                margin-bottom: 15px;
                font-weight: 700;
                position: relative;
            }

            /* Enhanced Table Styles for Compact Design */
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                border: 2px solid #007bff;
                table-layout: fixed; /* Ensures columns have equal width */
                border-radius: 10px;
                overflow: hidden;
            }

            th, td {
                padding: 8px 10px;
                text-align: center;
                font-size: 0.85rem;
                word-wrap: break-word; /* Prevents overflow */
                border: 1px solid #ddd;
                vertical-align: middle; /* Aligns text vertically center */
            }

            th {
                background: #007bff;
                color: #fff;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            td {
                background: #fafafa;
                color: #333;
                line-height: 1.4;
            }

            /* Highlight row on hover */
            tr:hover td {
                background-color: #e3f2fd;
            }

            /* Recess Row Styling */
            .recess-row {
                background-color: #ffeb3b;
                font-weight: bold;
                color: #333;
            }

            /* Button Styles */
            .btn {
                padding: 8px 10px;
                font-size: 0.8rem;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                margin: 2px;
                transition: transform 0.2s, box-shadow 0.3s;
            }

            .btn-update {
                background-color: #4caf50;
                color: #fff;
            }

            .btn-delete {
                background-color: #f44336;
                color: #fff;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                animation: fadeIn 0.5s ease-in-out;
            }

            .modal-content {
                background-color: #fff;
                margin: 12% auto;
                padding: 20px;
                border-radius: 10px;
                width: 320px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
                text-align: center;
            }

            .modal button {
                margin-top: 10px;
                padding: 10px 25px;
                cursor: pointer;
                border-radius: 5px;
                font-size: 1rem;
            }

            .btn-close {
                background-color: #999;
                color: #fff;
            }

            .modal button:hover {
                opacity: 0.9;
            }
            
            /* Container for the Go Back Button */
.btn-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px; /* Space at the top */
}

/* Go Back Button Styling */
.btn-go-back {
    padding: 10px 20px;
    font-size: 1rem;
    background-color: #007bff;
    color: #fff;
    text-align: center;
    border-radius: 5px;
    text-decoration: none;
    cursor: pointer;
    transition: background-color 0.3s, transform 0.2s;
}

.btn-go-back:hover {
    background-color: #0056b3;
    transform: translateY(-2px);
}

.btn-go-back:active {
    transform: translateY(2px);
}


            /* Animations */
            @keyframes fadeIn {
                0% {
                    opacity: 0;
                    transform: translateY(20px);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Responsive adjustments for small screens */
            @media (max-width: 768px) {
                th, td {
                    padding: 6px;
                    font-size: 0.75rem;
                }
                .btn {
                    padding: 6px 8px;
                    font-size: 0.75rem;
                }
            }


        </style>
    </head>
    <body>
        <div class="container">
            <h3>Computer Engineering Timetable</h3>
            <table>
                <thead>
                    <tr>
                        <th>Time</th>
                        <th>Monday</th>
                        <th>Tuesday</th>
                        <th>Wednesday</th>
                        <th>Thursday</th>
                        <th>Friday</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        TimeTableDAO timetableDAO = new TimeTableDAO();
                        List<Timetable> timetableList = timetableDAO.getAllTimetables();
                        String[] days = {"MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"};
                        Map<Integer, String> timeSlots = new HashMap<>();
                        timeSlots.put(1, "09:00 - 09:55");
                        timeSlots.put(2, "10:00 - 10:55");
                        timeSlots.put(3, "11:00 - 11:55");
                        timeSlots.put(4, "12:00 - 12:55");
                        timeSlots.put(5, "Recess");
                        timeSlots.put(6, "02:00 - 02:55");
                        timeSlots.put(7, "03:00 - 03:55");
                        timeSlots.put(8, "04:00 - 04:55");

                        for (int period = 1; period <= 8; period++) {
                            if (period == 5) {
                    %>
                    <tr class="recess-row">
                        <td colspan="6">Recess</td>
                    </tr>
                    <%
                            continue;
                        }
                    %>
                    <tr>
                        <td><%= timeSlots.get(period)%></td>
                        <%
                            for (String day : days) {
                                boolean found = false;
                                for (Timetable entry : timetableList) {
                                    if (entry.getDayOfWeek().equalsIgnoreCase(day)
                                            && Integer.parseInt(entry.getPeriod()) == period) {
                                        found = true;
                        %>
                        <td>
                            <strong><%= entry.getSubjectName()%></strong><br>
                            <span>Faculty: <%= entry.getFacultyName()%></span><br>
                            <span>Room: <%= entry.getClassroomId()%></span><br>
                            <button class="btn btn-update"
                                    onclick="location.href = 'updateTimeTable.jsp?id=<%= entry.getId()%>'">Update</button>
                            <button class="btn btn-delete"
                                    onclick="openDeleteModal(<%= entry.getId()%>)">Delete</button>
                        </td>
                        <%
                                    break;
                                }
                            }
                            if (!found) {
                        %>
                        <td>-</td>
                        <%
                                }
                            }
                        %>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
                  <!-- Go Back Button -->
<div class="btn-container">
    <a href="dashboard.jsp" class="btn-go-back">Go Back</a>
</div>


        <!-- Delete Confirmation Modal -->
        <div id="deleteModal" class="modal">
            <div class="modal-content">
                <p>Are you sure you want to delete this entry?</p>
                <button onclick="deleteTimetable()">Yes, Delete</button>
                <button class="btn-close" onclick="closeDeleteModal()">Cancel</button>
            </div>
        </div>

        <script>
            let deleteId = null;

            function openDeleteModal(id) {
                deleteId = id;
                document.getElementById("deleteModal").style.display = "block";
            }

            function closeDeleteModal() {
                document.getElementById("deleteModal").style.display = "none";
            }

            function deleteTimetable() {
                if (deleteId) {
                    window.location.href = "${pageContext.request.contextPath}/DeleteTimetableServlet?id=" + deleteId;
                }
            }
        </script>
    </body>
</html>
