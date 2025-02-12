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

@WebServlet("/CustomerLoginServlet")
public class CustomerLoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();

        // Server-side validation for empty fields
        if (email.isEmpty() || password.isEmpty()) {
            response.sendRedirect("customerlogin.jsp?error=Email and password are required.");
            return;
        }

        // Database connection and credential check
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM customers WHERE email = ?")) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) { // Customer found
                    String storedPassword = rs.getString("password");

                    // Check if the stored password is valid
                    if (BCrypt.checkpw(password, storedPassword)) {
                        // Create a session for the customer
                        HttpSession session = request.getSession();
                        session.setAttribute("customerId", rs.getInt("id")); // Store customer ID
                        session.setAttribute("customerFirstName", rs.getString("first_name")); // Store first name
                        session.setAttribute("customerLastName", rs.getString("last_name")); // Store last name
                        session.setAttribute("customerAddress", rs.getString("address")); // Store address
                        session.setAttribute("customerMobileNo", rs.getString("mobile_no")); // Store mobile number
                        session.setAttribute("customerEmail", email); // Store email

                        // Redirect to the customer's front page
                        response.sendRedirect("customerfrontpage.jsp");
                    } else {
                        response.sendRedirect("customerlogin.jsp?error=Invalid password.");
                    }
                } else {
                    response.sendRedirect("customerlogin.jsp?error=Invalid email address.");
                }
            }
        } catch (SQLException e) {
            response.sendRedirect("customerlogin.jsp?error=An error occurred while processing your request.");
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