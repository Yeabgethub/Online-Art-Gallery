<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Artist Profiles - Online Art Gallery</title>
    <link rel="shortcut icon" href="favicon.jpg"> <!-- Use a relative path -->
    <link rel="stylesheet" href="css/artistfrontpage.css"> <!-- Use a relative path -->
</head>
<body>
    <header>
        <h1>Welcome to Online Art Gallery</h1>
        <h2>Our Artists</h2>
    </header>

    <nav class="navbar">
        <a href="index.html">Home</a>
        <a href="About_us.jsp">About Us</a>
        <a href="editartistprofile.jsp">My Profile</a>
        <a href="editworks.jsp">My Works</a>
        <a href="uploadworks.jsp">Upload Paintings</a>
        <a href="LogoutServlet">Logout</a>
    </nav>

    <footer>
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: <a href="mailto:info@artgallery.com" style="color: #f2f2f2;">info@artgallery.com</a></p>
    </footer>
</body>
</html>