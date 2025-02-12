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
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/CustomerSignupServlet")
public class CustomerSignupServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        // Getting parameters
        String firstName = request.getParameter("firstName").trim();
        String lastName = request.getParameter("lastName").trim();
        String address = request.getParameter("address").trim();
        String mobileno = request.getParameter("mobileno").trim();
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();
        String confirmPassword = request.getParameter("confirmPassword").trim();

        // Validate input data
        if (firstName.isEmpty() || lastName.isEmpty() || address.isEmpty() ||
            mobileno.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            response.sendRedirect("customerSignup.jsp?error=All fields are required.");
            return;
        }

        // Check if mobile number is valid (basic check)
        if (!mobileno.matches("^09[0-9]{8}$")) {
            response.sendRedirect("customerSignup.jsp?error=Invalid mobile number format.");
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("customerSignup.jsp?error=Passwords do not match.");
            return;
        }

        // Check for duplicate email
        if (checkDuplicateEmail(email)) {
            response.sendRedirect("customerSignup.jsp?error=Email already exists.");
            return;
        }

        // Hash the password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // Perform database operations
        if (registerCustomer(firstName, lastName, address, mobileno, email, hashedPassword)) {
            response.sendRedirect("customerlogin.jsp");
        } else {
            response.sendRedirect("customerSignup.jsp?error=Registration failed. Please try again.");
        }
    }

    private boolean checkDuplicateEmail(String email) {
        try (Connection conn = getConnection();
             PreparedStatement checkEmailStmt = conn.prepareStatement("SELECT * FROM customers WHERE email = ?")) {
            checkEmailStmt.setString(1, email);
            ResultSet rs = checkEmailStmt.executeQuery();
            return rs.next(); // Returns true if the email exists
        } catch (SQLException e) {
            // Log the error
            return false; // Treat as not duplicate for user feedback
        }
    }

    private boolean registerCustomer(String firstName, String lastName, String address,
                                      String mobileno, String email, String hashedPassword) {
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO customers (first_name, last_name, address, mobile_no, email, password) VALUES (?, ?, ?, ?, ?, ?)")) {
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, address);
            pstmt.setString(4, mobileno);
            pstmt.setString(5, email);
            pstmt.setString(6, hashedPassword); // Store the hashed password

            // Execute update
            return pstmt.executeUpdate() > 0; // Returns true if registration is successful
        } catch (SQLException e) {
            // Log the error
            return false; // Registration failed
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