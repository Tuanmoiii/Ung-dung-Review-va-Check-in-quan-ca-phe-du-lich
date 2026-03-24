// Models/DailyCode.cs
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace btl_backend.Models
{
    public class DailyCode
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        public int CoffeeShopId { get; set; }
        
        [Required, MaxLength(10)]
        public string Code { get; set; } = string.Empty;
        
        public DateTime ExpiryDate { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        // Navigation properties
        [JsonIgnore]
        public CoffeeShop? CoffeeShop { get; set; }
    }
}