<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Online Art Gallery, <%= session.getAttribute("customerFirstName") %></title>
    <link rel="stylesheet" href="css/customerfrontpage.css"> <!-- External CSS -->
    <script src="js/customerfrontpage.js"></script>
    <style>
    body {
         background-image: url('images/orange.jpg');
    }
    
    
</style>
</head>


<body>
    
    <h4 id="greetingMessage"> <%= session.getAttribute("customerFirstName") %> <%= session.getAttribute("customerLastName") %></h4>

    <div class="navbar">
        <a href="index.html">Home</a>
             <a href="highrating artwork.jsp">High ratings artwork</a>
        <a href="LogoutCustomerServlet">Logout</a>
        <a href="About_us.jsp">About Us</a>
    </div>

    <div class="search-container">
        <form action="searched.jsp" method="post">
            <input type="text" name="search" id="searchInput" placeholder="Search by title or artist..." required autocomplete="off">
            <div id="suggestions" class="suggestions-dropdown"></div>
            <button type="submit">Search</button>
        </form>
    </div>
   
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

            String sql = "SELECT title, artist_name, mobile_no, email, social_media, description, image, image2, image3, id, `condition`, for_sale, price, video_link, category FROM artworks";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String title = rs.getString("title");
                String artistName = rs.getString("artist_name");
                String mobileNo = rs.getString("mobile_no");
                String email = rs.getString("email");
                String socialMedia = rs.getString("social_media");
                String description = rs.getString("description");
                
                // Fetching image bytes
                byte[] imageBytes = rs.getBytes("image");
                byte[] image2Bytes = rs.getBytes("image2");
                byte[] image3Bytes = rs.getBytes("image3");
                
                int artworkDbId = rs.getInt("id");
                String condition = rs.getString("condition");
                String forSale = rs.getString("for_sale");
                double price = rs.getDouble("price");
                String videoLink = rs.getString("video_link");
                String category = rs.getString("category");

                // Base64 encoding for images
                String imageBase64 = (imageBytes != null && imageBytes.length > 0) ? "data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(imageBytes) : null;
                String image2Base64 = (image2Bytes != null && image2Bytes.length > 0) ? "data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(image2Bytes) : null;
                String image3Base64 = (image3Bytes != null && image3Bytes.length > 0) ? "data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(image3Bytes) : null;
        %>
        <div class="artwork" data-artwork-id="<%= artworkDbId %>">
            <div class="slider">
                <% if (imageBase64 != null) { %>
                    <img src="<%= imageBase64 %>" alt="<%= title %>" onclick="openModal('<%= imageBase64 %>')">
                <% } %>
                <% if (image2Base64 != null) { %>
                    <img src="<%= image2Base64 %>" alt="<%= title %> - Image 2" onclick="openModal('<%= image2Base64 %>')">
                <% } %>
                <% if (image3Base64 != null) { %>
                    <img src="<%= image3Base64 %>" alt="<%= title %> - Image 3" onclick="openModal('<%= image3Base64 %>')">
                <% } %>
            </div>
            
            <div class="artwork-description" id="description_<%= artworkDbId %>" style="display: none;">
                <p>Artist: <%= artistName %></p>
                <p>Title: <%= title %></p>
                <p>Description: <%= description %></p>
                <p>Condition: <%= condition %></p>
                <p>For Sale: <%= forSale %></p>
                <p>Price: $<%= price %></p>
                <p>Category: <%= category %></p>
                <p>Contact Email: <%= email %></p>
                <p>Mobile No: <%= mobileNo %></p>
                <p>Social Media: <%= socialMedia %></p>
                <% if (videoLink != null && !videoLink.isEmpty()) { %>
                    <p>Video Link: <a href="<%= videoLink %>" target="_blank">Watch Video</a></p>
                <% } %>
            </div>
            <button onclick="toggleDescription('<%= artworkDbId %>')">Show Description</button>
            <div class="rating-section">
                <h4>Rate this Artwork:</h4>
                <span class="stars" id="stars_<%= artworkDbId %>">
                    <span class="star" data-value="1" onclick="submitRating(<%= artworkDbId %>, 1)" onmouseover="highlightStars(<%= artworkDbId %>, 1)" onmouseout="resetStars(<%= artworkDbId %>)">★</span>
                    <span class="star" data-value="2" onclick="submitRating(<%= artworkDbId %>, 2)" onmouseover="highlightStars(<%= artworkDbId %>, 2)" onmouseout="resetStars(<%= artworkDbId %>)">★</span>
                    <span class="star" data-value="3" onclick="submitRating(<%= artworkDbId %>, 3)" onmouseover="highlightStars(<%= artworkDbId %>, 3)" onmouseout="resetStars(<%= artworkDbId %>)">★</span>
                    <span class="star" data-value="4" onclick="submitRating(<%= artworkDbId %>, 4)" onmouseover="highlightStars(<%= artworkDbId %>, 4)" onmouseout="resetStars(<%= artworkDbId %>)">★</span>
                    <span class="star" data-value="5" onclick="submitRating(<%= artworkDbId %>, 5)" onmouseover="highlightStars(<%= artworkDbId %>, 5)" onmouseout="resetStars(<%= artworkDbId %>)">★</span>
                </span>
                <div id="ratingResult_<%= artworkDbId %>" class="rating-notification"></div> <!-- Notification below stars -->
                <div id="currentRating_<%= artworkDbId %>" class="current-rating"></div> <!-- Display current rating -->
            </div>
            <div class="comment-section">
                <input type="text" id="commentInput_<%= artworkDbId %>" placeholder="Add a comment..." />
                <button onclick="submitComment('<%= artworkDbId %>')">Submit Comment</button>
            </div>
            <div class="comments" id="comments_<%= artworkDbId %>">
                <p>Loading comments...</p>
            </div>

            <!-- Social Sharing Section -->
            <div class="share-section">
                <h4>Share this Artwork:</h4>
                <button onclick="shareOnTwitter('<%= title.replace("'", "\\'") %>')" style="border: none; background: none; cursor: pointer;">
                    <img src="images/icons8-twitter-50.png" alt="Share on Twitter" style="width: 24px; height: 24px;" title="Share on Twitter">
                </button>
                <button onclick="shareOnFacebook('<%= title.replace("'", "\\'") %>')" style="border: none; background: none; cursor: pointer;">
                    <img src="images/icons8-facebook-50.png" alt="Share on Facebook" style="width: 24px; height: 24px;" title="Share on Facebook">
                </button>
                <button onclick="shareOnInstagram('<%= title.replace("'", "\\'") %>')" style="border: none; background: none; cursor: pointer;">
                    <img src="images/icons8-instagram-48.png" alt="Share on Instagram" style="width: 24px; height: 24px;" title="Share on Instagram">
                </button>
            </div>

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

    <!-- Modal for displaying larger image -->
    <div id="imageModal" class="modal">
        <span class="close" onclick="closeModal()">&times;</span>
        <img class="modal-content" id="modalImage">
        <div id="caption"></div>
    </div>

    <footer>
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: info@artgallery.com</p>
    </footer>

    <script>
        function openModal(src) {
            document.getElementById("modalImage").src = src;
            document.getElementById("imageModal").style.display = "block";
        }

        function closeModal() {
            document.getElementById("imageModal").style.display = "none";
        }

        // Show the greeting message for a few seconds and then hide it
        window.onload = function() {
            const greetingMessage = document.getElementById("greetingMessage");
            setTimeout(() => {
                greetingMessage.style.display = "none";
            }, 5000); // Change 5000 to the desired time in milliseconds (5000 = 5 seconds)
        };
    </script>
</body>
</html>