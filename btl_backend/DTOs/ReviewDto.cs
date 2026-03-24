namespace btl_backend.DTOs
{
    public class CreateReviewDto
    {
        public int UserId { get; set; }  // Thêm dòng này
        public int CoffeeShopId { get; set; }
        public int Rating { get; set; }
        public string Content { get; set; } = string.Empty;
        public List<string>? Images { get; set; }
    }

    public class UpdateReviewDto
    {
        public int Rating { get; set; }
        public string Content { get; set; } = string.Empty;
        public List<string>? Images { get; set; }
    }

    public class ReviewResponseDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string? UserAvatar { get; set; }
        public int CoffeeShopId { get; set; }
        public string CoffeeShopName { get; set; } = string.Empty;
        public int Rating { get; set; }
        public string Content { get; set; } = string.Empty;
        public int Likes { get; set; }
        public bool IsVerified { get; set; }
        public DateTime CreatedAt { get; set; }
        public List<string>? Images { get; set; }
    }
}