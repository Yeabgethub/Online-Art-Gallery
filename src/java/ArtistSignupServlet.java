import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/ArtistSignupServlet")
@MultipartConfig
public class ArtistSignupServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        // Retrieve form parameters
        String firstName = request.getParameter("firstName").trim();
        String lastName = request.getParameter("lastName").trim();
        String address = request.getParameter("address").trim();
        String mobileNo = request.getParameter("mobileno").trim();
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();
        String confirmPassword = request.getParameter("confirmPassword").trim();
        Part profileImage = request.getPart("profileImage"); // Getting the single profile image

        // Validate inputs
        StringBuilder errorMessage = new StringBuilder();
        if (firstName.isEmpty()) errorMessage.append("First Name is required.<br>");
        if (lastName.isEmpty()) errorMessage.append("Last Name is required.<br>");
        if (address.isEmpty()) errorMessage.append("Address is required.<br>");
        if (mobileNo.isEmpty() || !mobileNo.matches("09[0-9]{8}")) errorMessage.append("Invalid Mobile Number.<br>");
        if (email.isEmpty()) errorMessage.append("Email is required.<br>");
        if (profileImage == null || profileImage.getSize() == 0) errorMessage.append("Profile image is required.<br>");
        if (password.isEmpty() || confirmPassword.isEmpty()) errorMessage.append("Password is required.<br>");
        if (!password.equals(confirmPassword)) errorMessage.append("Passwords do not match.<br>");

        if (errorMessage.length() > 0) {
            request.setAttribute("error", errorMessage.toString());
            request.getRequestDispatcher("artistsignup.jsp").forward(request, response);
            return;
        }

        // Hash the password using BCrypt
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        byte[] profileImageBytes = getBytesFromInputStream(profileImage); // Get bytes from the profile image

        // Insert into database
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO artists (first_name, last_name, address, mobile_no, email, password, profile_image) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
             
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, address);
            pstmt.setString(4, mobileNo);
            pstmt.setString(5, email);
            pstmt.setString(6, hashedPassword); // Save the hashed password
            pstmt.setBytes(7, profileImageBytes); // Save the profile image as bytes
            
            pstmt.executeUpdate();
            response.sendRedirect("artistlogin.jsp");
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("artistsignup.jsp").forward(request, response);
        }
    }

    private Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database Driver Not Found", e);
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    private byte[] getBytesFromInputStream(Part part) throws IOException {
        try (InputStream inputStream = part.getInputStream();
             ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            return outputStream.toByteArray();
        }
    }
}