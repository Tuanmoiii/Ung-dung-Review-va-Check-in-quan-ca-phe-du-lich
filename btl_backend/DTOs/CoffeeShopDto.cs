namespace btl_backend.DTOs
{
    public class CoffeeShopDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public string? City { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string? ImageUrl { get; set; }
        public double Rating { get; set; }
        public int TotalReviews { get; set; }
        public int TotalCheckIns { get; set; }
        public string? PriceRange { get; set; }
        public string? OpeningHours { get; set; }
        public bool IsVerified { get; set; }
        public bool IsFeatured { get; set; }
        public List<string>? Tags { get; set; }
        public List<string>? Amenities { get; set; }
    }

    public class CoffeeShopDetailDto : CoffeeShopDto
    {
        public List<ReviewDto>? RecentReviews { get; set; }
        public List<string>? GalleryImages { get; set; }
    }

    public class ReviewDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string? UserName { get; set; }
        public string? UserAvatar { get; set; }
        public int Rating { get; set; }
        public string Content { get; set; } = string.Empty;
        public int Likes { get; set; }
        public bool IsVerified { get; set; }
        public DateTime CreatedAt { get; set; }
        public List<string>? Images { get; set; }
    }
}