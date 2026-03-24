// DTOs/DailyCodeDto.cs
namespace btl_backend.DTOs
{
    public class ValidateCodeDto
    {
        public int CoffeeShopId { get; set; }
        public string Code { get; set; } = string.Empty;
    }
    
    public class DailyCodeResponseDto
    {
        public int Id { get; set; }
        public int CoffeeShopId { get; set; }
        public string Code { get; set; } = string.Empty;
        public DateTime ExpiryDate { get; set; }
        public bool IsActive { get; set; }
    }
}