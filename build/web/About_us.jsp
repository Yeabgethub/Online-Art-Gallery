<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>About Us - Online Art Gallery</title>
    <link rel="shortcut icon" href="C:\Users\DrDj92\Downloads\favi.jpg">
    <style>
        body {
            background-image: url('images/orange.jpg');    
            background-size: cover;  
            font-family: 'Arial', sans-serif;
            color: #fff;
            margin: 0;
            padding: 0;
        }
        h1 {
            text-align: center;
            margin-top: 50px;
            font-size: 40px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
        }
        .navbar {
            display: flex;
            justify-content: center;
            background-color: rgba(0, 0, 0, 0.8);
            padding: 15px;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .navbar a {
            color: white;
            padding: 14px 20px;
            text-decoration: none;
            transition: background-color 0.3s;
            margin: 0 10px;
        }
        .navbar a:hover {
            background-color: rgba(255, 255, 255, 0.3);
            border-radius: 5px;
        }
        .content {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.7);
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }
        p {
            font-size: 18px;
            line-height: 1.6;
            color: #fff;
        }
        .about-me {
            text-align: center;
            margin-top: 40px;
        }
        .about-me img {
            width: 150px;
            height: auto;
            border-radius: 50%;
            border: 2px solid #fff;
        }
        .about-me h2 {
            margin-top: 10px;
            font-size: 28px;
            color: #FFD700; /* Gold color for emphasis */
        }
    </style>
</head>
<body>
    <h1>About Us</h1>

    <div class="navbar">
        <nav class="navbar">
        <a href="customerfrontpage.jsp">Back</a>
             <a href="highrating artwork.jsp">High ratings artwork</a>
        <a href="LogoutCustomerServlet">Logout</a>
     
        
        
        
    </nav>
    
    </div>

    <div class="content">
        <p>
            <strong>Welcome to our premier online art gallery!</strong> 
            We showcase a diverse collection of original contemporary art, traditional and modern art paintings,
            drawings, and sketches from both renowned and emerging artists. 
            Explore our finest collection of acrylic paintings, oil paintings, and mixed media art, 
            categorized into various styles including abstract, landscape, figurative, and still life.
        </p>
        <p>
            As an art collector, you have the freedom to choose from our beautiful collection and sort artworks by artist name, category, style, medium, surface, and price.
            Browse through our curated selection and enjoy the liberty of creating your personal art collection!
        </p>
    </div>

    <div class="about-me">
        <img src="https://static.vecteezy.com/system/resources/previews/024/183/502/non_2x/male-avatar-portrait-of-a-young-man-with-a-beard-illustration-of-male-character-in-modern-color-style-vector.jpg" alt="Yeabsira Getachew">
        <h2>Full Stack Web Developer Engineer Yeabsira Getachew</h2>
        <p>
         
            Passionate about creating innovative solutions and enhancing user experiences through technology. 
            With a strong background in software development and a love for art, 
            I strive to bridge the gap between technology and creativity.
        </p>
    </div>
</body>
</html>