<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.List, java.util.ArrayList" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit My Works - Online Art Gallery</title>
    <link rel="stylesheet" href="css/uploadworks.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .artwork-image {
            width: 60%; /* Set a fixed width */
            height: 500px; /* Set a fixed height */
            border-radius: 5px; /* Optional: add some rounding */
        }
    </style>
    <script>
        function togglePriceInput() {
            const forSaleField = document.getElementById('newForSale');
            const priceField = document.getElementById('newPrice');

            if (forSaleField.value === "yes") {
                priceField.removeAttribute('disabled'); // Enable the price input
                priceField.setAttribute('required', 'required'); // Make it required
            } else {
                priceField.value = ''; // Clear the price field
                priceField.setAttribute('disabled', 'disabled'); // Disable the price input
                priceField.removeAttribute('required'); // Remove required attribute
            }
        }

        window.onload = function() {
            togglePriceInput(); // Initialize the price input state on page load

            // Automatically hide success message after 5 seconds
            const messageDiv = document.getElementById("successMessage");
            if (messageDiv) {
                setTimeout(() => {
                    messageDiv.style.display = 'none';
                }, 5000); // 5000 milliseconds = 5 seconds
            }
        };
    </script>
</head>
<body>
    <nav class="navbar">
       <a href="index.html">Home</a>
        <a href="customerfrontpage.jsp">Paintings</a>
        <a href="About_us.jsp">About Us</a>
        <a href="editartistprofile.jsp">My Profile</a>
        <a href="editworks.jsp">My Works</a>
        <a href="uploadworks.jsp">Upload Paintings</a>
        <a href="LogoutServlet">Logout</a>
    </nav>

    <header>
        <h1>Edit My Works</h1>
    </header>

    <main class="container">
        <section class="existing-artworks">
            <h2>Your Artworks</h2>
            <% 
            // Display notification messages
            String message = (String) session.getAttribute("message");
            String messageType = (String) session.getAttribute("messageType");
            if (message != null) {
            %>
                <div id="successMessage" class="alert alert-<%= messageType.equals("success") ? "success" : "danger" %>">
                    <%= message %>
                </div>
            <%
                // Clear the message after displaying it
                session.removeAttribute("message");
                session.removeAttribute("messageType");
            }
            %>

            <%
            // Retrieve the artist's email from the session
            String artistEmail = (String) session.getAttribute("artistEmail");
            List<List<Object>> artworks = new ArrayList<>();
            String errorMessage = null;

            // Fetch artworks from the database
            if (artistEmail != null) {
                try {
                    String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
                    String DB_USER = "root";
                    String DB_PASSWORD = "1234";
                    String DRIVER = "com.mysql.cj.jdbc.Driver";

                    Class.forName(DRIVER);
                    try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                         PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM artworks WHERE email = ?")) {

                        pstmt.setString(1, artistEmail);
                        ResultSet rs = pstmt.executeQuery();

                        while (rs.next()) {
                            List<Object> artwork = new ArrayList<>();
                            artwork.add(rs.getInt("id")); // id
                            artwork.add(rs.getString("title")); // title
                            artwork.add(rs.getString("description")); // description
                            artwork.add(rs.getBytes("image")); // image
                            artwork.add(rs.getString("for_sale")); // for_sale
                            artwork.add(rs.getBigDecimal("price")); // price
                            artwork.add(rs.getString("social_media")); // social_media
                            artwork.add(rs.getDate("date_created")); // date_created
                            artwork.add(rs.getString("condition")); // condition
                            artwork.add(rs.getString("category")); // category
                            artworks.add(artwork);
                        }
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    errorMessage = "Error fetching artworks: " + e.getMessage();
                }
            } else {
                errorMessage = "You must be logged in to view your artworks.";
            }

            // Display error message if exists
            if (errorMessage != null) {
            %>
                <div class="alert alert-danger"><%= errorMessage %></div>
            <%
            }

            // Display artworks
            if (!artworks.isEmpty()) {
            %>
                <ul class="list-group">
                    <%
                    for (List<Object> artwork : artworks) {
                        Integer id = (Integer) artwork.get(0);
                        String title = (String) artwork.get(1);
                        String description = (String) artwork.get(2);
                        byte[] imageBytes = (byte[]) artwork.get(3);
                        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                        String forSale = (String) artwork.get(4);
                        BigDecimal price = (BigDecimal) artwork.get(5);
                        String socialMedia = (String) artwork.get(6);
                        java.sql.Date dateCreated = (java.sql.Date) artwork.get(7);
                        String condition = (String) artwork.get(8);
                        String category = (String) artwork.get(9);
                    %>
                    <li class="list-group-item">
                        <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= title %>" class="artwork-image">
                        <h5>Your previous upload details for this artwork:</h5>
                        <h5>Title: <%= title %></h5>
                        <p>Description: <%= description %></p>
                        <p>For Sale: <%= forSale %></p>
                        <p>Price: <%= price != null ? price.toString() : "N/A" %></p>
                        <p>Social Media: <%= socialMedia != null ? socialMedia : "N/A" %></p>
                        <p>Date Created: <%= dateCreated != null ? dateCreated.toString() : "N/A" %></p>
                        <h5>You can now edit it:</h5>
                        <form method="post" action="EditWorksServlet">
                            <input type="hidden" name="artworkId" value="<%= id %>">
                            <label for="newTitle"><h3>Title:</h3></label>
                            <input type="text" name="newTitle" placeholder="New Title" class="form-control" value="<%= title %>" required>
                            
                            <label for="newDescription"><h3>Description:</h3></label>
                            <textarea name="newDescription" placeholder="New Description" class="form-control" required><%= description %></textarea>
                           
                            <label for="newForSale"><h3>For Sale:</h3></label>
                            <select id="newForSale" name="newForSale" class="form-control" required onchange="togglePriceInput()">
                                <option value="yes" <%= forSale.equals("yes") ? "selected" : "" %>>Yes</option>
                                <option value="no" <%= forSale.equals("no") ? "selected" : "" %>>No</option>
                            </select>
                            
                            <label for="newPrice"><h3>Price:</h3></label>
                            <input type="number" id="newPrice" name="newPrice" placeholder="New Price" class="form-control" step="0.01" value="<%= forSale.equals("no") ? "" : (price != null ? price : 0) %>" required <%= forSale.equals("no") ? "disabled" : "" %>>
                            
                            <label for="newSocialMedia"><h3>Social Media:</h3></label>
                            <input type="text" name="newSocialMedia" placeholder="Your social media username" class="form-control" value="<%= socialMedia %>"><br/>
                            
                            <label for="newDateCreated"><h3>Date Created:</h3></label>
                            <input type="date" name="newDateCreated" class="form-control" value="<%= dateCreated != null ? dateCreated.toString() : "" %>" required><br/>
                            
                            <label for="newCondition"><h3>Condition:</h3></label>
                            <select name="newCondition" class="form-control" required>
                                <option value="new" <%= condition.equals("new") ? "selected" : "" %>>New</option>
                                <option value="used" <%= condition.equals("used") ? "selected" : "" %>>Used</option>
                                <option value="refurbished" <%= condition.equals("refurbished") ? "selected" : "" %>>Refurbished</option>
                            </select><br/>
                            
                            <label for="newCategory"><h3>Category:</h3></label>
                            <select name="newCategory" class="form-control" required>
                                <option value="painting" <%= category.equals("painting") ? "selected" : "" %>>Painting</option>
                                <option value="sculpture" <%= category.equals("sculpture") ? "selected" : "" %>>Sculpture</option>
                                <option value="digital" <%= category.equals("digital") ? "selected" : "" %>>Digital Art</option>
                                <option value="photography" <%= category.equals("photography") ? "selected" : "" %>>Photography</option>
                            </select><br/>

                            <button type="submit" class="btn btn-success">Update</button>
                        </form>
                    </li>
                    <%
                    }
                    %>
                </ul>
            <%
            } else {
            %>
                <li class="list-group-item">No artworks found.</li>
            <%
            }
            %>
        </section>
    </main>

    <footer>
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: <a href="mailto:info@artgallery.com" style="color: #f2f2f2;">info@artgallery.com</a></p>
    </footer>
</body>
</html>