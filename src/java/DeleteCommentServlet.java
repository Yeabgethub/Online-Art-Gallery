import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/DeleteCommentServlet")
public class DeleteCommentServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String commentId = request.getParameter("id");
        Connection conn = null; // Declare conn outside the try block

        if (commentId != null) {
            try {
                Class.forName(DRIVER);
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); // Initialize conn here
                try (PreparedStatement pstmt = conn.prepareStatement("DELETE FROM comments WHERE id = ?")) {
                    pstmt.setInt(1, Integer.parseInt(commentId));
                    int rowsAffected = pstmt.executeUpdate();

                    if (rowsAffected > 0) {
                        request.getSession().setAttribute("message", "Comment deleted successfully.");
                        request.getSession().setAttribute("messageType", "success");
                    } else {
                        request.getSession().setAttribute("message", "Failed to delete comment. Please try again.");
                        request.getSession().setAttribute("messageType", "danger");
                    }
                }
            } catch (Exception e) {
                request.getSession().setAttribute("message", "Error deleting comment: " + e.getMessage());
                request.getSession().setAttribute("messageType", "danger");
            } finally {
                // Close the connection in the finally block to ensure it gets closed
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (Exception closeEx) {
                        closeEx.printStackTrace(); // Handle connection close exception
                    }
                }
            }
        }

        response.sendRedirect("commentsManage.jsp"); // Redirect to the manage comments page
    }
}