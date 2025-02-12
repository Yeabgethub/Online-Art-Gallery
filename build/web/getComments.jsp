<%@ page import="java.sql.*" %>
<%
    String artworkId = request.getParameter("artworkId");
    String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    String DB_USER = "root"; 
    String DB_PASSWORD = "1234"; 
    String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Connect to database
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

        // SQL to fetch comments for the specific artwork
        String sql = "SELECT customer_name, comment, created_at FROM comments WHERE artwork_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(artworkId));
        rs = pstmt.executeQuery();

        // Check if there are comments
        if (!rs.next()) {
            out.print("<p>No comments yet.</p>");
        } else {
            do {
                String customerName = rs.getString("customer_name");
                String comment = rs.getString("comment");
                String createdAt = rs.getString("created_at");

                // Display each comment
                out.print("<div class='comment'>");
                out.print("<strong>" + customerName + "</strong> <em>" + createdAt + "</em>");
                out.print("<p>" + comment + "</p>");
                out.print("</div>");
            } while (rs.next());
        }
    } catch (SQLException | ClassNotFoundException e) {
        out.print("<p>Error fetching comments: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.print("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
%>
