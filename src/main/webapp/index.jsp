<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome to ADIT Timetable & Attendance Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                background-color: #f0f4f8;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                color: #34495e;
                flex: 1;
            }

            header {
                background-color: #2980b9;
                padding: 20px;
                text-align: center;
                color: #ecf0f1;
                font-size: 28px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            header .icon {
                font-size: 40px;
                vertical-align: middle;
            }

            main {
                flex: 1;
                padding: 40px;
                text-align: center;
                background-color: #ffffff;
                margin: 40px auto;
                border-radius: 15px;
                max-width: 800px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
                transition: transform 0.3s;
            }

            main:hover {
                transform: scale(1.02);
            }

            main h1 {
                font-size: 42px;
                margin-bottom: 20px;
                color: #2980b9;
            }

            main p {
                font-size: 20px;
                line-height: 1.6;
                color: #34495e;
            }

            .form-container {
                margin-top: 30px;
                text-align: left;
            }

            .form-group {
                margin-bottom: 20px;
                position: relative;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: bold;
            }

            .form-group input, .form-group select {
                width: calc(100% - 40px); /* Adjusted width */
                padding: 8px 10px;
                font-size: 16px;
                border: 1px solid #ccc;
                border-radius: 5px;
                padding-right: 40px; /* Space for icon */
            }

            .form-group .icon {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                color: #2980b9;
                font-size: 18px;
            }

            .login-button {
                display: inline-block;
                margin-top: 20px;
                padding: 12px 25px;
                background-color: #2980b9;
                color: #ffffff;
                text-decoration: none;
                border-radius: 8px;
                font-size: 20px;
                border: none;
                cursor: pointer;
                transition: background-color 0.3s, transform 0.2s;
            }

            .login-button:hover {
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(26, 188, 156, 0.4);
            }

            footer {
                background-color: #2980b9;
                padding: 10px;
                text-align: center;
                color: #ecf0f1;
                box-shadow: 0 -4px 8px rgba(0, 0, 0, 0.1);
            }
        </style>
    </head>
    <body>
        <header>
            <i class="fas fa-school icon"></i>
            <h1>Welcome to ADIT Timetable & Attendance Management System</h1>
        </header>
        <main>
            <h1>About This System</h1>
            <p>
                This platform is designed to streamline the timetable and attendance management for students and faculty at ADIT.
                Faculty members can easily update timetables, manage class schedules, and mark attendance.
                Students can view their updated timetables and check their attendance status with ease.
            </p>
            <p>
                Log in below to access your dashboard and make the most of the features offered by this comprehensive system.
            </p>
            <div class="form-container">
                <form action="login.jsp" method="GET">
                    <button type="submit" class="login-button"><i class="fas fa-sign-in-alt"></i> Login</button>
                </form>
            </div>
        </main>
        <footer>
            &copy; 2024 A D Patel Institute of Technology. All rights reserved.
        </footer>
    </body>
</html>