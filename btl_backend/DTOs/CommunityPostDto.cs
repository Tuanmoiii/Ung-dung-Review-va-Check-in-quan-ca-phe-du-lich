namespace btl_backend.DTOs
{
    public class CreateCommunityPostDto
    {
        public int UserId { get; set; }
        public string Content { get; set; } = string.Empty;
        public List<string>? Images { get; set; }
        public string? VenueName { get; set; }
    }

    public class UpdateCommunityPostDto
    {
        public string Content { get; set; } = string.Empty;
        public List<string>? Images { get; set; }
        public string? VenueName { get; set; }
    }

    public class CommunityPostResponseDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string? UserAvatar { get; set; }
        public string Content { get; set; } = string.Empty;
        public List<string>? Images { get; set; }
        public string? VenueName { get; set; }
        public int Likes { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}