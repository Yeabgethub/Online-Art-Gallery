<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.ServletException" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Artist Profile - Online Art Gallery</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .form-container {
            margin-top: 20px;
        }

        .error-message {
            color: red;
            text-align: center;
        }

        .profile-image {
            width: 150px;
            height: 150px;
            object-fit: cover;
        }
    </style>
</head>

<body>
    <header class="bg-dark text-white text-center py-3">
        <h1>Edit Artist Profile</h1>
    </header>

    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="index.html">Home</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="artistfrontpageone.jsp">Back</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container form-container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <%
                String email = (String) session.getAttribute("artistEmail");
                String message = "";
                String errorMessage = "";

                if (email == null) {
                    out.println("<div class='alert alert-danger'>Please log in to edit your profile.</div>");
                } else {
                    String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
                    String DB_USER = "root";
                    String DB_PASSWORD = "1234";
                    String DRIVER = "com.mysql.cj.jdbc.Driver";

                    try {
                        Class.forName(DRIVER);
                        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM artists WHERE email = ?")) {

                            pstmt.setString(1, email);
                            try (ResultSet rs = pstmt.executeQuery()) {
                                if (rs.next()) {
                                    String firstName = rs.getString("first_name");
                                    String lastName = rs.getString("last_name");
                                    String address = rs.getString("address");
                                    String mobileNo = rs.getString("mobile_no");
                                    byte[] imageData = rs.getBytes("profile_image");
                                    String base64Image = null;

                                    if (imageData != null && imageData.length > 0) {
                                        base64Image = Base64.getEncoder().encodeToString(imageData);
                                    }

                %>
                                    <h3>Current Profile Information</h3>
                                    <div class="card mb-3">
                                        <img src="data:image/jpeg;base64,<%= base64Image != null ? base64Image : "" %>" class="card-img-top rounded-circle profile-image" alt="Profile Image">
                                        <div class="card-body">
                                            <h5 class="card-title"><%= firstName + " " + lastName %></h5>
                                            <p class="card-text">Email: <%= email %></p>
                                            <p class="card-text">Address: <%= address %></p>
                                            <p class="card-text">Mobile No: <%= mobileNo %></p>
                                        </div>
                                    </div>

                                    <%
                                    // Check if the form has been submitted
                                    if (request.getMethod().equalsIgnoreCase("POST")) {
                                        String newFirstName = request.getParameter("first_name");
                                        String newLastName = request.getParameter("last_name");
                                        String newAddress = request.getParameter("address");
                                        String newMobileNo = request.getParameter("mobile_no");
                                        
                                        Part filePart = request.getPart("profile_image");
                                        String fileName = (filePart != null && filePart.getSize() > 0) ? filePart.getSubmittedFileName() : null;

                                        // Validation
                                        if (newFirstName.isEmpty() || newLastName.isEmpty() || newAddress.isEmpty() || newMobileNo.isEmpty()) {
                                            errorMessage = "All fields are required.";
                                        } else {
                                            try (PreparedStatement updateStmt = conn.prepareStatement("UPDATE artists SET first_name = ?, last_name = ?, address = ?, mobile_no = ?, profile_image = ? WHERE email = ?")) {
                                                updateStmt.setString(1, newFirstName);
                                                updateStmt.setString(2, newLastName);
                                                updateStmt.setString(3, newAddress);
                                                updateStmt.setString(4, newMobileNo);
                                                
                                                // Handle file upload
                                                if (fileName != null && !fileName.isEmpty()) {
                                                    InputStream fileContent = filePart.getInputStream();
                                                    updateStmt.setBlob(5, fileContent);
                                                } else {
                                                    updateStmt.setBytes(5, imageData); // Keep existing image if no new image is uploaded
                                                }
                                                updateStmt.setString(6, email);
                                                int rowsUpdated = updateStmt.executeUpdate();
                                                if (rowsUpdated > 0) {
                                                    message = "Profile updated successfully!";
                                                } else {
                                                    errorMessage = "Profile update failed.";
                                                }
                                            }
                                        }
                                    }
                %>
                <form method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="first_name">First Name</label>
                        <input type="text" class="form-control" id="first_name" name="first_name" value="<%= firstName %>" required>
                    </div>
                    <div class="form-group">
                        <label for="last_name">Last Name</label>
                        <input type="text" class="form-control" id="last_name" name="last_name" value="<%= lastName %>" required>
                    </div>
                    <div class="form-group">
                        <label for="address">Address</label>
                        <input type="text" class="form-control" id="address" name="address" value="<%= address %>" required>
                    </div>
                    <div class="form-group">
                        <label for="mobile_no">Mobile No</label>
                        <input type="text" class="form-control" id="mobile_no" name="mobile_no" value="<%= mobileNo %>" required>
                    </div>
                    <div class="form-group">
                        <label for="profile_image">Profile Image</label>
                        <input type="file" class="form-control-file" id="profile_image" name="profile_image">
                    </div>
                    <button type="submit" class="btn btn-primary">Update Profile</button>
                </form>
                <%
                                } else {
                                    out.println("<div class='alert alert-warning'>No artist found with the provided email.</div>");
                                }
                            }
                        } catch (SQLException e) {
                            out.println("<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>");
                        } catch (IOException e) {
                            out.println("<div class='alert alert-danger'>Error processing the request: " + e.getMessage() + "</div>");
                        }
                    } catch (ClassNotFoundException e) {
                        out.println("<div class='alert alert-danger'>Driver not found: " + e.getMessage() + "</div>");
                    }
                }
                %>
                <div class="alert alert-danger"><%= errorMessage %></div>
                <div class="alert alert-success"><%= message %></div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-4">
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: <a href="mailto:info@artgallery.com" style="color: #f2f2f2;">info@artgallery.com</a></p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>