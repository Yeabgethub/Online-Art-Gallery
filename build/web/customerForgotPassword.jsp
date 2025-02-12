<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: #f0f2f5;
        }
        .form {
            background: white;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
        }
        h1 {
            text-align: center;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin: 10px 0 5px;
        }
        input[type="email"], input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .button {
            background: #1ab188;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-weight: bold;
        }
        .button:hover {
            background: #179b77;
        }
    </style>
</head>
<body>
    <div class="form">
        <h1>Reset Password</h1>
        <form action="CustomerForgotPasswordServlet" method="post">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required />
            <label for="mobileno">Mobile Number:</label>
            <input type="text" id="mobileno" name="mobileno" required />
            <label for="newPassword">New Password:</label>
            <input type="password" id="newPassword" name="newPassword" required />
            <label for="confirmPassword">Confirm Password:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required />
            <button type="submit" class="button">Reset Password</button>
        </form>
        <div id="message">
            <% 
                String message = request.getParameter("message");
                if (message != null && !message.isEmpty()) { 
            %>
                <p style="color:red;"><%= message %></p>
            <% } %>
        </div>
    </div>
</body>
</html>