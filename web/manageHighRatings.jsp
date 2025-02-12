<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage High Ratings - Online Art Gallery</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            margin-top: 20px;
        }
        .table th, .table td {
            vertical-align: middle; /* Center align vertically */
        }
    </style>
</head>

<body>
    <header class="bg-dark text-white text-center py-3">
        <h1>Manage High Ratings</h1>
    </header>

    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="adminDashboard.jsp">Dashboard</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="logoutAdmin.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container form-container">
        <h2>Artworks with High Ratings</h2>
        <table class="table table-striped table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Artwork Title</th>
                    <th>Average Rating</th>
                    <th>Number of Ratings</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
                    String DB_USER = "root";
                    String DB_PASSWORD = "1234";
                    String DRIVER = "com.mysql.cj.jdbc.Driver";
                    double ratingThreshold = 4.0; // Set the rating threshold

                    try {
                        Class.forName(DRIVER);
                        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                             PreparedStatement pstmt = conn.prepareStatement(
                                 "SELECT a.id, a.title, AVG(r.rating) AS average_rating, COUNT(r.id) AS num_ratings " +
                                 "FROM artworks a " +
                                 "JOIN ratings r ON a.id = r.artwork_id " +
                                 "GROUP BY a.id " +
                                 "HAVING AVG(r.rating) > ?")) {
                            pstmt.setDouble(1, ratingThreshold);
                            ResultSet rs = pstmt.executeQuery();

                            while (rs.next()) {
                                int artworkId = rs.getInt("id");
                                String artworkTitle = rs.getString("title");
                                double averageRating = rs.getDouble("average_rating");
                                int numRatings = rs.getInt("num_ratings");
                %>
                                <tr>
                                    <td><%= artworkId %></td>
                                    <td><%= artworkTitle %></td>
                                    <td><%= String.format("%.2f", averageRating) %></td>
                                    <td><%= numRatings %></td>
                                </tr>
                <%
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>");
                    } catch (ClassNotFoundException e) {
                        out.println("<div class='alert alert-danger'>Driver not found: " + e.getMessage() + "</div>");
                    }
                %>
            </tbody>
        </table>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-4">
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>