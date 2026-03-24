// DTOs/PostDto.cs
namespace btl_backend.DTOs
{
    public class CreatePostDto
    {
        public int UserId { get; set; }
        public string Content { get; set; } = string.Empty;
        public List<string>? Images { get; set; }
        public int? CoffeeShopId { get; set; }
    }

    public class UpdatePostDto
    {
        public string Content { get; set; } = string.Empty;
        public List<string>? Images { get; set; }
        public int? CoffeeShopId { get; set; }
    }

    public class PostResponseDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string? UserAvatar { get; set; }
        public string Content { get; set; } = string.Empty;
        public List<string>? Images { get; set; }
        public int? CoffeeShopId { get; set; }
        public string? CoffeeShopName { get; set; }
        public int Likes { get; set; }
        public int Comments { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
    }
}