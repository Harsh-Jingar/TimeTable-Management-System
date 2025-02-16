<%
     String username = (String) session.getAttribute("facultyName");
    if (username == null) {
        response.sendRedirect("/TimeTableManagement/login.jsp");
        return;
    }
    // Prevent the back button from accessing this page after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard</title>
    <style>
        /* Reset and basic styling */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            display: flex;
            height: 100vh;
            background: linear-gradient(135deg, #f0f2f5, #ffffff);
            color: #333;
            transition: background 0.5s ease;
        }

        /* Sidebar styling */
        .sidebar {
            width: 260px;
            height: 100vh;
            background: #0056b3;
            color: #fff;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 20px;
            position: fixed;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            transition: width 0.3s ease-in-out;
        }

        .sidebar h2 {
            font-size: 24px;
            margin-bottom: 30px;
            color: #ffffff;
        }

        .sidebar a {
            color: #ffffff;
            text-decoration: none;
            padding: 12px 20px;
            width: 100%;
            text-align: center;
            font-size: 18px;
            transition: all 0.3s ease;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        .sidebar a:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: scale(1.1);
        }

        /* Main content area */
        .main-content {
            flex-grow: 1;
            margin-left: 260px;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: margin-left 0.3s ease;
        }

        .header {
            width: 100%;
            max-width: 1200px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .welcome {
            font-size: 18px;
            color: #555;
        }

        .logout-btn {
            padding: 10px 20px;
            background-color: #e74c3c;
            color: #fff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background-color: #c0392b;
            transform: scale(1.05);
        }

        /* Dashboard content styling */
        .dashboard-cards {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            width: 100%;
            max-width: 1200px;
            transition: transform 0.3s ease-in-out;
        }

        .card {
            flex: 1;
            min-width: 280px;
            max-width: 350px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s ease-in-out;
            color: #333;
            text-decoration: none;
            transform: translateY(0);
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 25px rgba(0, 0, 0, 0.2);
            background-color: rgba(255, 255, 255, 0.85);
        }

        .card h3 {
            font-size: 22px;
            margin-bottom: 10px;
        }

        .card p {
            font-size: 16px;
            color: #666;
        }

        /* Responsive styling */
        @media (max-width: 768px) {
            .sidebar {
                width: 200px;
            }
            .main-content {
                margin-left: 200px;
                padding: 20px;
            }
            .card {
                min-width: 220px;
            }
        }

        @media (max-width: 480px) {
            .sidebar {
                width: 180px;
            }
            .main-content {
                margin-left: 180px;
            }
            .card {
                min-width: 200px;
                padding: 15px;
            }
        }
    </style>
</head>
<body>

    <!-- Sidebar Navigation -->
    <div class="sidebar">
        <h2>Faculty Dashboard</h2>
        <a href="dashboard.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/timetable.jsp?from=faculty">View TimeTable</a>
        <a href="viewTimeTable.jsp">Lectures & Attendance</a>
        <a href="${pageContext.request.contextPath}/AdminServlet?action=logout">Logout</a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header Section -->
        <div class="header">
            <div class="welcome">
                Welcome, <b><%= session.getAttribute("facultyName")%></b>
            </div>
            <button class="logout-btn" onclick="window.location.href='${pageContext.request.contextPath}/AdminServlet?action=logout'">Logout</button>
        </div>

        <!-- Dashboard Cards Section -->
        <div class="dashboard-cards">
            <a href="${pageContext.request.contextPath}/timetable.jsp?from=faculty" class="card">
                <h3>View Timetable</h3>
                <p>View Complete TimeTable.</p>
            </a>

            <a href="viewTimeTable.jsp" class="card">
                <h3>Lectures & Attendance</h3>
                <p>View Your Today's Class and Mark Attendance.</p>
            </a>
        </div>
    </div>

</body>
</html>
