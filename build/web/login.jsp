<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Login</title>
    <link href='https://fonts.googleapis.com/css?family=Titillium+Web:400,300,600' rel='stylesheet'>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script>
        function validateLoginForm() {
            const email = document.forms["loginForm"]["email"].value;
            const password = document.forms["loginForm"]["password"].value;

            let isValid = true;

            // Validate email
            if (!email) {
                document.getElementById("emailError").innerText = "Email is required.";
                isValid = false;
            } else {
                document.getElementById("emailError").innerText = "";
            }

            // Validate password
            if (!password) {
                document.getElementById("passwordError").innerText = "Password is required.";
                isValid = false;
            } else {
                document.getElementById("passwordError").innerText = "";
            }

            return isValid;
        }
    </script>
</head>
<body>
    <h2>Online Art Gallery</h2>
    <div class="form">
        <div id="login">
            <h1>Login</h1>

            <div id="error-message" style="color: red; display: <% if (request.getAttribute("errorMessage") != null) { %>block<% } else { %>none<% } %>;">
                <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
            </div>

            <div id="success-message" style="color: green; display: <% if (request.getAttribute("message") != null) { %>block<% } else { %>none<% } %>;">
                <%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>
            </div>

            <form id="loginForm" name="loginForm" action="LoginServlet" method="post" onsubmit="return validateLoginForm()">
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
        </div>
    </div>
</body>
</html>