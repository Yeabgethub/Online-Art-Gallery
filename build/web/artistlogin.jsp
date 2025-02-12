<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check if the artist is already logged in
    HttpSession currentSession = request.getSession(false); // Avoid naming conflict
    if (currentSession != null && currentSession.getAttribute("artistId") != null) {
        response.sendRedirect("artistfrontpageone.jsp"); // Redirect to the artist's front page if already logged in
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Artist Login</title>
    <link href="https://fonts.googleapis.com/css?family=Titillium+Web:400,300,600" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel="stylesheet" href="css/login.css">
    <style>
        /* General Reset and Box Model */
        *, *:before, *:after {
            box-sizing: border-box;
        }

        /* Background and Body Styling */
        body {
            background: url('https://d1inegp6v2yuxm.cloudfront.net/royal-academy/image/upload/c_limit,f_auto,w_1200/a8q37oxuq73vuqfynxux.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Titillium Web', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        /* Heading Styling */
        h2 {
            font-family: 'Times', sans-serif;
            text-align: center;
            font-size: 50px;
            color: white;
        }

        h1 {
            text-align: center;
            color: white;
            font-weight: 300;
            margin: 0 0 40px;
            font-size: 1.5rem;
        }

        /* Form Styling */
        .form {
            background: rgba(19, 35, 47, 0.9);
            padding: 60px;
            max-width: 500px;
            width: 100%;
            border-radius: 4px;
            box-shadow: 0 4px 10px rgba(19, 35, 47, 0.3);
        }

        /* Labels */
        label {
            display: block;
            font-size: 0.9rem;
            margin-bottom: 5px;
            color: rgba(255, 255, 255, 0.8);
        }

        label .req {
            color: #1ab188;
        }

        /* Inputs */
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            background: none;
            border: 1px solid rgba(160, 179, 176, 0.5);
            color: white;
            margin-bottom: 20px;
            border-radius: 4px;
            transition: border-color 0.25s ease;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #1ab188;
            outline: none;
        }

        /* Error Messages */
        #emailError, #passwordError {
            color: red;
            font-size: 0.85rem;
            margin-top: -15px;
            margin-bottom: 10px;
        }

        #error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }

        /* Buttons */
        .button {
            display: block;
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            font-weight: bold;
            text-transform: uppercase;
            text-align: center;
            border: none;
            border-radius: 4px;
            background: #1ab188;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background: #179b77;
        }

        /* Forgot Password Link */
        .forgot-password {
            text-align: center;
            margin-top: 10px;
        }

        .forgot-password a {
            color: white;
            text-decoration: none;
        }

    </style>
    <script>
        function validateLoginForm() {
            const email = document.forms["loginForm"]["email"].value.trim();
            const password = document.forms["loginForm"]["password"].value.trim();
            let isValid = true;

            // Reset error messages
            document.getElementById("emailError").innerText = "";
            document.getElementById("passwordError").innerText = "";

            // Validate email format
            const emailError = document.getElementById("emailError");
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Simple email regex
            if (!email) {
                emailError.innerText = "Email is required.";
                isValid = false;
            } else if (!emailRegex.test(email)) {
                emailError.innerText = "Please enter a valid email address.";
                isValid = false;
            }

            // Validate password strength (example: at least 6 characters)
            const passwordError = document.getElementById("passwordError");
            if (!password) {
                passwordError.innerText = "Password is required.";
                isValid = false;
            } else if (password.length < 6) {
                passwordError.innerText = "Password must be at least 6 characters long.";
                isValid = false;
            }

            return isValid;
        }
    </script>
</head>
<body>
    <h2>Online Art Gallery</h2>
    <div class="form">
        <div id="login">
            <h1>Artist Login</h1>
            <div id="error-message" style="color: red; display: none; margin-top: 15px;"></div>

            <% 
                // Display error messages passed from the servlet
                String errorMessage = request.getParameter("error");
                if (errorMessage != null && !errorMessage.isEmpty()) { 
            %>
                <div style="color: red; margin-top: 15px;">
                    <%= errorMessage %>
                </div>
            <% } %>

            <form id="loginForm" name="loginForm" action="ArtistLoginServlet" method="post" onsubmit="return validateLoginForm()">
                <div class="field-wrap">
                    <label>Email<span class="req">*</span></label>
                    <input type="text" name="email" required autocomplete="off" />
                    <div id="emailError" style="color: red;"></div>
                </div>
                <div class="field-wrap">
                    <label>Password<span class="req">*</span></label>
                    <input type="password" name="password" required autocomplete="off" />
                    <div id="passwordError" style="color: red;"></div>
                </div>
                <button type="submit" class="button">Log In</button>
            </form>

            <!-- Forgot Password Link -->
            <div class="forgot-password">
                <a href="forgotPassword.jsp" class="button">Forgot Password?</a>
            </div>
        </div>
    </div>
</body>
</html>