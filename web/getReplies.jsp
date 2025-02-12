<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>

<%
int parentId = Integer.parseInt(request.getParameter("parentId"));
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

    String sql = "SELECT c.id, c.comment, c.created_at, u.first_name, u.last_name " +
                 "FROM comments c JOIN customers u ON c.customer_id = u.id " +
                 "WHERE c.parent_id = ? ORDER BY c.created_at ASC";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, parentId);
    rs = pstmt.executeQuery();

    if (!rs.isBeforeFirst()) {
        out.print("<p>No replies available.</p>");
    } else {
        while (rs.next()) {
            String commentText = rs.getString("comment");
            String customerName = rs.getString("first_name") + " " + rs.getString("last_name");
            Timestamp createdAt = rs.getTimestamp("created_at");
%>
            <div class="comment">
                <strong><%= customerName %></strong> <em><%= createdAt %></em>
                <p><%= commentText %></p>
            </div>
<%
        }
    }
} catch (SQLException e) {
    out.print("Error retrieving replies: " + e.getMessage());
} catch (ClassNotFoundException e) {
    out.print("Driver not found: " + e.getMessage());
} finally {
    try {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        out.print("Error closing resources: " + e.getMessage());
    }
}
%>