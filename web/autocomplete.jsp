<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList" %>
<%

String query = request.getParameter("query");
ArrayList<String> suggestions = new ArrayList<>();

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

    String sql = "SELECT title FROM artworks WHERE title LIKE ? LIMIT 5"; // Adjust as needed
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, "%" + query + "%");
    rs = pstmt.executeQuery();

    while (rs.next()) {
        suggestions.add(rs.getString("title"));
    }
} catch (SQLException | ClassNotFoundException e) {
    e.printStackTrace();
} finally {
    try {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

response.setContentType("application/json");
response.getWriter().write(new Gson().toJson(suggestions)); // Use Gson for JSON conversion
%>