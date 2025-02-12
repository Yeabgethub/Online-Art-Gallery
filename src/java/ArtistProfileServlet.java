import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/artistProfile")
public class ArtistProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve session data
        HttpSession session = request.getSession(false); // Get existing session if available
        String email = (session != null) ? (String) session.getAttribute("artistEmail") : null;

        if (email == null) {
            request.setAttribute("errorMessage", "Please log in to view profiles.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        List<Map<String, String>> artists = new ArrayList<>();

        try {
            Class.forName(DRIVER);
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM artists");
                 ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    Map<String, String> artist = new HashMap<>();
                    artist.put("firstName", rs.getString("first_name"));
                    artist.put("lastName", rs.getString("last_name"));
                    artist.put("address", rs.getString("address"));
                    artist.put("mobileNo", rs.getString("mobile_no"));
                    artist.put("profileImage", rs.getString("profile_image"));
                    artist.put("email", rs.getString("email"));
                    artists.add(artist);
                }
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // Set the list of artists to the request
        request.setAttribute("artists", artists);
        request.getRequestDispatcher("artistProfile.jsp").forward(request, response);
    }
}