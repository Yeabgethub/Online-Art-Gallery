<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>High Rated Artworks</title>
    <link rel="stylesheet" href="css/customerfrontpage.css"> <!-- External CSS -->
    <style>
        body {
            background-image: url('images/orange.jpg'); /* Golden to Orange gradient */
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }

        .notification {
            display: none;
            margin: 10px 0;
            padding: 10px;
            border-radius: 5px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
        }

        .artworks {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around; /* Space between artworks */
        }

        .artwork {
            background-color: white; /* Background for artwork */
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin: 10px;
            padding: 15px;
            width:500px; /* Fixed width for uniformity */
            height:auto;
            text-align: center; /* Center text */
        }

        .artwork img {
            width: 60%; /* Responsive width */
            height: 200px; /* Fixed height for uniformity */
           
            border-radius: 5px;
        }

        footer {
            margin-top: 20px;
            text-align: center;
        }
    </style>
    <script>
        function toggleDescription(id) {
            var description = document.getElementById('description_' + id);
            description.style.display = (description.style.display === "none") ? "block" : "none";
        }

        function showNotification(message, type) {
            var notification = document.getElementById('notification');
            notification.innerHTML = message;
            notification.className = 'notification ' + type;
            notification.style.display = 'block';

            // Hide notification after 5 seconds
            setTimeout(function() {
                notification.style.display = 'none';
            }, 5000);
        }

        window.onload = function() {
            showNotification('High rated artworks loaded successfully!', 'success');
        };
    </script>
</head>
<body>
    <div class="navbar">
        <a href="customerfrontpage.jsp">Home</a>
        <a href="LogoutCustomerServlet">Logout</a>
        <a href="About_us.jsp">About Us</a>
    </div>

    <h3>High Rated Artworks</h3>
    
    <div id="notification" class="notification"></div>

    <div class="artworks" id="artworkContainer">
        <%
        String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
        String DB_USER = "root"; 
        String DB_PASSWORD = "1234"; 
        String DRIVER = "com.mysql.cj.jdbc.Driver";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName(DRIVER);
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Query to retrieve artworks with average rating of 4.0 or higher
            String sql = "SELECT a.title, a.artist_name, a.mobile_no, a.email, a.social_media, a.description, a.image, a.id, a.condition, a.for_sale, a.price, a.video_link, a.category, " +
                         "AVG(r.rating) AS average_rating, COUNT(r.rating) AS rating_count, GROUP_CONCAT(c.first_name, ' ', c.last_name) AS rated_by " +
                         "FROM artworks a " +
                         "JOIN ratings r ON a.id = r.artwork_id " +
                         "JOIN customers c ON r.customer_id = c.id " +
                         "GROUP BY a.id " +
                         "HAVING AVG(r.rating) >= 4.0 " +
                         "ORDER BY average_rating DESC"; 

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String title = rs.getString("title");
                String artistName = rs.getString("artist_name");
                String mobileNo = rs.getString("mobile_no");
                String email = rs.getString("email");
                String socialMedia = rs.getString("social_media");
                String description = rs.getString("description");
                byte[] imageBytes = rs.getBytes("image");
                int artworkDbId = rs.getInt("id");
                String condition = rs.getString("condition");
                String forSale = rs.getString("for_sale");
                double price = rs.getDouble("price");
                String videoLink = rs.getString("video_link");
                String category = rs.getString("category");
                double averageRating = rs.getDouble("average_rating");
                int ratingCount = rs.getInt("rating_count");
                String ratedBy = rs.getString("rated_by");

                String imageBase64 = "data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(imageBytes);
        %>
        <div class="artwork" data-artwork-id="<%= artworkDbId %>">
            <img src="<%= imageBase64 %>" alt="<%= title %>">
            
            <div class="artwork-description" id="description_<%= artworkDbId %>" style="display: block;">
                <p><strong>Artist:</strong> <%= artistName %></p>
                <p><strong>Title:</strong> <%= title %></p>
                <p><strong>Description:</strong> <%= description %></p>
                <p><strong>Condition:</strong> <%= condition %></p>
                <p><strong>For Sale:</strong> <%= forSale %></p>
                <p><strong>Price:</strong> $<%= price %></p>
                <p><strong>Category:</strong> <%= category %></p>
                <p><strong>Contact Email:</strong> <%= email %></p>
                <p><strong>Mobile No:</strong> <%= mobileNo %></p>
                <p><strong>Social Media:</strong> <%= socialMedia %></p>
                <p><strong>Average Rating:</strong> <%= averageRating %> from <%= ratingCount %> customers</p>
                <p><strong>Rated By:</strong> <%= ratedBy != null ? ratedBy : "No ratings yet" %></p>
                <% if (videoLink != null && !videoLink.isEmpty()) { %>
                    <p><strong>Video Link:</strong> <a href="<%= videoLink %>" target="_blank">Watch Video</a></p>
                <% } %>
            </div>
            <button onclick="toggleDescription('<%= artworkDbId %>')">Show Description</button>
        </div>
        <%
            } // end of while loop
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>");
        } catch (ClassNotFoundException e) {
            out.println("<div class='alert alert-danger'>Driver not found: " + e.getMessage() + "</div>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.println("<div class='alert alert-danger'>Error closing resources: " + e.getMessage() + "</div>");
            }
        }
        %>
    </div>

    <footer>
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: info@artgallery.com</p>
    </footer>
</body>
</html>