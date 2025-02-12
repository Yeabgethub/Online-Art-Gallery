import jakarta.servlet.http.HttpServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ArtistDataServlet")
public class ArtistDataServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String artistName = request.getParameter("artistName");
        String jsonResponse = "{}"; // Default response

        if (artistName != null && !artistName.isEmpty()) {
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                // Database connection details
                String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
                String DB_USER = "root";
                String DB_PASSWORD = "1234";
                String DRIVER = "com.mysql.cj.jdbc.Driver";

                Class.forName(DRIVER);
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                stmt = conn.createStatement();

                // Fetch artist's mobile number and email
                rs = stmt.executeQuery("SELECT mobileNo, email FROM artists WHERE name='" + artistName + "'");

                if (rs.next()) {
                    String mobileNo = rs.getString("mobileNo");
                    String email = rs.getString("email");
                    jsonResponse = String.format("{\"mobileNo\":\"%s\",\"email\":\"%s\"}", mobileNo, email);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                // Clean up database resources
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }
}