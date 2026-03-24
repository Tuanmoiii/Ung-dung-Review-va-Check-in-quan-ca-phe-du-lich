// Models/Post.cs
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace btl_backend.Models
{
    public class Post
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        public int UserId { get; set; }
        
        [Required, MaxLength(2000)]
        public string Content { get; set; } = string.Empty;
        
        public string? Images { get; set; } // JSON string for multiple images
        
        public int? CoffeeShopId { get; set; } // Optional - can tag a coffee shop
        
        public int Likes { get; set; } = 0;
        
        public int Comment { get; set; } = 0;
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? UpdatedAt { get; set; }
        
        // Navigation properties
        [JsonIgnore]
        public User? User { get; set; }
        
        [JsonIgnore]
        public CoffeeShop? CoffeeShop { get; set; }
        public ICollection<Comment>? Comments { get; set; }
    }
}