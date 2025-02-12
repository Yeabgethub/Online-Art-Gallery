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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private static final String ADMIN_EMAIL = "admin@example.com";
    private static final String ADMIN_PASSWORD = "123456";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();

        if (email.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Email and password are required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            if (authenticateUser("artists", email, password, request)) {
                redirectToPage(request, response, email, "artistfrontpageone.jsp");
            } else if (authenticateUser("customers", email, password, request)) {
                redirectToPage(request, response, email, "customerfrontpage.jsp");
            } else if (isAdmin(email, password)) {
                redirectToPage(request, response, email, "adminfrontpage.jsp");
            } else {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the SQL error
            request.setAttribute("errorMessage", "Database connection error. Please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // Log any other errors
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private boolean authenticateUser(String tableName, String email, String password, HttpServletRequest request) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT name, mobile_no, password FROM " + tableName + " WHERE email = ?")) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    if (BCrypt.checkpw(password, storedPassword)) {
                        HttpSession session = request.getSession();
                        session.setAttribute("artistName", rs.getString("name"));
                        session.setAttribute("mobileNo", rs.getString("mobile_no"));
                        return true;
                    }
                }
            }
        }
        return false;
    }

    private boolean isAdmin(String email, String password) {
        return email.equals(ADMIN_EMAIL) && password.equals(ADMIN_PASSWORD);
    }

    private void redirectToPage(HttpServletRequest request, HttpServletResponse response, String email, String page) throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("user", email);
        response.sendRedirect(page);
    }

    private Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database Driver Not Found", e);
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}