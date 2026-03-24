using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace btl_backend.Models
{
    public class CommunityPost
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required, MaxLength(2000)]
        public string Content { get; set; } = string.Empty;

        public string? Images { get; set; } // JSON string for multiple images

        public string? VenueName { get; set; } // Optional venue name

        public int Likes { get; set; } = 0;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime? UpdatedAt { get; set; }

        // Navigation properties
        [JsonIgnore]
        public User? User { get; set; }
    }
}