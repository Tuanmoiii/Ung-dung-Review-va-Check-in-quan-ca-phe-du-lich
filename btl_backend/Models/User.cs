using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace btl_backend.Models
{
    public class User
    {
        [Key]
        public int Id { get; set; }
        
        [Required, MaxLength(100)]
        public string Username { get; set; } = string.Empty;
        
        [Required, MaxLength(100), EmailAddress]
        public string Email { get; set; } = string.Empty;
        
        [Required]
        public string PasswordHash { get; set; } = string.Empty;
        
        [MaxLength(500)]
        public string? Avatar { get; set; }
        
        [MaxLength(50)]
        public string? Role { get; set; } = "user"; // user, admin
        
        public int Points { get; set; } = 0;
        
        public int TotalVisits { get; set; } = 0;
        
        public int TotalReviews { get; set; } = 0;
        
        [MaxLength(50)]
        public string? MembershipTier { get; set; } = "Bronze"; // Bronze, Silver, Gold
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? LastLoginAt { get; set; }
        
        // Navigation properties
        [JsonIgnore]
        public ICollection<Review>? Reviews { get; set; }
        
        [JsonIgnore]
        public ICollection<CheckIn>? CheckIns { get; set; }
        
        [JsonIgnore]
        public ICollection<Favorite>? Favorites { get; set; }
        
        [JsonIgnore]
        public ICollection<CommunityPost>? CommunityPosts { get; set; }
    }
}