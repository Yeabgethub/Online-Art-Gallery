<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page session="true" %>

<%
String artworkId = request.getParameter("artworkId");
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

    String sql = "SELECT AVG(rating) AS averageRating, COUNT(*) AS ratingCount FROM ratings WHERE artwork_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(artworkId));
    rs = pstmt.executeQuery();

    if (rs.next()) {
        double averageRating = rs.getDouble("averageRating");
        int ratingCount = rs.getInt("ratingCount");
        out.print("Average Rating: " + (averageRating > 0 ? String.format("%.1f", averageRating) : "Not rated yet") + " (" + ratingCount + " ratings)");
    }
} catch (SQLException e) {
    out.print("Error retrieving rating: " + e.getMessage());
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