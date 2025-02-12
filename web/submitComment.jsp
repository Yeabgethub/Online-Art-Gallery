<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page session="true" %>

<%
String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
String DB_USER = "root"; 
String DB_PASSWORD = "1234"; 
String DRIVER = "com.mysql.cj.jdbc.Driver";

String artworkId = request.getParameter("artworkId");
String comment = request.getParameter("comment");
int customerId = (int) session.getAttribute("customerId");
String customerName = (String) session.getAttribute("customerFirstName") + " " + (String) session.getAttribute("customerLastName");

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName(DRIVER);
    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

    String sql = "INSERT INTO comments (artwork_id, customer_id, customer_name, comment) VALUES (?, ?, ?, ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(artworkId));
    pstmt.setInt(2, customerId);
    pstmt.setString(3, customerName); // Store the customer name
    pstmt.setString(4, comment);
    
    pstmt.executeUpdate();
    out.print("Comment submitted successfully.");
} catch (SQLException e) {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    out.print("Error: " + e.getMessage()); // Log this error for debugging purposes
} catch (ClassNotFoundException e) {
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    out.print("Driver not found: " + e.getMessage()); // Log this error for debugging purposes only
} finally {
    try {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        // Log the error
    }
}
%>