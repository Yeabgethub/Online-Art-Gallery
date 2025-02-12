<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Artwork - Online Art Gallery</title>
    <link rel="stylesheet" href="css/uploadworks.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding: 20px;
        }
        .upload-artwork {
            max-width: 600px; /* Limit the width of the form */
            margin: 0 auto; /* Center the form */
        }
        .note {
            font-size: 0.9em;
            color: #555;
        }
        .error-message {
            display: none;
            color: red;
            font-size: 0.9em;
        }
        #imagePreview img {
            width: 100px; /* Set a fixed width for preview images */
            height: auto; /* Maintain aspect ratio */
            margin: 5px; /* Add some space between images */
        }
        button {
            margin-top: 10px;
        }
    </style>
    <script>
        function validateForm() {
            const priceField = document.getElementById('price');
            const priceError = document.getElementById('priceError');
            const mobileNoField = document.getElementById('mobileNo');
            const mobileNoError = document.getElementById('mobileNoError');

            let isValid = true;

            // Validate price
            if (document.getElementById('forSale').value === "yes" && !/^\d+(\.\d{1,2})?$|^N\/A$/i.test(priceField.value)) {
                priceError.style.display = 'block';
                isValid = false;
            } else {
                priceError.style.display = 'none';
            }

            // Validate mobile number (simple validation)
            if (!/^\d+$/.test(mobileNoField.value)) {
                mobileNoError.style.display = 'block';
                isValid = false;
            } else {
                mobileNoError.style.display = 'none';
            }

            return isValid && validateFileType();
        }

        function validateFileType() {
            const fileInput = document.getElementById('image');
            const allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif)$/i;
            const files = fileInput.files;

            for (let i = 0; i < files.length; i++) {
                if (!allowedExtensions.exec(files[i].name)) {
                    alert('Please upload files with valid image extensions (jpg, jpeg, png, gif).');
                    fileInput.value = '';
                    return false;
                }
            }
            return true;
        }

        function previewImages(event) {
            const imagePreviewContainer = document.getElementById('imagePreview');
            imagePreviewContainer.innerHTML = ''; // Clear previous previews

            const files = event.target.files;
            for (let i = 0; i < files.length; i++) {
                const img = document.createElement('img');
                img.src = URL.createObjectURL(files[i]);
                img.alt = "Image Preview";
                imagePreviewContainer.appendChild(img);
                
                // Revoke the object URL after the image loads
                img.onload = () => {
                    URL.revokeObjectURL(img.src); // Free memory
                };
            }
        }

        function togglePriceRequired() {
            const forSaleField = document.getElementById('forSale');
            const priceField = document.getElementById('price');

            if (forSaleField.value === "no") {
                priceField.value = ''; // Clear the price field
                priceField.setAttribute('disabled', 'disabled'); // Disable the price input
                priceField.removeAttribute('required'); // Remove required attribute
            } else {
                priceField.removeAttribute('disabled'); // Enable the price input
                priceField.setAttribute('required', 'required'); // Add required attribute
            }
        }

        window.onload = togglePriceRequired;
    </script>
</head>

