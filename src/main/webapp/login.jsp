<%
// Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - Timetable Management</title>
        <style>
            /* Styling remains the same as before */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Arial', sans-serif;
            }

            body {
                background-color: #f0f2f5;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                overflow: hidden;
            }

            .login-container {
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                width: 400px;
                padding: 40px;
                transform: scale(1);
                animation: scaleUp 0.5s ease-in-out;
            }

            @keyframes scaleUp {
                from {
                    transform: scale(0);
                }

                to {
                    transform: scale(1);
                }
            }

            h2 {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
            }

            .select-role {
                width: 100%;
                padding: 10px;
                font-size: 16px;
                margin-bottom: 20px;
                border: 1px solid #ddd;
                border-radius: 5px;
                background-color: #f8f9fa;
            }

            .select-role:hover {
                border-color: #0056b3;
            }

            .input-field {
                width: 100%;
                padding: 12px;
                margin: 10px 0;
                font-size: 16px;
                border: 1px solid #ddd;
                border-radius: 5px;
                transition: 0.3s;
            }

            .input-field:focus {
                outline: none;
                border-color: #0056b3;
            }

            .login-btn {
                width: 100%;
                padding: 12px;
                background-color: #0056b3;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 18px;
                cursor: pointer;
            }

            .login-btn:hover {
                background-color: #004085;
            }

            .remember-me {
                display: inline-block;
                margin: 10px 0;
            }

            .remember-me input {
                margin-right: 5px;
            }

            .error-message {
                color: red;
                text-align: center;
                margin-top: 10px;
            }

            .success-message {
                color: green;
                text-align: center;
                margin-top: 10px;
            }

            /* Initially hide faculty and student specific forms */
            #facultyForm,
            #studentForm {
                display: none;
            }


        </style>
    </head>

    <body>

        <div class="login-container">
            <h2>Login to Timetable Management</h2>

            <!-- Check if there is an error message from the servlet -->
            <div id="message">
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">${errorMessage}</div>
                </c:if>
            </div>

            <form id="roleSelectionForm">
                <select id="role" name="role" class="select-role" onchange="toggleForm()">
                    <option value="select" disabled selected>Select Role</option>
                    <option value="admin">Admin</option>
                    <option value="faculty">Faculty</option>
                    <option value="student">Student</option>
                </select>

            </form>

            <!-- Admin Login Form -->
            <form action="AdminServlet" method="post" id="adminForm">
                <input type="text" id="adminId" name="adminId" class="input-field" placeholder="Admin ID" required>
                <input type="password" id="adminPassword" name="adminPassword" class="input-field" placeholder="Password" required>

                <!-- Remember Me Checkbox for Admin -->
                <div class="remember-me">
                    <input type="checkbox" id="adminRemember" name="rememberMe">
                    <label for="adminRemember">Remember Me</label>
                </div>

                <button type="submit" class="login-btn">Login</button>
            </form>

            <!-- Faculty Login Form -->
            <form action="FacultyServlet" method="post" id="facultyForm">
                <input type="text" id="facultyId" name="facultyId" class="input-field" placeholder="Faculty ID" required>
                <input type="password" id="facultyPassword" name="facultyPassword" class="input-field" placeholder="Password" required>

                <!-- Remember Me Checkbox for Faculty -->
                <div class="remember-me">
                    <input type="checkbox" id="facultyRemember" name="rememberMe">
                    <label for="facultyRemember">Remember Me</label>
                </div>

                <button type="submit" class="login-btn">Login</button>
            </form>

            <!-- Student Login Form -->
            <form action="StudentServlet" method="post" id="studentForm">
                <input type="text" id="enrollment" name="enrollment" class="input-field" placeholder="Enrollment Number" required>
                <input type="password" id="studentPassword" name="studentPassword" class="input-field" placeholder="Password" required>

                <!-- Remember Me Checkbox for Student -->
                <div class="remember-me">
                    <input type="checkbox" id="studentRemember" name="rememberMe">
                    <label for="studentRemember">Remember Me</label>
                </div>

                <button type="submit" class="login-btn">Login</button>
            </form>

            <script>
                // Function to show/hide role-specific login forms
                function toggleForm() {
                    const role = document.getElementById("role").value;
                    const adminForm = document.getElementById("adminForm");
                    const facultyForm = document.getElementById("facultyForm");
                    const studentForm = document.getElementById("studentForm");

                    // Hide all forms initially
                    adminForm.style.display = "none";
                    facultyForm.style.display = "none";
                    studentForm.style.display = "none";

                    // Show the form based on the selected role
                    if (role === "admin") {
                        adminForm.style.display = "block";
                        // Check Remember Me for Admin
                        if (localStorage.getItem("adminId")) {
                            document.getElementById("adminId").value = localStorage.getItem("adminId");
                            document.getElementById("adminPassword").value = localStorage.getItem("adminPassword");
                            document.getElementById("adminRemember").checked = true;
                        }
                    } else if (role === "faculty") {
                        facultyForm.style.display = "block";
                        // Check Remember Me for Faculty
                        if (localStorage.getItem("facultyId")) {
                            document.getElementById("facultyId").value = localStorage.getItem("facultyId");
                            document.getElementById("facultyPassword").value = localStorage.getItem("facultyPassword");
                            document.getElementById("facultyRemember").checked = true;
                        }
                    } else if (role === "student") {
                        studentForm.style.display = "block";
                        // Check Remember Me for Student
                        if (localStorage.getItem("enrollment")) {
                            document.getElementById("enrollment").value = localStorage.getItem("enrollment");
                            document.getElementById("studentPassword").value = localStorage.getItem("studentPassword");
                            document.getElementById("studentRemember").checked = true;
                        }
                    }
                }

                // Save login details to localStorage if Remember Me is checked
                document.getElementById("adminForm").onsubmit = function () {
                    if (document.getElementById("adminRemember").checked) {
                        localStorage.setItem("adminId", document.getElementById("adminId").value);
                        localStorage.setItem("adminPassword", document.getElementById("adminPassword").value);
                    } else {
                        localStorage.removeItem("adminId");
                        localStorage.removeItem("adminPassword");
                    }
                };

                document.getElementById("facultyForm").onsubmit = function () {
                    if (document.getElementById("facultyRemember").checked) {
                        localStorage.setItem("facultyId", document.getElementById("facultyId").value);
                        localStorage.setItem("facultyPassword", document.getElementById("facultyPassword").value);
                    } else {
                        localStorage.removeItem("facultyId");
                        localStorage.removeItem("facultyPassword");
                    }
                };

                document.getElementById("studentForm").onsubmit = function () {
                    if (document.getElementById("studentRemember").checked) {
                        localStorage.setItem("enrollment", document.getElementById("enrollment").value);
                        localStorage.setItem("studentPassword", document.getElementById("studentPassword").value);
                    } else {
                        localStorage.removeItem("enrollment");
                        localStorage.removeItem("studentPassword");
                    }
                };


                // Trigger the toggleForm function on page load to restore visibility based on previous selection
                window.onload = function () {
                    toggleForm();

                };
            </script>

    </body>

</html>
