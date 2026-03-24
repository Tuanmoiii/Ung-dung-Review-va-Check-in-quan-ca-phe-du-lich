namespace btl_backend.DTOs
{
    public class FavoriteResponseDto
    {
        public int Id { get; set; }
        public int CoffeeShopId { get; set; }
        public string CoffeeShopName { get; set; } = string.Empty;
        public string? CoffeeShopImage { get; set; }
        public double Rating { get; set; }
        public string? PriceRange { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}