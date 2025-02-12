import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/UploadArtworkServlet")
@MultipartConfig
public class UploadArtworkServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve session data
        HttpSession session = request.getSession();
        String artistName = (String) session.getAttribute("artistFirstName") + " " + (String) session.getAttribute("artistLastName");
        String mobileNo = (String) session.getAttribute("artistMobileNo");
        String email = (String) session.getAttribute("artistEmail");

        String title = request.getParameter("title");
        String socialMedia = request.getParameter("socialMedia");
        String description = request.getParameter("description");
        String dateCreated = request.getParameter("dateCreated");
        String condition = request.getParameter("condition");
        String forSale = request.getParameter("forSale");
        String price = request.getParameter("price");
        String category = request.getParameter("category");

        byte[] image1Bytes = null;
        byte[] image2Bytes = null;
        byte[] image3Bytes = null;

        try {
            // Save images from the request
            for (Part part : request.getParts()) {
                if (part.getName().equals("image") && part.getSize() > 0) {
                    if (image1Bytes == null) {
                        image1Bytes = getBytesFromInputStream(part);
                    } else if (image2Bytes == null) {
                        image2Bytes = getBytesFromInputStream(part);
                    } else if (image3Bytes == null) {
                        image3Bytes = getBytesFromInputStream(part);
                    }
                }
            }

            // Validate input data
            if (title == null || title.isEmpty() || image1Bytes == null) {
                request.setAttribute("message", "Missing required fields. Please fill in all required fields.");
                request.getRequestDispatcher("uploadworks.jsp").forward(request, response);
                return;
            }

            Connection conn = null;
            PreparedStatement pstmt = null;
            try {
                String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
                String DB_USER = "root";
                String DB_PASSWORD = "1234";
                String DRIVER = "com.mysql.cj.jdbc.Driver";

                Class.forName(DRIVER);
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                String sql = "INSERT INTO artworks (title, artist_name, mobile_no, email, social_media, description, date_created, `condition`, image, image2, image3, for_sale, price, category) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, title);
                pstmt.setString(2, artistName);
                pstmt.setString(3, mobileNo);
                pstmt.setString(4, email);
                pstmt.setString(5, socialMedia);
                pstmt.setString(6, description);
                pstmt.setString(7, dateCreated);
                pstmt.setString(8, condition);
                pstmt.setBytes(9, image1Bytes);
                pstmt.setBytes(10, image2Bytes);
                pstmt.setBytes(11, image3Bytes);
                pstmt.setString(12, forSale);
                pstmt.setString(13, price);
                pstmt.setString(14, category);
                pstmt.executeUpdate();

                // Redirect to success page with a message
                request.setAttribute("message", "Upload successful! Your artwork has been submitted.");
                request.getRequestDispatcher("uploadworks.jsp").forward(request, response);
                return;

            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("message", "Database error: " + e.getMessage());
                request.getRequestDispatcher("uploadworks.jsp").forward(request, response);
                return;
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                request.setAttribute("message", "Database driver not found.");
                request.getRequestDispatcher("uploadworks.jsp").forward(request, response);
                return;
            } finally {
                try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { /* log error */ }
                try { if (conn != null) conn.close(); } catch (SQLException e) { /* log error */ }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error processing upload: " + e.getMessage());
            request.getRequestDispatcher("uploadworks.jsp").forward(request, response);
        }
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