function toggleDescription(id) { 
    var description = document.getElementById('description_' + id);
    description.style.display = (description.style.display === "none") ? "block" : "none";
}

function submitComment(artworkId) {
    var commentInput = document.getElementById('commentInput_' + artworkId);
    var comment = commentInput.value;

    if (comment) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "submitComment.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onload = function() {
            if (xhr.status == 200) {
                var notification = document.getElementById('notification');
                notification.innerHTML = 'Comment submitted: ' + comment;
                notification.className = 'notification success';
                notification.style.display = 'block';
                commentInput.value = ''; // Clear the input after submission
                loadComments(artworkId); // Reload comments
            } else {
                alert('Error submitting comment: ' + xhr.responseText);
            }
        };
        xhr.send("artworkId=" + artworkId + "&comment=" + encodeURIComponent(comment));
    } else {
        alert('Please enter a comment.');
    }
}
function loadComments(artworkId) {
    // Make an AJAX request to fetch comments for the specific artwork
    fetch('getComments.jsp?artworkId=' + artworkId)
        .then(response => response.text())
        .then(data => {
            // Find the div to display the comments
            const commentsDiv = document.getElementById('comments_' + artworkId);
            commentsDiv.innerHTML = data; // Insert the fetched comments into the div
        })
        .catch(error => {
            console.error('Error fetching comments:', error);
        });
}



// Function to show the reply form
function showReplyForm(commentId) {
    var form = document.getElementById('replyForm_' + commentId);
    form.style.display = (form.style.display === "none") ? "block" : "none";
}

// Function to submit a reply
function submitReply(parentId, artworkId) {
    var replyInput = document.getElementById('replyInput_' + parentId);
    var reply = replyInput.value;

    if (reply) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "submitReply.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onload = function() {
            if (xhr.status == 200) {
                loadComments(artworkId); // Reload comments to include the new reply
                replyInput.value = ''; // Clear the input after submission
            } else {
                alert('Error submitting reply: ' + xhr.responseText);
            }
        };
        xhr.send("parentId=" + parentId + "&reply=" + encodeURIComponent(reply));
    } else {
        alert('Please enter a reply.');
    }
}

// NEW: Function to load replies for a comment (optional, if needed separately)
function loadReplies(commentId) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "getReplies.jsp?commentId=" + commentId, true);
    xhr.onload = function() {
        if (xhr.status == 200) {
            document.getElementById('replies_' + commentId).innerHTML = xhr.responseText;
        } else {
            alert('Error loading replies.');
        }
    };
    xhr.send();
}

function highlightStars(artworkId, rating) {
    var stars = document.querySelectorAll('#stars_' + artworkId + ' .star');
    stars.forEach(function(star, index) {
        star.style.color = index < rating ? 'gold' : 'lightgray'; // Highlight star
    });
}

function resetStars(artworkId) {
    var stars = document.querySelectorAll('#stars_' + artworkId + ' .star');
    stars.forEach(function(star) {
        star.style.color = 'lightgray'; // Reset star color to default
    });
}

function submitRating(artworkId, rating) {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "submitRating.jsp", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onload = function() {
        if (xhr.status == 200) {
            var notificationDiv = document.getElementById('ratingResult_' + artworkId);
            notificationDiv.innerHTML = 'Rating submitted: ' + rating; // Set notification message
            notificationDiv.className = 'rating-notification success'; // Add success class for styling
            notificationDiv.style.display = 'block'; // Ensure it's visible
            
            document.getElementById('currentRating_' + artworkId).innerHTML = 'You rated this artwork: ' + rating; // Display current rating
            updateRatingDisplay(artworkId); // Update the displayed rating
        } else {
            alert('Error submitting rating: ' + xhr.responseText);
        }
    };
    xhr.send("artworkId=" + artworkId + "&rating=" + rating);
}

function updateRatingDisplay(artworkId) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "getRating.jsp?artworkId=" + artworkId, true);
    xhr.onload = function() {
        if (xhr.status == 200) {
            document.getElementById('ratingResult_' + artworkId).innerHTML = xhr.responseText; // Update the rating display
        } else {
            alert('Error loading rating.');
        }
    };
    xhr.send();
}

function shareOnTwitter(title) {
    const url = window.location.href; // Current page URL
    const shareText = 'Check out this artwork: ' + title;
    const twitterUrl = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(shareText) + '&url=' + encodeURIComponent(url) + '&via=YourArtGalleryHandle'; // Replace with your Twitter handle
    window.open(twitterUrl, '_blank');
}

function shareOnFacebook(title) {
    const url = window.location.href; // Current page URL
    const facebookUrl = 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(url);
    window.open(facebookUrl, '_blank');
}

// Autocomplete Functionality
document.getElementById('searchInput').addEventListener('input', function() {
    const query = this.value;

    if (query.length > 1) { // Start searching after 2 characters
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "autocomplete.jsp?query=" + encodeURIComponent(query), true);
        xhr.onload = function() {
            if (xhr.status == 200) {
                const suggestions = JSON.parse(xhr.responseText);
                displaySuggestions(suggestions);
            }
        };
        xhr.send();
    } else {
        document.getElementById('suggestions').innerHTML = ''; // Clear suggestions
    }
});

function displaySuggestions(suggestions) {
    const suggestionsContainer = document.getElementById('suggestions');
    suggestionsContainer.innerHTML = ''; // Clear previous suggestions

    suggestions.forEach(function(item) {
        const suggestionItem = document.createElement('div');
        suggestionItem.innerHTML = item; // Display the suggestion
        suggestionItem.onclick = function() {
            document.getElementById('searchInput').value = item; // Set the input value
            suggestionsContainer.innerHTML = ''; // Clear suggestions
        };
        suggestionsContainer.appendChild(suggestionItem);
    });
}

window.onload = function() {
    document.querySelectorAll('.artwork').forEach(function(artwork) {
        var artworkId = artwork.getAttribute('data-artwork-id');
        loadComments(artworkId); // Load comments for each artwork
        updateRatingDisplay(artworkId); // Load ratings for each artwork
    });

    setTimeout(function() {
        document.getElementById('loginMessage').style.display = 'none';
        document.getElementById('greetingMessage').style.display = 'none';
    }, 5000); // 5000ms = 5 seconds
    
};
