using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace btl_backend.Models
{
    public class Review
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        public int UserId { get; set; }
        
        [Required]
        public int CoffeeShopId { get; set; }
        
        [Range(1, 5)]
        public int Rating { get; set; }
        
        [Required, MaxLength(2000)]
        public string Content { get; set; } = string.Empty;
        
        public string? Images { get; set; } // JSON string for multiple images
        
        public int Likes { get; set; } = 0;
        
        public bool IsVerified { get; set; } = false; // Verified check-in review
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? UpdatedAt { get; set; }
        
        // Navigation properties
        [JsonIgnore]
        public User? User { get; set; }
        
        [JsonIgnore]
        public CoffeeShop? CoffeeShop { get; set; }
    }
}