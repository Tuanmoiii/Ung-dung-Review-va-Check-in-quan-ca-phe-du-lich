using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using btl_backend.Data;
using btl_backend.Models;
using btl_backend.DTOs;
using System.Text.Json;

namespace btl_backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CoffeeShopsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CoffeeShopsController> _logger;

        public CoffeeShopsController(ApplicationDbContext context, ILogger<CoffeeShopsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // GET: api/coffeeshops
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CoffeeShopDto>>> GetCoffeeShops(
            [FromQuery] string? city = null,
            [FromQuery] bool? featured = null,
            [FromQuery] string? tag = null)
        {
            var query = _context.CoffeeShops.AsQueryable();

            // Filter by city
            if (!string.IsNullOrEmpty(city))
            {
                query = query.Where(c => c.City != null && c.City.Contains(city));
            }

            // Filter by featured
            if (featured.HasValue)
            {
                query = query.Where(c => c.IsFeatured == featured.Value);
            }

            // Filter by tag
            if (!string.IsNullOrEmpty(tag))
            {
                query = query.Where(c => c.Tags != null && c.Tags.Contains(tag));
            }

            // Lấy dữ liệu trước
            var coffeeShops = await query
                .OrderByDescending(c => c.Rating)
                .Select(c => new
                {
                    c.Id,
                    c.Name,
                    c.Description,
                    c.Address,
                    c.City,
                    c.Latitude,
                    c.Longitude,
                    c.ImageUrl,
                    c.Rating,
                    c.TotalReviews,
                    c.TotalCheckIns,
                    c.PriceRange,
                    c.OpeningHours,
                    c.IsVerified,
                    c.IsFeatured,
                    c.Tags,
                    c.Amenities
                })
                .ToListAsync();

            // Xử lý JSON ở đây (sau khi đã lấy dữ liệu về)
            var result = coffeeShops.Select(c => new CoffeeShopDto
            {
                Id = c.Id,
                Name = c.Name,
                Description = c.Description,
                Address = c.Address,
                City = c.City,
                Latitude = c.Latitude,
                Longitude = c.Longitude,
                ImageUrl = c.ImageUrl,
                Rating = c.Rating,
                TotalReviews = c.TotalReviews,
                TotalCheckIns = c.TotalCheckIns,
                PriceRange = c.PriceRange,
                OpeningHours = c.OpeningHours,
                IsVerified = c.IsVerified,
                IsFeatured = c.IsFeatured,
                Tags = string.IsNullOrEmpty(c.Tags) ? null : JsonSerializer.Deserialize<List<string>>(c.Tags),
                Amenities = string.IsNullOrEmpty(c.Amenities) ? null : JsonSerializer.Deserialize<List<string>>(c.Amenities)
            }).ToList();

            return Ok(result);
        }

        // GET: api/coffeeshops/trending
        [HttpGet("trending")]
        public async Task<ActionResult<IEnumerable<CoffeeShopDto>>> GetTrendingShops([FromQuery] int limit = 5)
        {
            var coffeeShops = await _context.CoffeeShops
                .Where(c => c.IsFeatured == true)
                .OrderByDescending(c => c.Rating)
                .Take(limit)
                .Select(c => new
                {
                    c.Id,
                    c.Name,
                    c.Description,
                    c.Address,
                    c.City,
                    c.Latitude,
                    c.Longitude,
                    c.ImageUrl,
                    c.Rating,
                    c.TotalReviews,
                    c.TotalCheckIns,
                    c.PriceRange,
                    c.IsVerified,
                    c.IsFeatured,
                    c.Tags
                })
                .ToListAsync();

            var result = coffeeShops.Select(c => new CoffeeShopDto
            {
                Id = c.Id,
                Name = c.Name,
                Description = c.Description,
                Address = c.Address,
                City = c.City,
                Latitude = c.Latitude,
                Longitude = c.Longitude,
                ImageUrl = c.ImageUrl,
                Rating = c.Rating,
                TotalReviews = c.TotalReviews,
                TotalCheckIns = c.TotalCheckIns,
                PriceRange = c.PriceRange,
                IsVerified = c.IsVerified,
                IsFeatured = c.IsFeatured,
                Tags = string.IsNullOrEmpty(c.Tags) ? null : JsonSerializer.Deserialize<List<string>>(c.Tags)
            }).ToList();

            return Ok(result);
        }

        // GET: api/coffeeshops/nearby
        [HttpGet("nearby")]
        public async Task<ActionResult<IEnumerable<CoffeeShopDto>>> GetNearbyShops(
            [FromQuery] double lat,
            [FromQuery] double lng,
            [FromQuery] double radius = 5)
        {
            var coffeeShops = await _context.CoffeeShops
                .Select(c => new
                {
                    c.Id,
                    c.Name,
                    c.Description,
                    c.Address,
                    c.City,
                    c.Latitude,
                    c.Longitude,
                    c.ImageUrl,
                    c.Rating,
                    c.TotalReviews,
                    c.TotalCheckIns,
                    c.PriceRange,
                    c.IsVerified,
                    c.IsFeatured,
                    c.Tags
                })
                .ToListAsync();

            var nearby = coffeeShops
                .Where(c => CalculateDistance(lat, lng, c.Latitude, c.Longitude) <= radius)
                .OrderBy(c => CalculateDistance(lat, lng, c.Latitude, c.Longitude))
                .Select(c => new CoffeeShopDto
                {
                    Id = c.Id,
                    Name = c.Name,
                    Description = c.Description,
                    Address = c.Address,
                    City = c.City,
                    Latitude = c.Latitude,
                    Longitude = c.Longitude,
                    ImageUrl = c.ImageUrl,
                    Rating = c.Rating,
                    TotalReviews = c.TotalReviews,
                    TotalCheckIns = c.TotalCheckIns,
                    PriceRange = c.PriceRange,
                    IsVerified = c.IsVerified,
                    IsFeatured = c.IsFeatured,
                    Tags = string.IsNullOrEmpty(c.Tags) ? null : JsonSerializer.Deserialize<List<string>>(c.Tags)
                })
                .ToList();

            return Ok(nearby);
        }

        // GET: api/coffeeshops/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<CoffeeShopDetailDto>> GetCoffeeShop(int id)
        {
            var coffeeShop = await _context.CoffeeShops
                .Include(c => c.Reviews)
                    .ThenInclude(r => r.User)
                .FirstOrDefaultAsync(c => c.Id == id);

            if (coffeeShop == null)
            {
                return NotFound(new { message = "Coffee shop not found" });
            }

            // Get recent reviews - lấy về rồi xử lý
            var recentReviews = coffeeShop.Reviews?
                .OrderByDescending(r => r.CreatedAt)
                .Take(5)
                .Select(r => new ReviewDto
                {
                    Id = r.Id,
                    UserId = r.UserId,
                    UserName = r.User?.Username,
                    UserAvatar = r.User?.Avatar,
                    Rating = r.Rating,
                    Content = r.Content,
                    Likes = r.Likes,
                    IsVerified = r.IsVerified,
                    CreatedAt = r.CreatedAt,
                    Images = string.IsNullOrEmpty(r.Images) ? null : JsonSerializer.Deserialize<List<string>>(r.Images)
                })
                .ToList() ?? new List<ReviewDto>();

            var result = new CoffeeShopDetailDto
            {
                Id = coffeeShop.Id,
                Name = coffeeShop.Name,
                Description = coffeeShop.Description,
                Address = coffeeShop.Address,
                City = coffeeShop.City,
                Latitude = coffeeShop.Latitude,
                Longitude = coffeeShop.Longitude,
                ImageUrl = coffeeShop.ImageUrl,
                Rating = coffeeShop.Rating,
                TotalReviews = coffeeShop.TotalReviews,
                TotalCheckIns = coffeeShop.TotalCheckIns,
                PriceRange = coffeeShop.PriceRange,
                OpeningHours = coffeeShop.OpeningHours,
                IsVerified = coffeeShop.IsVerified,
                IsFeatured = coffeeShop.IsFeatured,
                Tags = string.IsNullOrEmpty(coffeeShop.Tags) ? null : JsonSerializer.Deserialize<List<string>>(coffeeShop.Tags),
                Amenities = string.IsNullOrEmpty(coffeeShop.Amenities) ? null : JsonSerializer.Deserialize<List<string>>(coffeeShop.Amenities),
                GalleryImages = string.IsNullOrEmpty(coffeeShop.GalleryImages) ? null : JsonSerializer.Deserialize<List<string>>(coffeeShop.GalleryImages),
                RecentReviews = recentReviews
            };

            return Ok(result);
        }

        // GET: api/coffeeshops/search?q=keyword
        [HttpGet("search")]
        public async Task<ActionResult<IEnumerable<CoffeeShopDto>>> SearchShops([FromQuery] string q)
        {
            if (string.IsNullOrWhiteSpace(q))
            {
                return BadRequest(new { message = "Search keyword is required" });
            }

            var coffeeShops = await _context.CoffeeShops
                .Where(c => c.Name.Contains(q) || 
                            c.Description.Contains(q) || 
                            (c.City != null && c.City.Contains(q)) ||
                            (c.Tags != null && c.Tags.Contains(q)))
                .OrderByDescending(c => c.Rating)
                .Select(c => new
                {
                    c.Id,
                    c.Name,
                    c.Description,
                    c.Address,
                    c.City,
                    c.Latitude,
                    c.Longitude,
                    c.ImageUrl,
                    c.Rating,
                    c.TotalReviews,
                    c.TotalCheckIns,
                    c.PriceRange,
                    c.IsVerified,
                    c.IsFeatured,
                    c.Tags
                })
                .ToListAsync();

            var result = coffeeShops.Select(c => new CoffeeShopDto
            {
                Id = c.Id,
                Name = c.Name,
                Description = c.Description,
                Address = c.Address,
                City = c.City,
                Latitude = c.Latitude,
                Longitude = c.Longitude,
                ImageUrl = c.ImageUrl,
                Rating = c.Rating,
                TotalReviews = c.TotalReviews,
                TotalCheckIns = c.TotalCheckIns,
                PriceRange = c.PriceRange,
                IsVerified = c.IsVerified,
                IsFeatured = c.IsFeatured,
                Tags = string.IsNullOrEmpty(c.Tags) ? null : JsonSerializer.Deserialize<List<string>>(c.Tags)
            }).ToList();

            return Ok(result);
        }

        // Helper method to calculate distance
        private double CalculateDistance(double lat1, double lon1, double lat2, double lon2)
        {
            const double R = 6371;
            var dLat = ToRadians(lat2 - lat1);
            var dLon = ToRadians(lon2 - lon1);
            var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                    Math.Cos(ToRadians(lat1)) * Math.Cos(ToRadians(lat2)) *
                    Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
            var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            return R * c;
        }

        private double ToRadians(double degrees)
        {
            return degrees * Math.PI / 180;
        }
    }
}