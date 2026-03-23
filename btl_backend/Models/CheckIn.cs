using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace btl_backend.Models
{
    public class CheckIn
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        public int UserId { get; set; }
        
        [Required]
        public int CoffeeShopId { get; set; }
        
        public DateTime CheckInTime { get; set; } = DateTime.UtcNow;
        
        public int PointsEarned { get; set; } = 10; // Default points per check-in
        
        public string? Note { get; set; }
        
        // Navigation properties
        [JsonIgnore]
        public User? User { get; set; }
        
        [JsonIgnore]
        public CoffeeShop? CoffeeShop { get; set; }
    }
}