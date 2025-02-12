<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Artist Profiles - Online Art Gallery</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="shortcut icon" href="C:/Users/DrDj92/Downloads/favi.jpg">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
        }

        header {
            background-color: rgba(0, 0, 0, 0.8);
            color: #fff;
            padding: 15px 20px;
            text-align: center;
        }

        h1 {
            margin: 0;
            font-size: 2.5em;
        }

        .navbar {
            display: flex;
            justify-content: center;
            background-color: rgba(0, 0, 0, 0.7);
            padding: 10px;
        }

        .navbar a {
            color: #f2f2f2;
            padding: 14px 20px;
            text-decoration: none;
            text-align: center;
            transition: background-color 0.3s;
        }

        .navbar a:hover {
            background-color: #ddd;
            color: black;
        }

        .artist-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 20px;
        }

        .artist-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            margin: 15px;
            overflow: hidden;
            width: 300px;
            transition: transform 0.3s;
        }

        .artist-card:hover {
            transform: scale(1.05);
        }

        .artist-image {
            width: 100%;
            height: auto;
        }

        .artist-info {
            padding: 15px;
            text-align: center;
        }

        .artist-info h2 {
            margin: 10px 0;
            font-size: 1.5em;
        }

        .artist-info p {
            margin: 5px 0;
            color: #555;
        }

        footer {
            text-align: center;
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.8);
            color: #f2f2f2;
            position: relative;
            bottom: 0;
            width: 100%;
        }

        @media only screen and (max-width: 600px) {
            .artist-card {
                width: 90%;
            }
        }
    </style>
</head>

<body>

    <header>
        <h1>Artist Profiles</h1>
    </header>

    <nav class="navbar">
        <a href="home.jsp">Home</a>
        <a href="customerfrontpage.jsp">Paintings</a>
        <a href="About_us.jsp">About Us</a>
        <a href="my_profile.jsp">My Profile</a>
        <a href="my_profile.jsp">My Works</a>
        <a href="LogoutServlet">Logout</a>>
    </nav>

    <div class="artist-container">
        <% 
            String DB_URL = "jdbc:mysql://localhost:3306/art_gallery";
            String DB_USER = "root";
            String DB_PASSWORD = "1234";
            String DRIVER = "com.mysql.cj.jdbc.Driver";

            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName(DRIVER);
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                stmt = conn.createStatement();
                String sql = "SELECT * FROM artists"; // Adjust query as necessary
                rs = stmt.executeQuery(sql);

                while (rs.next()) {
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    String address = rs.getString("address");
                    String mobileNo = rs.getString("mobile_no");
                    String email = rs.getString("email");
                    String profileImage = rs.getString("profile_image");
            %>
            <div class="artist-card">
                <img src="uploads/<%= profileImage %>" alt="<%= firstName + " " + lastName %>" class="artist-image"/>
                <div class="artist-info">
                    <h2><%= firstName + " " + lastName %></h2>
                    <p>Address: <%= address %></p>
                    <p>Mobile No: <%= mobileNo %></p>
                    <p>Email: <%= email %></p>
                </div>
            </div>
            <% 
                }
            } catch (SQLException e) {
                out.println("<p>Database error: " + e.getMessage() + "</p>");
            } catch (ClassNotFoundException e) {
                out.println("<p>Driver not found: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) {}
                try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
                try { if (conn != null) conn.close(); } catch (SQLException e) {}
            }
        %>
    </div>

    <footer>
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: <a href="mailto:info@artgallery.com" style="color: #f2f2f2;">info@artgallery.com</a></p>
    </footer>
</body>

</html>