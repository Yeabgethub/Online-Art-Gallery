import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/DeleteArtworkServlet")
public class DeleteArtworkServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String artworkId = request.getParameter("id");
        Connection conn = null; // Declare conn outside the try block

        if (artworkId != null) {
            try {
                Class.forName(DRIVER);
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); // Initialize conn here
                // Start a transaction
                conn.setAutoCommit(false);

                // Delete from comments and ratings first to maintain referential integrity
                try (PreparedStatement pstmtComments = conn.prepareStatement("DELETE FROM comments WHERE artwork_id = ?")) {
                    pstmtComments.setInt(1, Integer.parseInt(artworkId));
                    pstmtComments.executeUpdate();
                }

                try (PreparedStatement pstmtRatings = conn.prepareStatement("DELETE FROM ratings WHERE artwork_id = ?")) {
                    pstmtRatings.setInt(1, Integer.parseInt(artworkId));
                    pstmtRatings.executeUpdate();
                }

                // Then delete the artwork
                try (PreparedStatement pstmtArtwork = conn.prepareStatement("DELETE FROM artworks WHERE id = ?")) {
                    pstmtArtwork.setInt(1, Integer.parseInt(artworkId));
                    int rowsAffected = pstmtArtwork.executeUpdate();

                    if (rowsAffected > 0) {
                        request.getSession().setAttribute("message", "Artwork deleted successfully.");
                        request.getSession().setAttribute("messageType", "success");
                    } else {
                        request.getSession().setAttribute("message", "Failed to delete artwork. Please try again.");
                        request.getSession().setAttribute("messageType", "danger");
                    }
                }

                // Commit the transaction
                conn.commit();
            } catch (Exception e) {
                try {
                    // Rollback if any error occurs
                    if (conn != null) {
                        conn.rollback();
                    }
                } catch (Exception rollbackEx) {
                    rollbackEx.printStackTrace(); // Handle rollback exception
                }
                request.getSession().setAttribute("message", "Error deleting artwork: " + e.getMessage());
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

        response.sendRedirect("manageArtworks.jsp"); // Redirect to the manage artworks page
    }
}