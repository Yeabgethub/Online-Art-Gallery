<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Artist Profiles - Online Art Gallery</title>
    <link rel="stylesheet" href="css/artistfrontpage.css"> <!-- Use a relative path -->
</head>
<body>
    <header>
        <h1>Artist Profiles</h1>
    </header>

    <nav class="navbar">
        <a href="index.html">Home</a>
        <a href="customerfrontpage.jsp">Paintings</a>
        <a href="About_us.jsp">About Us</a>
        <a href="artistprofile.jsp">My Profile</a>
        <a href="editworks.jsp">My Works</a>
        <a href="uploadworks.jsp">Upload Works</a>
        <a href="LogoutServlet">Logout</a>
    </nav>

    <main>
        <h2>Our Artists</h2>
        <%
        List<Map<String, String>> artists = (List<Map<String, String>>) request.getAttribute("artists");
        if (artists != null && !artists.isEmpty()) {
            for (Map<String, String> artist : artists) {
        %>
                <div class="artist-profile">
                    <img src="<%= artist.get("profileImage") %>" alt="<%= artist.get("firstName") + " " + artist.get("lastName") %>" class="profile-img">
                    <h3><%= artist.get("firstName") + " " + artist.get("lastName") %></h3>
                    <p>Email: <%= artist.get("email") %></p>
                    <p>Address: <%= artist.get("address") %></p>
                    <p>Mobile No: <%= artist.get("mobileNo") %></p>
                </div>
        <%
            }
        } else {
        %>
            <p>No artists found.</p>
        <%
        }
        %>
    </main>

    <footer>
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: <a href="mailto:info@artgallery.com">info@artgallery.com</a></p>
    </footer>
</body>
</html>