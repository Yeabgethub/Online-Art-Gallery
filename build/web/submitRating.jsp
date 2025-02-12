<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page session="true" %>

<%
String artworkId = request.getParameter("artworkId");
int rating = Integer.parseInt(request.getParameter("rating"));
int customerId = (int) session.getAttribute("customerId"); // Assuming customer ID is stored in the session

Connection conn = null;
PreparedStatement pstmt = null;

try {
    String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    String DB_USER = "root"; 
    String DB_PASSWORD = "1234"; 
    String DRIVER = "com.mysql.cj.jdbc.Driver";

    Class.forName(DRIVER);
    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

    // Check if the rating already exists
    String sqlCheck = "SELECT * FROM ratings WHERE artwork_id = ? AND customer_id = ?";
    pstmt = conn.prepareStatement(sqlCheck);
    pstmt.setInt(1, Integer.parseInt(artworkId));
    pstmt.setInt(2, customerId);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        // Update existing rating
        String sqlUpdate = "UPDATE ratings SET rating = ? WHERE artwork_id = ? AND customer_id = ?";
        pstmt = conn.prepareStatement(sqlUpdate);
        pstmt.setInt(1, rating);
        pstmt.setInt(2, Integer.parseInt(artworkId));
        pstmt.setInt(3, customerId);
        pstmt.executeUpdate();
    } else {
        // Insert new rating
        String sqlInsert = "INSERT INTO ratings (artwork_id, customer_id, rating) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sqlInsert);
        pstmt.setInt(1, Integer.parseInt(artworkId));
        pstmt.setInt(2, customerId);
        pstmt.setInt(3, rating);
        pstmt.executeUpdate();
    }

    out.print("Rating submitted successfully.");
} catch (SQLException e) {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    out.print("Error: " + e.getMessage());
} catch (ClassNotFoundException e) {
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    out.print("Driver not found: " + e.getMessage());
} finally {
    try {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        // Log the error
    }
}
%>