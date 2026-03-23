using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace btl_backend.Models
{
    public class Favorite
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        public int UserId { get; set; }
        
        [Required]
        public int CoffeeShopId { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        // Navigation properties
        [JsonIgnore]
        public User? User { get; set; }
        
        [JsonIgnore]
        public CoffeeShop? CoffeeShop { get; set; }
    }
}