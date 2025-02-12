<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Artist Sign-Up</title>
    <link href='https://fonts.googleapis.com/css?family=Titillium+Web:400,300,600' rel='stylesheet'>
    <link rel="stylesheet" href="css/style.css">
    <script src='https://code.jquery.com/jquery-3.6.0.min.js'></script>
    <script>
        function validateForm() {
            const firstName = document.forms["signupForm"]["firstName"].value;
            const lastName = document.forms["signupForm"]["lastName"].value;
            const address = document.forms["signupForm"]["address"].value;
            const mobileNo = document.forms["signupForm"]["mobileno"].value;
            const email = document.forms["signupForm"]["email"].value;
            const password = document.forms["signupForm"]["password"].value;
            const confirmPassword = document.forms["signupForm"]["confirmPassword"].value;

            // Check for empty fields
            if (!firstName || !lastName || !address || !mobileNo || !email || !password || !confirmPassword) {
                alert("All fields are required.");
                return false;
            }

            // Mobile number validation
            const mobilePattern = /^09[0-9]{8}$/;
            if (!mobilePattern.test(mobileNo)) {
                alert("Invalid mobile number format. Must start with '09' and be followed by 8 digits.");
                return false;
            }

            // Password length check
            if (password.length < 6) {
                alert("Password must be at least 6 characters long.");
                return false;
            }

            // Password match check
            if (password !== confirmPassword) {
                alert("Passwords do not match.");
                return false;
            }

            return true;
        }

        $(document).ready(function () {
            // Prevent form submission if validation fails
            $('#signupForm').on('submit', function (e) {
                if (!validateForm()) {
                    e.preventDefault();
                }
            });

            // Image preview functionality
            $('input[name="profileImage"]').on('change', function () {
                var fileName = $(this).val().split('\\').pop();
                $('#image-preview').text('Selected file: ' + fileName);
            });
        });

        // Function to display error messages
        function displayErrorMessage(message) {
            const errorMessageDiv = document.getElementById("error-message");
            errorMessageDiv.innerText = message;
            errorMessageDiv.style.display = "block";
        }
    </script>
</head>

<body>
    <h2>Online Art Gallery</h2>
    <div class="form">
        <div id="signup">
            <h1>Sign Up for Free</h1>
            <div id="error-message" style="color: red; display: none;"></div>

            <form id="signupForm" name="signupForm" action="ArtistSignupServlet" method="post" enctype="multipart/form-data">
                <div class="field-wrap">
                    <label>First Name<span class="req">*</span></label>
                    <input type="text" name="firstName" required autocomplete="off" />
                </div>
                <div class="field-wrap">
                    <label>Last Name<span class="req">*</span></label>
                    <input type="text" name="lastName" required autocomplete="off" />
                </div>
                <div class="field-wrap">
                    <label>Address<span class="req">*</span></label>
                    <input type="text" name="address" required autocomplete="off" />
                </div>
                <div class="field-wrap">
                    <label>Mobile No:<span class="req">*</span></label>
                    <input type="text" name="mobileno" required autocomplete="off" />
                    <small style="color: red;">Format: 09XXXXXXXX</small>
                </div>
                <div class="field-wrap">
                    <label>Email<span class="req">*</span></label>
                    <input type="email" name="email" required autocomplete="off" />
                </div>
                <div class="field-wrap">
                    <label>Password<span class="req">*</span></label>
                    <input type="password" name="password" required autocomplete="off" />
                </div>
                <div class="field-wrap">
                    <label>Confirm Password<span class="req">*</span></label>
                    <input type="password" name="confirmPassword" required autocomplete="off" />
                </div>
                <div class="field-wrap">
                    <label>Profile Image<span class="req">*</span></label>
                    <input type="file" name="profileImage" accept="image/*" required />
                    <div id="image-preview" style="margin-top: 10px;"></div>
                </div>
                <button type="submit" class="button">Get Started</button>
            </form>
            <script>
                // Check for error messages passed via URL parameters
                const urlParams = new URLSearchParams(window.location.search);
                const error = urlParams.get('error');
                if (error) {
                    displayErrorMessage(error);
                }
            </script>
        </div>
    </div>
</body>

</html>