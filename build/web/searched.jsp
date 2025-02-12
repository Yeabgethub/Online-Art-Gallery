<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results</title>
    <link rel="stylesheet" href="css/customerfrontpage.css"> <!-- External CSS -->

</head>
<body>
    <div class="navbar">
        <a href="LogoutCustomerServlet">Logout</a>
        <a href="About_us.jsp">About Us</a>
        <a href="customerfrontpage.jsp">Back</a>
    </div>

    <h3>Search Results for: <%= request.getParameter("search") %></h3>

    <%
        // Retrieve parameters
        String searchQuery = request.getParameter("search");
        String salesFilter = request.getParameter("sales");
        String conditionFilter = request.getParameter("condition");
        String categoryFilter = request.getParameter("category");
        String priceCondition = request.getParameter("priceCondition");
        String sortBy = request.getParameter("sortBy"); // Retrieve the sortBy parameter
    %>

    <div class="filters">
        <form action="searched.jsp" method="post">
            <label for="conditionFilter">Condition:</label>
            <select id="conditionFilter" name="condition">
                <option value="">Any</option>
                <option value="new" <%= "new".equals(conditionFilter) ? "selected" : "" %>>New</option>
                <option value="used" <%= "used".equals(conditionFilter) ? "selected" : "" %>>Used</option>
                <option value="refurbished" <%= "refurbished".equals(conditionFilter) ? "selected" : "" %>>Refurbished</option>
            </select>

            <label for="categoryFilter">Category:</label>
            <select id="categoryFilter" name="category">
                <option value="">Any</option>
                <option value="painting" <%= "painting".equals(categoryFilter) ? "selected" : "" %>>Painting</option>
                <option value="sculpture" <%= "sculpture".equals(categoryFilter) ? "selected" : "" %>>Sculpture</option>
                <option value="digital" <%= "digital".equals(categoryFilter) ? "selected" : "" %>>Digital</option>
                <option value="photography" <%= "photography".equals(categoryFilter) ? "selected" : "" %>>Photography</option>
            </select>

            <label for="salesFilter">For Sale:</label>
            <select id="salesFilter" name="sales">
                <option value="">Any</option>
                <option value="yes" <%= "yes".equals(salesFilter) ? "selected" : "" %>>Yes</option>
                <option value="no" <%= "no".equals(salesFilter) ? "selected" : "" %>>No</option>
            </select>

            <input type="hidden" name="search" value="<%= searchQuery %>">
            <button type="submit">Filter</button>
        </form>
    </div>

    <div class="artworks" id="artworkContainer">
        <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
            String DB_USER = "root"; 
            String DB_PASSWORD = "1234"; 
            String DRIVER = "com.mysql.cj.jdbc.Driver";

            Class.forName(DRIVER);
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Building SQL query
            StringBuilder sql = new StringBuilder("SELECT title, artist_name, image, id, `condition`, for_sale, price, description, mobile_no, email, social_media, video_link, category FROM artworks WHERE (title LIKE ? OR category LIKE ?)");

            // Add category filter if selected
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                sql.append(" AND category = ?");
            }

            // Add sales filter if selected
            if (salesFilter != null && !salesFilter.isEmpty()) {
                sql.append(" AND for_sale = ?");
            }

            // Add condition filter if selected
            if (conditionFilter != null && !conditionFilter.isEmpty()) {
                sql.append(" AND `condition` = ?");
            }

            // Add price condition filter
            if (priceCondition != null && !priceCondition.isEmpty()) {
                if (priceCondition.equals("low")) {
                    sql.append(" AND price < 100");
                } else if (priceCondition.equals("medium")) {
                    sql.append(" AND price BETWEEN 100 AND 500");
                } else if (priceCondition.equals("high")) {
                    sql.append(" AND price > 500");
                }
            }

            // Sorting logic
            if (sortBy != null && !sortBy.isEmpty()) {
                switch (sortBy) {
                    case "title_asc":
                        sql.append(" ORDER BY title ASC");
                        break;
                    case "title_desc":
                        sql.append(" ORDER BY title DESC");
                        break;
                    case "price_asc":
                        sql.append(" ORDER BY price ASC");
                        break;
                    case "price_desc":
                        sql.append(" ORDER BY price DESC");
                        break;
                }
            }

            pstmt = conn.prepareStatement(sql.toString());
            String searchParam = "%" + searchQuery + "%"; // For partial matches
            pstmt.setString(1, searchParam);
            pstmt.setString(2, searchParam);

            int index = 3; // Starting index for additional parameters
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                pstmt.setString(index++, categoryFilter);
            }
            if (salesFilter != null && !salesFilter.isEmpty()) {
                pstmt.setString(index++, salesFilter);
            }
            if (conditionFilter != null && !conditionFilter.isEmpty()) {
                pstmt.setString(index++, conditionFilter);
            }

            rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.print("<p>No results found.</p>");
            } else {
                while (rs.next()) {
                    String title = rs.getString("title");
                    String artistName = rs.getString("artist_name");
                    byte[] imageBytes = rs.getBytes("image");
                    int artworkDbId = rs.getInt("id");
                    String condition = rs.getString("condition");
                    String forSale = rs.getString("for_sale");
                    double price = rs.getDouble("price");
                    String description = rs.getString("description");
                    String mobileNo = rs.getString("mobile_no");
                    String email = rs.getString("email");
                    String socialMedia = rs.getString("social_media");
                    String videoLink = rs.getString("video_link");
                    String category = rs.getString("category");
                    String imageBase64 = "data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(imageBytes);
        %>
                    <div class="artwork" data-artwork-id="<%= artworkDbId %>">
                        <img src="<%= imageBase64 %>" alt="<%= title %>">
                        <h4><strong>Title:</strong> <%= title %></h4>
                        <p><strong>Artist:</strong> <%= artistName %></p>
                        <p><strong>Description:</strong> <%= description %></p>
                        <p><strong>Condition:</strong> <%= condition %></p>
                        <p><strong>For Sale:</strong> <%= forSale %></p>
                        <p><strong>Price:</strong> $<%= price %></p>
                        <p><strong>Category:</strong> <%= category %></p>
                        <p><strong>Contact Email:</strong> <%= email %></p>
                        <p><strong>Mobile No:</strong> <%= mobileNo %></p>
                        <p><strong>Social Media:</strong> <%= socialMedia %></p>
                        <% if (videoLink != null && !videoLink.isEmpty()) { %>
                            <p><strong>Video Link:</strong> <a href="<%= videoLink %>" target="_blank">Watch Video</a></p>
                        <% } %>
                    </div>
        <%
                } // end of while
            }
        } catch (SQLException e) {
            out.print("Error loading results: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            out.print("Driver not found: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                // Log the error
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