<body>
    <header>
        <h1>Upload Your Artwork</h1>
    </header>

    <nav class="navbar">
        <a href="index.html">Home</a>
        <a href="customerfrontpage.jsp">Paintings</a>
        <a href="About_us.jsp">About Us</a>
        <a href="editartistprofile.jsp">My Profile</a>
        <a href="editworks.jsp">My Works</a>
        <a href="uploadworks.jsp">Upload Paintings</a>
        <a href="LogoutServlet">Logout</a>
    </nav>

    <main>
        <section class="upload-artwork">
            <h2>Upload Artwork</h2>

            <%
                String artistName = (String) session.getAttribute("artistFirstName") + " " + (String) session.getAttribute("artistLastName");
                String mobileNo = (String) session.getAttribute("artistMobileNo");
                String email = (String) session.getAttribute("artistEmail");
                String message = (String) request.getAttribute("message");
            %>

            <% if (message != null) { %>
                <div class="success-message alert alert-success">
                    <%= message %>
                </div>
            <% } %>

            <form action="UploadArtworkServlet" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="title"><h3>Title:</h3></label>
                    <input type="text" id="title" name="title" class="form-control" required aria-label="Artwork Title">
                    <span class="note">Please enter a descriptive title for your artwork.</span>
                </div>

                <div class="form-group">
                    <label><h3>Artist Name:</h3></label>
                    <input type="text" id="artistName" name="artistName" class="form-control" value="<%= artistName %>" readonly aria-label="Artist Name">
                </div>

                <div class="form-group">
                    <label for="mobileNo"><h3>Mobile No:</h3></label>
                    <input type="text" id="mobileNo" name="mobileNo" class="form-control" value="<%= mobileNo %>" required aria-label="Artist Mobile No">
                    <span class="error-message" id="mobileNoError">Please enter a valid mobile number.</span>
                    <span class="note">Enter your mobile number.</span>
                </div>

                <div class="form-group">
                    <label for="email"><h3>Email:</h3></label>
                    <input type="email" id="email" name="email" class="form-control" value="<%= email %>" required aria-label="Artist Email">
                    <span class="note">Enter your email address.</span>
                </div>

                <div class="form-group">
                    <label for="socialMedia"><h3>Social Media:</h3></label>
                    <input type="text" id="socialMedia" name="socialMedia" placeholder="Your social media username (optional)" class="form-control" aria-label="Social Media">
                    <span class="note">Optional: Enter your social media handle if you'd like to share it.</span>
                </div>

                <div class="form-group">
                    <label for="description"><h3>Description:</h3></label>
                    <textarea id="description" name="description" class="form-control" required aria-label="Artwork Description"></textarea>
                    <span class="note">Provide a brief description of your artwork.</span>
                </div>

                <div class="form-group">
                    <label for="dateCreated"><h3>Date Created:</h3></label>
                    <input type="date" id="dateCreated" name="dateCreated" class="form-control" required aria-label="Date of Creation">
                    <span class="note">Select the date when you created the artwork.</span>
                </div>

                <div class="form-group">
                    <label for="condition"><h3>Condition:</h3></label>
                    <select id="condition" name="condition" class="form-control" required aria-label="Artwork Condition">
                        <option value="new">New</option>
                        <option value="used">Used</option>
                        <option value="refurbished">Refurbished</option>
                    </select>
                    <span class="note">Choose the condition of the artwork.</span>
                </div>

                <div class="form-group">
                    <label for="image"><h3>Upload Images:</h3></label>
                    <input type="file" id="image" name="image" accept="image/*" required multiple onchange="previewImages(event)" class="form-control"><br/>
                    <div id="imagePreview"></div>
                    <span class="note">Upload up to 3 images of your artwork. You can select multiple files.</span>
                </div>

                <div class="form-group">
                    <label for="forSale"><h3>For Sale:</h3></label>
                    <select id="forSale" name="forSale" class="form-control" aria-label="For Sale Selection" onchange="togglePriceRequired()">
                        <option value="yes">Yes</option>
                        <option value="no">No</option>
                    </select>
                    <span class="note">Indicate whether your artwork is for sale.</span>
                </div>

                <div class="form-group">
                    <label for="price"><h3>Price:</h3></label>
                    <input type="text" id="price" name="price" placeholder="Enter price or 'N/A'" class="form-control" aria-label="Artwork Price" required>
                    <span class="error-message" id="priceError">Please enter a valid price (e.g., 'N/A' or a number).</span>
                    <span class="note">Enter the price in birr of your artwork (or 'N/A' if not applicable).</span>
                </div>

                <div class="form-group">
                    <label for="category"><h3>Category:</h3></label>
                    <select id="category" name="category" class="form-control" required aria-label="Artwork Category">
                        <option value="painting">Painting</option>
                        <option value="sculpture">Sculpture</option>
                        <option value="digital">Digital Art</option>
                        <option value="photography">Photography</option>
                    </select>
                    <span class="note">Select the category that best fits your artwork.</span>
                </div>

                <button type="submit" class="btn btn-primary">Upload Artwork</button>
                <button type="reset" class="btn btn-secondary">Reset Form</button>
            </form>
        </section>
    </main>

    <footer>
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: <a href="mailto:info@artgallery.com" style="color: #f2f2f2;">info@artgallery.com</a></p>
    </footer>
</body>
</html>