<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page session="true" %>

<%
String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
String DB_USER = "root";
String DB_PASSWORD = "1234";
String DRIVER = "com.mysql.cj.jdbc.Driver";

String reply = request.getParameter("reply");
int parentId = Integer.parseInt(request.getParameter("parentId"));
int customerId = (int) session.getAttribute("customerId");
String customerName = (String) session.getAttribute("customerFirstName") + " " + (String) session.getAttribute("customerLastName");

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName(DRIVER);
    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

    // Fetch the artwork ID based on the parent comment
    PreparedStatement artworkStmt = conn.prepareStatement("SELECT artwork_id FROM comments WHERE id = ?");
    artworkStmt.setInt(1, parentId);
    ResultSet artworkRs = artworkStmt.executeQuery();

    int artworkId = 0;
    if (artworkRs.next()) {
        artworkId = artworkRs.getInt("artwork_id");
    }

    // Insert the reply
    String sql = "INSERT INTO comments (artwork_id, customer_id, customer_name, comment, parent_id, is_moderated) VALUES (?, ?, ?, ?, ?, 0)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, artworkId);
    pstmt.setInt(2, customerId);
    pstmt.setString(3, customerName);
    pstmt.setString(4, reply);
    pstmt.setInt(5, parentId);
    pstmt.executeUpdate();

    out.print("Reply submitted successfully. Awaiting moderation.");
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
        out.print("<p>Error closing database resources: " + e.getMessage() + "</p>");
    }
}
%>
