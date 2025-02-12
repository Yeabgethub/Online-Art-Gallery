import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/EditWorksServlet")
public class EditWorksServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String artistEmail = (String) session.getAttribute("artistEmail");

        int artworkId = Integer.parseInt(request.getParameter("artworkId"));
        String newTitle = request.getParameter("newTitle");
        String newDescription = request.getParameter("newDescription");
        String newPriceStr = request.getParameter("newPrice");
        BigDecimal newPrice = (newPriceStr != null && !newPriceStr.trim().isEmpty()) ? new BigDecimal(newPriceStr) : null;
        String newSocialMedia = request.getParameter("newSocialMedia");
        String newDateCreated = request.getParameter("newDateCreated");
        String newCondition = request.getParameter("newCondition");
        String newCategory = request.getParameter("newCategory");
        String newForSale = request.getParameter("newForSale");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName(DRIVER);
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "UPDATE artworks SET title = ?, description = ?, price = ?, social_media = ?, date_created = ?, `condition` = ?, for_sale = ?, category = ? WHERE id = ? AND email = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newTitle);
            pstmt.setString(2, newDescription);
            pstmt.setBigDecimal(3, newPrice);
            pstmt.setString(4, newSocialMedia);
            pstmt.setString(5, newDateCreated);
            pstmt.setString(6, newCondition);
            pstmt.setString(7, newForSale); // Update the "For Sale" status
            pstmt.setString(8, newCategory);
            pstmt.setInt(9, artworkId);
            pstmt.setString(10, artistEmail);

            int rowsUpdated = pstmt.executeUpdate();

            if (rowsUpdated > 0) {
                session.setAttribute("message", "Artwork updated successfully: Title - '" + newTitle + "', Category - '" + newCategory + "'.");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Artwork not found or update failed.");
                session.setAttribute("messageType", "error");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            session.setAttribute("message", "Error updating artwork: " + e.getMessage());
            session.setAttribute("messageType", "error");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("editworks.jsp");
    }
}