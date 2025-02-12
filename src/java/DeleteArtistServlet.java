import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/DeleteArtistServlet")
public class DeleteArtistServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String artistId = request.getParameter("id");

        if (artistId != null) {
            try {
                Class.forName(DRIVER);
                try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                     PreparedStatement pstmt = conn.prepareStatement("DELETE FROM artists WHERE id = ?")) {
                    
                    pstmt.setInt(1, Integer.parseInt(artistId));
                    int rowsAffected = pstmt.executeUpdate();

                    if (rowsAffected > 0) {
                        request.getSession().setAttribute("message", "Artist deleted successfully.");
                        request.getSession().setAttribute("messageType", "success");
                    } else {
                        request.getSession().setAttribute("message", "Failed to delete artist. Please try again.");
                        request.getSession().setAttribute("messageType", "danger");
                    }
                }
            } catch (Exception e) {
                request.getSession().setAttribute("message", "Error deleting artist: " + e.getMessage());
                request.getSession().setAttribute("messageType", "danger");
            }
        }

        response.sendRedirect("manageArtists.jsp"); // Redirect to the manage artists page
    }
}