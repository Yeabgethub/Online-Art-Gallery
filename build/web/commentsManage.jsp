<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Comments - Online Art Gallery</title>
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
    <script>
        function filterComments() {
            const input = document.getElementById("commentFilter");
            const filter = input.value.toLowerCase();
            const table = document.getElementById("commentsTable");
            const tr = table.getElementsByTagName("tr");

            for (let i = 1; i < tr.length; i++) {
                const tdArtwork = tr[i].getElementsByTagName("td")[1]; // Artwork Title
                const tdCustomer = tr[i].getElementsByTagName("td")[2]; // Customer Name
                if (tdArtwork || tdCustomer) {
                    const textValueArtwork = tdArtwork.textContent || tdArtwork.innerText;
                    const textValueCustomer = tdCustomer.textContent || tdCustomer.innerText;
                    if (textValueArtwork.toLowerCase().indexOf(filter) > -1 || textValueCustomer.toLowerCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
</head>

<body>
    <header class="bg-dark text-white text-center py-3">
        <h1>Manage Comments</h1>
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
        <h2>Artwork Comments</h2>
        
        <!-- Filter Input -->
        <div class="mb-3">
            <input type="text" id="commentFilter" onkeyup="filterComments()" class="form-control" placeholder="Filter by Artwork Title or Customer Name">
        </div>

        <table class="table table-striped table-bordered" id="commentsTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Artwork Title</th>
                    <th>Customer Name</th>
                    <th>Comment</th>
                    <th>Date Created</th>
                    <th>Status</th>
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
                             PreparedStatement pstmt = conn.prepareStatement(
                                 "SELECT c.id, c.comment, c.created_at, a.title, cu.first_name, cu.last_name, c.is_moderated " +
                                 "FROM comments c " +
                                 "JOIN artworks a ON c.artwork_id = a.id " +
                                 "JOIN customers cu ON c.customer_id = cu.id " +
                                 "ORDER BY c.created_at DESC");
                             ResultSet rs = pstmt.executeQuery()) {

                            while (rs.next()) {
                                int commentId = rs.getInt("id");
                                String comment = rs.getString("comment");
                                String createdAt = rs.getString("created_at");
                                String artworkTitle = rs.getString("title");
                                String customerName = rs.getString("first_name") + " " + rs.getString("last_name");
                                boolean isModerated = rs.getBoolean("is_moderated");
                %>
                                <tr>
                                    <td><%= commentId %></td>
                                    <td><%= artworkTitle %></td>
                                    <td><%= customerName %></td>
                                    <td><%= comment %></td>
                                    <td><%= createdAt %></td>
                                    <td><%= isModerated ? "Moderated" : "Pending" %></td>
                                    <td>
                                        <a href="DeleteCommentServlet?id=<%= commentId %>" class="btn btn-danger btn-sm">Delete</a>
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

    <footer class="bg-dark text-white text-center py-3 mt-4">
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>