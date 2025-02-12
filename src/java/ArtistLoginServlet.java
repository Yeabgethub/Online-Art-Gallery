import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/ArtistLoginServlet")
public class ArtistLoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    // Hardcoded admin credentials
    private static final String ADMIN_EMAIL = "admin@example.com"; // Replace with your admin email
    private static final String ADMIN_PASSWORD = "adminPassword"; // Replace with your admin password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();

        // Server-side validation for empty fields
        if (email.isEmpty() || password.isEmpty()) {
            response.sendRedirect("artistlogin.jsp?error=Email and password are required.");
            return;
        }

        // Check if the input is for admin login
        if (ADMIN_EMAIL.equals(email) && ADMIN_PASSWORD.equals(password)) {
            // Redirect to admin dashboard
            response.sendRedirect("adminDashboard.jsp"); // Change to your actual admin dashboard page
            return;
        }

        // Database connection and credential check for artists
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM artists WHERE email = ?")) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) { // Artist found
                    String storedPassword = rs.getString("password");

                    // Check if the stored password is valid
                    if (BCrypt.checkpw(password, storedPassword)) {
                        // Create a session for the artist
                        HttpSession session = request.getSession();
                        session.setAttribute("artistId", rs.getInt("id")); // Store artist ID
                        session.setAttribute("artistFirstName", rs.getString("first_name")); // Store first name
                        session.setAttribute("artistLastName", rs.getString("last_name")); // Store last name
                        session.setAttribute("artistAddress", rs.getString("address")); // Store address
                        session.setAttribute("artistMobileNo", rs.getString("mobile_no")); // Store mobile number
                        session.setAttribute("artistEmail", email); // Store email
                        session.setAttribute("artistProfileImage", rs.getBytes("profile_image")); // Store profile image (if needed)

                        // Redirect to the artist's front page
                        response.sendRedirect("artistfrontpageone.jsp");
                    } else {
                        response.sendRedirect("artistlogin.jsp?error=Invalid password.");
                    }
                } else {
                    response.sendRedirect("artistlogin.jsp?error=Invalid email address.");
                }
            }
        } catch (SQLException e) {
            response.sendRedirect("artistlogin.jsp?error=An error occurred while processing your request.");
            e.printStackTrace(); // Log the error for debugging
        }
    }

    private Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER); // Load JDBC driver
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database Driver Not Found", e);
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}