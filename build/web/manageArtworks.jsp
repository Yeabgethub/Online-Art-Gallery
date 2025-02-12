<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Base64" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Artworks - Online Art Gallery</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            margin-top: 20px;
        }
        .table img {
            width: 100px; /* Set a fixed width */
            height: 100px; /* Set a fixed height */
            object-fit: cover; /* Cover the space without distortion */
            border-radius: 5px; /* Optional: add some rounding */
        }
        /* Hover effect for table rows */
        .table tbody tr:hover {
            background-color: #e9ecef; /* Light gray background on hover */
            cursor: pointer; /* Change cursor to pointer */
        }
        /* Custom styles for table column widths */
        .table th, .table td {
            vertical-align: middle; /* Center align vertically */
        }
        .table td {
            word-wrap: break-word; /* Allow text to wrap */
        }
        .description-cell {
            max-width: 150px; /* Limit width of description */
        }
    </style>
    <script>
        function filterArtworks() {
            const input = document.getElementById("artworkFilter");
            const filter = input.value.toLowerCase();
            const table = document.getElementById("artworksTable");
            const tr = table.getElementsByTagName("tr");

            for (let i = 1; i < tr.length; i++) {
                const tdTitle = tr[i].getElementsByTagName("td")[1]; // Title
                const tdArtist = tr[i].getElementsByTagName("td")[2]; // Artist
                const tdRating = tr[i].getElementsByTagName("td")[10]; // Rating
                if (tdTitle || tdArtist || tdRating) {
                    const textValueTitle = tdTitle.textContent || tdTitle.innerText;
                    const textValueArtist = tdArtist.textContent || tdArtist.innerText;
                    const textValueRating = tdRating.textContent || tdRating.innerText;
                    if (textValueTitle.toLowerCase().indexOf(filter) > -1 || 
                        textValueArtist.toLowerCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }

        function filterByRating() {
            const ratingFilter = document.getElementById("ratingFilter").value;
            const table = document.getElementById("artworksTable");
            const tr = table.getElementsByTagName("tr");

            for (let i = 1; i < tr.length; i++) {
                const tdRating = tr[i].getElementsByTagName("td")[10]; // Rating
                if (tdRating) {
                    const ratingValue = tdRating.textContent;
                    if (ratingFilter === "all" || 
                        (ratingFilter === "1" && ratingValue >= 1) ||
                        (ratingFilter === "2" && ratingValue >= 2) ||
                        (ratingFilter === "3" && ratingValue >= 3) ||
                        (ratingFilter === "4" && ratingValue >= 4) ||
                        (ratingFilter === "5" && ratingValue >= 5)) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
</head>

<body>
    <header class="bg-dark text-white text-center py-3">
        <h1>Manage Artworks</h1>
    </header>

    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="adminDashboard.jsp">Dashboard</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="LogoutAdminServlet">Logout</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container form-container">
        <h2 class="mt-4">Existing Artworks</h2>
        
        <!-- Filter Input -->
        <div class="mb-3">
            <input type="text" id="artworkFilter" onkeyup="filterArtworks()" class="form-control" placeholder="Filter by Title or Artist">
        </div>

        <!-- Rating Filter -->
        <div class="mb-3">
            <select id="ratingFilter" class="form-control" onchange="filterByRating()">
                <option value="all">All Ratings</option>
                <option value="1">1 Star & Up</option>
                <option value="2">2 Stars & Up</option>
                <option value="3">3 Stars & Up</option>
                <option value="4">4 Stars & Up</option>
                <option value="5">5 Stars & Up</option>
            </select>
        </div>

        <table class="table table-striped table-bordered table-responsive" id="artworksTable">
            <thead>
                <tr>
                    <th style="width: 50px;">ID</th>
                    <th style="width: 150px;">Title</th>
                    <th style="width: 100px;">Artist</th>
                    <th style="width: 100px;">Mobile No</th>
                    <th style="width: 150px;">Email</th>
                    <th style="width: 100px;">Condition</th>
                    <th style="width: 80px;">Price</th>
                    <th style="width: 80px;">For Sale</th>
                    <th style="width: 100px;">Category</th>
                    <th class="description-cell">Description</th>
                    <th style="width: 80px;">Rating</th>
                    <th style="width: 150px;">Social Media</th>
                    <th style="width: 100px;">Image</th>
                    <th style="width: 150px;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String DB_URL = "jdbc:mysql://localhost:3306/art_gallery?zeroDateTimeBehavior=CONVERT_TO_NULL";
                    String DB_USER = "root";
                    String DB_PASSWORD = "1234";
                    String DRIVER = "com.mysql.cj.jdbc.Driver";

                    try {
                        Class.forName(DRIVER);
                        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                             PreparedStatement pstmt = conn.prepareStatement(
                                 "SELECT a.*, AVG(r.rating) as average_rating " +
                                 "FROM artworks a LEFT JOIN ratings r ON a.id = r.artwork_id " +
                                 "GROUP BY a.id");
                             ResultSet rs = pstmt.executeQuery()) {

                            while (rs.next()) {
                                int artworkId = rs.getInt("id");
                                String title = rs.getString("title");
                                String artist = rs.getString("artist_name");
                                String mobileNo = rs.getString("mobile_no");
                                String email = rs.getString("email");
                                String socialMedia = rs.getString("social_media");
                                String description = rs.getString("description");
                                Date dateCreated = rs.getDate("date_created");
                                String condition = rs.getString("condition");
                                double price = rs.getDouble("price");
                                String forSale = rs.getString("for_sale");
                                String category = rs.getString("category");
                                byte[] imageData = rs.getBytes("image");
                                String base64Image = Base64.getEncoder().encodeToString(imageData);
                                double averageRating = rs.getDouble("average_rating");
                %>
                                <tr>
                                    <td><%= artworkId %></td>
                                    <td><%= title %></td>
                                    <td><%= artist %></td>
                                    <td><%= mobileNo %></td>
                                    <td><%= email %></td>
                                    <td><%= condition %></td>
                                    <td><%= price %></td>
                                    <td><%= forSale %></td>
                                    <td><%= category %></td>
                                    <td class="description-cell" title="<%= description %>"><%= description.length() > 30 ? description.substring(0, 30) + "..." : description %></td>
                                    <td><%= averageRating > 0 ? averageRating : "N/A" %></td>
                                    <td><%= socialMedia %></td>
                                    <td>
                                        <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Artwork" data-toggle="modal" data-target="#imageModal" data-img="data:image/jpeg;base64,<%= base64Image %>">
                                    </td>
                                    <td>
                                        <a href="DeleteArtworkServlet?id=<%= artworkId %>" class="btn btn-danger btn-sm">Delete</a>
                                    </td>
                                </tr>
                <%
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>");
                    } catch (ClassNotFoundException e) {
                        out.println("<div class='alert alert-danger'>Driver not found: " + e.getMessage() + "</div>");
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- Modal for larger image view -->
    <div class="modal fade" id="imageModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Artwork Image</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <img id="modalImage" src="" alt="Artwork" style="width: 100%; height: auto;">
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-4">
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Script to handle the modal image display
        $(document).ready(function() {
            $('#imageModal').on('show.bs.modal', function(event) {
                var button = $(event.relatedTarget); // Button that triggered the modal
                var imgSrc = button.data('img'); // Extract info from data-* attributes
                var modalImage = $('#modalImage'); // Image element in modal
                modalImage.attr('src', imgSrc); // Set the image source
            });
        });
    </script>
</body>
</html>