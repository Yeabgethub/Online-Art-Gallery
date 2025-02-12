<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Art Gallery</title>
    <link rel="stylesheet" href="css/frontpage.css">
    <link rel="shortcut icon" href="C:/Users/DrDj92/Downloads/favi.jpg">
    <script type="text/javascript" src="js/frontpage.js"></script>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: Verdana, sans-serif;
            background-image: url("art_gallery_wall_background_wallpaper.jpg");
            background-size: cover;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #fff;
            padding-top: 20px;
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
            position: relative;
        }

        .navbar a:hover {
            background-color: #ddd;
            color: black;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: rgba(0, 0, 0, 0.9);
            min-width: 160px;
            z-index: 1;
        }

        .dropdown-content a {
            color: #f2f2f2;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown-content a:hover {
            background-color: #ddd;
            color: black;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .slideshow-container {
            max-width: 1000px;
            margin: auto;
            position: relative;
        }

        .mySlides {
            display: none;
        }

        .dot {
            height: 15px;
            width: 15px;
            margin: 0 2px;
            background-color: #bbb;
            border-radius: 50%;
            display: inline-block;
            transition: background-color 0.6s ease;
        }

        .active {
            background-color: #717171;
        }

        footer {
            text-align: center;
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.7);
            width: 100%;
            color: #f2f2f2;
        }

        @media only screen and (max-width: 300px) {
            .text {
                font-size: 11px;
            }
        }
    </style>
</head>

<body>

    <h2>Online Art Gallery</h2>

    <div class="navbar">
        <a href="frontpage.jsp">Home</a>
        <a href="visitorsignup.jsp">Paintings</a>
        <a href="About_us.jsp">About Us</a>
        <div class="dropdown">
            <button class="dropbtn">Sign Up</button>
            <div class="dropdown-content">
                <a href="artist_signup.jsp">Artist</a>
                <a href="customer_signup.jsp">Customer</a>
            </div>
        </div>
        <a href="login.jsp">Login</a>
    </div>

    <div class="slideshow-container">
        <div class="mySlides fade">
            <img src="https://www.thechannels.org/wp-content/uploads/2016/09/MTWTsuno3-edit-1.jpg" style="width:100%; height:auto;">
        </div>

        <div class="mySlides fade">
            <img src="https://1.bp.blogspot.com/-r3YNBP3Cohk/Wa0p9Wjy9YI/AAAAAAAAkeM/OssgRUkyRv4J0duhN72SgM3q9NnZXWInQCLcBGAs/s1600/corey_barksdale_art.jpg" style="width:100%; height:auto;">
        </div>

        <div class="mySlides fade">
            <img src="https://www.wandermonkey.com/images/listing_images/gallery/1277/Jehangir%20Art%20Gallery%20Mumbai%20Attractions%20WanderMonkey.com%20(11).JPG" style="width:100%; height:auto;">
        </div>
    </div>

    <br>

    <div style="text-align:center">
        <span class="dot"></span>
        <span class="dot"></span>
        <span class="dot"></span>
    </div>

    <script>
        var slideIndex = 0;
        showSlides();

        function showSlides() {
            var i;
            var slides = document.getElementsByClassName("mySlides");
            var dots = document.getElementsByClassName("dot");
            for (i = 0; i < slides.length; i++) {
                slides[i].style.display = "none";
            }
            slideIndex++;
            if (slideIndex > slides.length) { slideIndex = 1; }
            for (i = 0; i < dots.length; i++) {
                dots[i].className = dots[i].className.replace(" active", "");
            }
            slides[slideIndex - 1].style.display = "block";
            dots[slideIndex - 1].className += " active";
            setTimeout(showSlides, 2000); // Change image every 2 seconds
        }
    </script>

    <footer>
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: info@artgallery.com</p>
    </footer>
</body>

</html>