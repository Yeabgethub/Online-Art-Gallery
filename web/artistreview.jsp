<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Preview Artwork Submission</title>
    <link rel="stylesheet" href="css/artistfrontpage.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }

        .preview {
            border: 1px solid #ccc;
            padding: 10px;
            margin-top: 20px;
            border-radius: 5px;
        }

        .image-preview {
            display: flex;
            flex-wrap: wrap;
            margin-top: 10px;
        }

        .image-preview img {
            max-width: 100px;
            margin-right: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            margin-top: 15px;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }

        .note {
            font-size: 0.9em;
            color: #555;
            margin-top: 5px;
        }

        .error-message {
            color: red;
            display: none;
        }

        .success-message {
            color: white;
            display: block; /* Ensure it's displayed */
        }
    </style>
    <script>
        function showPreview() {
            const title = document.getElementById('title').value;
            const artistName = document.getElementById('artistName').value;
            const mobileNo = document.getElementById('mobileNo').value;
            const email = document.getElementById('email').value;
            const socialMedia = document.getElementById('socialMedia').value;
            const description = document.getElementById('description').value;
            const dateCreated = document.getElementById('dateCreated').value;
            const condition = document.getElementById('condition').value;
            const forSale = document.getElementById('forSale').value;
            const price = document.getElementById('price').value;
            const category = document.getElementById('category').value;

            // Displaying the preview
            document.getElementById('previewTitle').innerText = title;
            document.getElementById('previewArtistName').innerText = artistName;
            document.getElementById('previewMobileNo').innerText = mobileNo;
            document.getElementById('previewEmail').innerText = email;
            document.getElementById('previewSocialMedia').innerText = socialMedia;
            document.getElementById('previewDescription').innerText = description;
            document.getElementById('previewDateCreated').innerText = dateCreated;
            document.getElementById('previewCondition').innerText = condition;
            document.getElementById('previewForSale').innerText = forSale;
            document.getElementById('previewPrice').innerText = price;
            document.getElementById('previewCategory').innerText = category;

            const imageFiles = document.getElementById('image').files;
            const imagePreviewContainer = document.getElementById('imagePreview');
            imagePreviewContainer.innerHTML = ''; // Clear previous previews

            for (let i = 0; i < imageFiles.length; i++) {
                const img = document.createElement('img');
                img.src = URL.createObjectURL(imageFiles[i]);
                img.alt = "Image Preview";
                imagePreviewContainer.appendChild(img);

                // Revoke the object URL after the image loads
                img.onload = () => {
                    URL.revokeObjectURL(img.src); // Free memory
                };
            }
        }
    </script>
</head>

<body>
    <header>
        <h1>Preview Your Artwork Submission</h1>
    </header>

    <main>
        <section class="preview-artwork">
            <h2>Preview</h2>
            <div class="preview">
                <strong>Title:</strong> <span id="previewTitle"><%= request.getParameter("title") %></span><br>
                <strong>Artist Name:</strong> <span id="previewArtistName"><%= request.getParameter("artistName") %></span><br>
                <strong>Mobile No:</strong> <span id="previewMobileNo"><%= request.getParameter("mobileNo") %></span><br>
                <strong>Email:</strong> <span id="previewEmail"><%= request.getParameter("email") %></span><br>
                <strong>Social Media:</strong> <span id="previewSocialMedia"><%= request.getParameter("socialMedia") %></span><br>
                <strong>Description:</strong> <span id="previewDescription"><%= request.getParameter("description") %></span><br>
                <strong>Date Created:</strong> <span id="previewDateCreated"><%= request.getParameter("dateCreated") %></span><br>
                <strong>Condition:</strong> <span id="previewCondition"><%= request.getParameter("condition") %></span><br>
                <strong>For Sale:</strong> <span id="previewForSale"><%= request.getParameter("forSale") %></span><br>
                <strong>Price:</strong> <span id="previewPrice"><%= request.getParameter("price") %></span><br>
                <strong>Category:</strong> <span id="previewCategory"><%= request.getParameter("category") %></span><br>
                
                <strong>Uploaded Images:</strong>
                <div class="image-preview" id="imagePreview">
                    <%
                        String[] imageFiles = request.getParameterValues("imageFiles");
                        if (imageFiles != null) {
                            for (String imageFile : imageFiles) {
                    %>
                                <img src="<%= imageFile %>" alt="Image Preview">
                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <!-- Back and Submit buttons -->
            <form action="UploadArtworkServlet" method="post" enctype="multipart/form-data" onsubmit="showPreview()">
                <input type="hidden" name="title" value="<%= request.getParameter("title") %>">
                <input type="hidden" name="artistName" value="<%= request.getParameter("artistName") %>">
                <input type="hidden" name="mobileNo" value="<%= request.getParameter("mobileNo") %>">
                <input type="hidden" name="email" value="<%= request.getParameter("email") %>">
                <input type="hidden" name="socialMedia" value="<%= request.getParameter("socialMedia") %>">
                <input type="hidden" name="description" value="<%= request.getParameter("description") %>">
                <input type="hidden" name="dateCreated" value="<%= request.getParameter("dateCreated") %>">
                <input type="hidden" name="condition" value="<%= request.getParameter("condition") %>">
                <input type="hidden" name="forSale" value="<%= request.getParameter("forSale") %>">
                <input type="hidden" name="price" value="<%= request.getParameter("price") %>">
                <input type="hidden" name="category" value="<%= request.getParameter("category") %>">
                
                <!-- Hidden inputs to pass image file paths -->
                <input type="hidden" name="imageFiles" value="<%= String.join(",", request.getParameterValues("imageFiles")) %>">

                <button type="submit">Confirm Submission</button>
                <button type="button" onclick="window.history.back();">Back</button>
            </form>
        </section>
    </main>

    <footer>
        <p>&copy; 2024 Online Art Gallery. All rights reserved.</p>
        <p>Contact us: <a href="mailto:info@artgallery.com" style="color: #f2f2f2;">info@artgallery.com</a></p>
    </footer>
</body>

</html>