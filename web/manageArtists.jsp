<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Artists - Online Art Gallery</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f0f2f5;
        }
        .header {
            background-color: #343a40;
            color: white;
            padding: 20px 0;
        }
        .form-container {
            margin-top: 20px;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .form-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }
        .table {
            margin-top: 20px;
        }
        .table th {
            background-color: #007bff;
            color: white;
        }
        .table tbody tr {
            transition: background-color 0.3s ease;
        }
        .table tbody tr:hover {
            background-color: #f1f1f1;
        }
        .btn {
            margin-right: 5px;
        }
        footer {
            background-color: #343a40;
            color: white;
            padding: 15px 0;
            margin-top: 20px;
        }
    </style>
</head>

<body>
    <header class="header text-center">
        <h1>Manage Artists</h1>
    </header>

    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="adminDashboard.jsp">Dashboard</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="logoutAdmin.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container form-container">
        <h2 class="text-center">Existing Artists</h2>
        
        <table class="table table-striped table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th>Mobile No</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
                    String DB_USER = "root";
                    String DB_PASSWORD = "1234";
                    String DRIVER = "com.mysql.cj.jdbc.Driver";

                    try {
                        Class.forName(DRIVER);
                        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM artists");
                             ResultSet rs = pstmt.executeQuery()) {

                            while (rs.next()) {
                                int artistId = rs.getInt("id");
                                String artistName = rs.getString("first_name") + " " + rs.getString("last_name");
                                String email = rs.getString("email");
                                String address = rs.getString("address");
                                String mobileNo = rs.getString("mobile_no");
                %>
                                <tr>
                                    <td><%= artistId %></td>
                                    <td><%= artistName %></td>
                                    <td><%= email %></td>
                                    <td><%= address %></td>
                                    <td><%= mobileNo %></td>
                                    <td>
                                        <a href="DeleteArtistServlet?id=<%= artistId %>" class="btn btn-danger btn-sm">Delete</a>
                                    </td>
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

    <footer class="text-center">
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>