// Models/Comment.cs
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace btl_backend.Models
{
    public class Comment
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        public int PostId { get; set; }
        
        [Required]
        public int UserId { get; set; }
        
        [Required, MaxLength(1000)]
        public string Content { get; set; } = string.Empty;
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? UpdatedAt { get; set; }
        
        // Navigation properties
        [JsonIgnore]
        public Post? Post { get; set; }
        
        [JsonIgnore]
        public User? User { get; set; }
    }
}