using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace btl_backend.Models
{
    public class CoffeeShop
    {
        [Key]
        public int Id { get; set; }
        
        [Required, MaxLength(200)]
        public string Name { get; set; } = string.Empty;
        
        [Required]
        public string Description { get; set; } = string.Empty;
        
        [Required, MaxLength(500)]
        public string Address { get; set; } = string.Empty;
        
        [MaxLength(50)]
        public string? City { get; set; }
        
        public double Latitude { get; set; }
        
        public double Longitude { get; set; }
        
        [MaxLength(500)]
        public string? ImageUrl { get; set; }
        
        public string? GalleryImages { get; set; } // JSON string for multiple images
        
        public double Rating { get; set; } = 0;
        
        public int TotalReviews { get; set; } = 0;
        
        public int TotalCheckIns { get; set; } = 0;
        
        [MaxLength(20)]
        public string? PriceRange { get; set; } // $, $$, $$$
        
        [MaxLength(500)]
        public string? OpeningHours { get; set; } // JSON string or formatted text
        
        public bool IsVerified { get; set; } = false;
        
        public bool IsFeatured { get; set; } = false;
        
        public string? Tags { get; set; } // JSON string for tags like "Aesthetic", "Quiet", "WiFi"
        
        public string? Amenities { get; set; } // JSON string for amenities
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        // Navigation properties
        [JsonIgnore]
        public ICollection<Review>? Reviews { get; set; }
        
        [JsonIgnore]
        public ICollection<CheckIn>? CheckIns { get; set; }
        
        [JsonIgnore]
        public ICollection<Favorite>? Favorites { get; set; }

        [JsonIgnore]
        public ICollection<DailyCode>? DailyCodes { get; set; }

    }
}