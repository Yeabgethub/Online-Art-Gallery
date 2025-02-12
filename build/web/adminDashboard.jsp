<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Online Art Gallery</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            margin-top: 20px;
        }
    </style>
</head>

<body>
    <header class="bg-dark text-white text-center py-3">
        <h1>Admin Dashboard</h1>
    </header>

    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="index.html">Home</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="LogoutAdminServlet">Logout</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container form-container">
        <h2>Manage Your Gallery</h2>
        <div class="list-group">
            <a href="manageArtists.jsp" class="list-group-item list-group-item-action">Manage Artists</a>
            <a href="manageCustomers.jsp" class="list-group-item list-group-item-action">Manage Customers</a>
            <a href="manageArtworks.jsp" class="list-group-item list-group-item-action">Manage Artworks</a>
            <a href="manageHighRatings.jsp" class="list-group-item list-group-item-action">High Ratings</a>
            <a href="commentsManage.jsp" class="list-group-item list-group-item-action">Manage Comments</a>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-4">
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>