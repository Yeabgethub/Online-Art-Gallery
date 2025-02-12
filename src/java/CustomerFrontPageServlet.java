import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CustomerFrontPageServlet")
public class CustomerFrontPageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
        String DB_USER = "root";
        String DB_PASSWORD = "1234";
        String DRIVER = "com.mysql.cj.jdbc.Driver";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder artworksHtml = new StringBuilder();

        try {
            Class.forName(DRIVER);
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT id, title, artist_name, mobile_no, email, social_media, description, " +
                         "`date_created`, `condition`, image, video_link, for_sale, price, category " +
                         "FROM artworks";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String title = rs.getString("title");
                String artistName = rs.getString("artist_name");
                String mobileNo = rs.getString("mobile_no");
                String email = rs.getString("email");
                String socialMedia = rs.getString("social_media");
                String description = rs.getString("description");
                byte[] imageBytes = rs.getBytes("image");
                int artworkDbId = rs.getInt("id");
                String condition = rs.getString("condition");
                String forSale = rs.getString("for_sale");
                double price = rs.getDouble("price");
                String videoLink = rs.getString("video_link");
                String category = rs.getString("category");

                String imageBase64 = "data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(imageBytes);

                artworksHtml.append("<div class='artwork'>")
                             .append("<img src='").append(imageBase64).append("' alt='").append(title).append("'>")
                             .append("<div class='artwork-description' id='description_").append(artworkDbId).append("' style='display: none;'>")
                             .append("<p>Artist: ").append(artistName).append("</p>")
                             .append("<p>Title: ").append(title).append("</p>")
                             .append("<p>Description: ").append(description).append("</p>")
                             .append("<p>Condition: ").append(condition).append("</p>")
                             .append("<p>For Sale: ").append(forSale.equals("yes") ? "Yes" : "No").append("</p>")
                             .append("<p>Price: $").append(price).append("</p>")
                             .append("<p>Contact: ").append(email).append(" (Mobile: ").append(mobileNo).append(")</p>")
                             .append("<p>Social Media: ").append(socialMedia).append("</p>")
                             .append("<p>Category: ").append(category).append("</p>")
                             .append("<p>Video Link: ").append(videoLink != null ? "<a href='" + videoLink + "'>Watch Video</a>" : "No video available").append("</p>")
                             .append("</div>")
                             .append("<button onclick='toggleDescription(").append(artworkDbId).append(")'>Show Description</button>")
                             .append("<div class='rating' id='rating_").append(artworkDbId).append("'>")
                             .append("<span class='star' onclick='rateArtwork(").append(artworkDbId).append(", 1)'>★</span>")
                             .append("<span class='star' onclick='rateArtwork(").append(artworkDbId).append(", 2)'>★</span>")
                             .append("<span class='star' onclick='rateArtwork(").append(artworkDbId).append(", 3)'>★</span>")
                             .append("<span class='star' onclick='rateArtwork(").append(artworkDbId).append(", 4)'>★</span>")
                             .append("<span class='star' onclick='rateArtwork(").append(artworkDbId).append(", 5)'>★</span>")
                             .append("</div>")
                             .append("<div class='comment-section'>")
                             .append("<input type='text' id='commentInput_").append(artworkDbId).append("' placeholder='Add a comment...' />")
                             .append("<button onclick='submitComment(").append(artworkDbId).append(")'>Submit Comment</button>")
                             .append("</div>")
                             .append("<div class='comments' id='comments_").append(artworkDbId).append("'>")
                             .append("<p>No comments yet.</p>")
                             .append("</div>")
                             .append("</div>");
            }

            request.setAttribute("artworksHtml", artworksHtml.toString());

            HttpSession httpSession = request.getSession();
            String userName = (String) httpSession.getAttribute("login1");
            request.setAttribute("userName", userName);

            request.getRequestDispatcher("customerFrontPage.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving artworks: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}