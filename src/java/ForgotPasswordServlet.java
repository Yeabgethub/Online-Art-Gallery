import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email").trim();
        String mobileNo = request.getParameter("mobileno").trim();
        String newPassword = request.getParameter("newPassword").trim();
        String confirmPassword = request.getParameter("confirmPassword").trim();
        String message;

        if (!newPassword.equals(confirmPassword)) {
            message = "Passwords do not match.";
            response.sendRedirect("forgotPassword.jsp?message=" + message);
            return;
        }

        // Hash the new password
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

        // Verify email and mobile number, and update password
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT id FROM artists WHERE email = ? AND mobile_no = ?")) {
            pstmt.setString(1, email);
            pstmt.setString(2, mobileNo);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id");

                // Update the password in the artists table
                try (PreparedStatement updatePstmt = conn.prepareStatement("UPDATE artists SET password = ? WHERE id = ?")) {
                    updatePstmt.setString(1, hashedPassword);
                    updatePstmt.setInt(2, userId);
                    updatePstmt.executeUpdate();
                }

                message = "Password has been updated successfully.";
            } else {
                message = "No account found with that email and mobile number.";
            }
        } catch (Exception e) {
            message = "Database error: " + e.getMessage();
        }

        // Redirect back with message
        response.sendRedirect("artistlogin.jsp?message=" + message);
    }

    private Connection getConnection() throws Exception {
        Class.forName(DRIVER);
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}