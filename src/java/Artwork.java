
import java.math.BigDecimal;
import java.util.Date;

public class Artwork {
    private int id;
    private String title;
    private String artistName;
    private String mobileNo;
    private String email;
    private String socialMedia;
    private String description;
    private Date dateCreated;
    private String condition; // 'new', 'used', or 'refurbished'
    private byte[] image;
    private String videoLink;
    private String forSale; // 'yes' or 'no'
    private BigDecimal price; // Using BigDecimal for monetary values
    private String category; // 'painting', 'sculpture', 'digital', 'photography'

    // Constructor
    public Artwork(int id, String title, String artistName, String mobileNo, String email,
                   String socialMedia, String description, Date dateCreated, String condition,
                   byte[] image, String videoLink, String forSale, BigDecimal price, String category) {
        this.id = id;
        this.title = title;
        this.artistName = artistName;
        this.mobileNo = mobileNo;
        this.email = email;
        this.socialMedia = socialMedia;
        this.description = description;
        this.dateCreated = dateCreated;
        this.condition = condition;
        this.image = image;
        this.videoLink = videoLink;
        this.forSale = forSale;
        this.price = price;
        this.category = category;
    }

    // Getters and Setters
    // (You can generate these using your IDE or write them manually)

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getArtistName() {
        return artistName;
    }

    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSocialMedia() {
        return socialMedia;
    }

    public void setSocialMedia(String socialMedia) {
        this.socialMedia = socialMedia;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
    }

    public String getForSale() {
        return forSale;
    }

    public void setForSale(String forSale) {
        this.forSale = forSale;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}