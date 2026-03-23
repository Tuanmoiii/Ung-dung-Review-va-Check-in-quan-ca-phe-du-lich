namespace btl_backend.DTOs
{
    public class CreateCheckInDto
    {
        public int CoffeeShopId { get; set; }
        public string? Note { get; set; }
    }

    public class CheckInResponseDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public int CoffeeShopId { get; set; }
        public string CoffeeShopName { get; set; } = string.Empty;
        public string? CoffeeShopImage { get; set; }
        public DateTime CheckInTime { get; set; }
        public int PointsEarned { get; set; }
        public string? Note { get; set; }
    }
}