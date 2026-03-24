using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using btl_backend.Data;
using btl_backend.Models;
using btl_backend.DTOs;

namespace btl_backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReviewsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<ReviewsController> _logger;

        public ReviewsController(ApplicationDbContext context, ILogger<ReviewsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // GET: api/reviews/coffeeshop/{coffeeShopId}
        [HttpGet("coffeeshop/{coffeeShopId}")]
        public async Task<ActionResult<IEnumerable<ReviewResponseDto>>> GetReviewsByCoffeeShop(
            int coffeeShopId, 
            [FromQuery] int page = 1, 
            [FromQuery] int pageSize = 10)
        {
            // Lấy dữ liệu trước (không xử lý JSON)
            var reviewsData = await _context.Reviews
                .Include(r => r.User)
                .Where(r => r.CoffeeShopId == coffeeShopId)
                .OrderByDescending(r => r.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(r => new
                {
                    r.Id,
                    r.UserId,
                    UserName = r.User != null ? r.User.Username : "Unknown",
                    UserAvatar = r.User != null ? r.User.Avatar : null,
                    r.CoffeeShopId,
                    r.Rating,
                    r.Content,
                    r.Likes,
                    r.IsVerified,
                    r.CreatedAt,
                    r.Images
                })
                .ToListAsync();

            // Xử lý JSON ở đây (sau khi đã lấy dữ liệu về)
            var reviews = reviewsData.Select(r => new ReviewResponseDto
            {
                Id = r.Id,
                UserId = r.UserId,
                UserName = r.UserName,
                UserAvatar = r.UserAvatar,
                CoffeeShopId = r.CoffeeShopId,
                CoffeeShopName = "",
                Rating = r.Rating,
                Content = r.Content,
                Likes = r.Likes,
                IsVerified = r.IsVerified,
                CreatedAt = r.CreatedAt,
                Images = string.IsNullOrEmpty(r.Images) ? null : JsonSerializer.Deserialize<List<string>>(r.Images)
            }).ToList();

            var totalCount = await _context.Reviews.CountAsync(r => r.CoffeeShopId == coffeeShopId);
            Response.Headers.Add("X-Total-Count", totalCount.ToString());

            return Ok(reviews);
        }

        // GET: api/reviews/user/{userId}
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<ReviewResponseDto>>> GetReviewsByUser(int userId)
        {
            // Lấy dữ liệu trước (không xử lý JSON)
            var reviewsData = await _context.Reviews
                .Include(r => r.User)
                .Include(r => r.CoffeeShop)
                .Where(r => r.UserId == userId)
                .OrderByDescending(r => r.CreatedAt)
                .Select(r => new
                {
                    r.Id,
                    r.UserId,
                    UserName = r.User != null ? r.User.Username : "Unknown",
                    UserAvatar = r.User != null ? r.User.Avatar : null,
                    r.CoffeeShopId,
                    CoffeeShopName = r.CoffeeShop != null ? r.CoffeeShop.Name : "Unknown",
                    r.Rating,
                    r.Content,
                    r.Likes,
                    r.IsVerified,
                    r.CreatedAt,
                    r.Images
                })
                .ToListAsync();

            // Xử lý JSON ở đây
            var reviews = reviewsData.Select(r => new ReviewResponseDto
            {
                Id = r.Id,
                UserId = r.UserId,
                UserName = r.UserName,
                UserAvatar = r.UserAvatar,
                CoffeeShopId = r.CoffeeShopId,
                CoffeeShopName = r.CoffeeShopName,
                Rating = r.Rating,
                Content = r.Content,
                Likes = r.Likes,
                IsVerified = r.IsVerified,
                CreatedAt = r.CreatedAt,
                Images = string.IsNullOrEmpty(r.Images) ? null : JsonSerializer.Deserialize<List<string>>(r.Images)
            }).ToList();

            return Ok(reviews);
        }

        // POST: api/reviews
        [HttpPost]
        public async Task<ActionResult<ReviewResponseDto>> CreateReview(CreateReviewDto createDto)
        {
            // SỬA: Lấy userId từ DTO thay vì hardcode
            var userId = createDto.UserId;

            var coffeeShop = await _context.CoffeeShops.FindAsync(createDto.CoffeeShopId);
            if (coffeeShop == null)
            {
                return NotFound(new { message = "Coffee shop not found" });
            }

            // Check if user already reviewed this shop
            var existingReview = await _context.Reviews
                .FirstOrDefaultAsync(r => r.UserId == userId && r.CoffeeShopId == createDto.CoffeeShopId);
            
            if (existingReview != null)
            {
                return BadRequest(new { message = "You have already reviewed this coffee shop" });
            }

            var review = new Review
            {
                UserId = userId,
                CoffeeShopId = createDto.CoffeeShopId,
                Rating = createDto.Rating,
                Content = createDto.Content,
                Images = createDto.Images != null && createDto.Images.Any() ? JsonSerializer.Serialize(createDto.Images) : null,
                IsVerified = false,
                CreatedAt = DateTime.UtcNow
            };

            _context.Reviews.Add(review);
            
            // Update coffee shop stats
            coffeeShop.TotalReviews++;
            var avgRating = await _context.Reviews
                .Where(r => r.CoffeeShopId == coffeeShop.Id)
                .AverageAsync(r => (double)r.Rating);
            coffeeShop.Rating = avgRating;

            // Update user stats
            var user = await _context.Users.FindAsync(userId);
            if (user != null)
            {
                user.TotalReviews++;
            }

            await _context.SaveChangesAsync();

            var response = new ReviewResponseDto
            {
                Id = review.Id,
                UserId = review.UserId,
                UserName = user?.Username ?? "Unknown",
                CoffeeShopId = review.CoffeeShopId,
                CoffeeShopName = coffeeShop.Name,
                Rating = review.Rating,
                Content = review.Content,
                Likes = review.Likes,
                IsVerified = review.IsVerified,
                CreatedAt = review.CreatedAt,
                Images = createDto.Images
            };

            return CreatedAtAction(nameof(GetReviewsByCoffeeShop), new { coffeeShopId = review.CoffeeShopId }, response);
        }

        // PUT: api/reviews/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult<ReviewResponseDto>> UpdateReview(int id, UpdateReviewDto updateDto)
        {
            var review = await _context.Reviews.FindAsync(id);
            
            if (review == null)
            {
                return NotFound(new { message = "Review not found" });
            }

            // TODO: Check if user owns this review (from JWT)
            
            review.Rating = updateDto.Rating;
            review.Content = updateDto.Content;
            review.Images = updateDto.Images != null && updateDto.Images.Any() ? JsonSerializer.Serialize(updateDto.Images) : null;
            review.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            // Update coffee shop rating
            var coffeeShop = await _context.CoffeeShops.FindAsync(review.CoffeeShopId);
            if (coffeeShop != null)
            {
                var avgRating = await _context.Reviews
                    .Where(r => r.CoffeeShopId == coffeeShop.Id)
                    .AverageAsync(r => (double)r.Rating);
                coffeeShop.Rating = avgRating;
                await _context.SaveChangesAsync();
            }

            var user = await _context.Users.FindAsync(review.UserId);

            return Ok(new ReviewResponseDto
            {
                Id = review.Id,
                UserId = review.UserId,
                UserName = user?.Username ?? "Unknown",
                CoffeeShopId = review.CoffeeShopId,
                CoffeeShopName = coffeeShop?.Name ?? "Unknown",
                Rating = review.Rating,
                Content = review.Content,
                Likes = review.Likes,
                IsVerified = review.IsVerified,
                CreatedAt = review.CreatedAt,
                Images = updateDto.Images
            });
        }

        // POST: api/reviews/{id}/like
        [HttpPost("{id}/like")]
        public async Task<ActionResult> LikeReview(int id)
        {
            var review = await _context.Reviews.FindAsync(id);
            
            if (review == null)
            {
                return NotFound(new { message = "Review not found" });
            }

            review.Likes++;
            await _context.SaveChangesAsync();

            return Ok(new { likes = review.Likes });
        }

        // DELETE: api/reviews/{id}
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteReview(int id)
        {
            var review = await _context.Reviews.FindAsync(id);
            
            if (review == null)
            {
                return NotFound(new { message = "Review not found" });
            }

            // TODO: Check if user owns this review or is admin

            _context.Reviews.Remove(review);
            
            // Update coffee shop stats
            var coffeeShop = await _context.CoffeeShops.FindAsync(review.CoffeeShopId);
            if (coffeeShop != null)
            {
                coffeeShop.TotalReviews--;
                if (coffeeShop.TotalReviews > 0)
                {
                    var avgRating = await _context.Reviews
                        .Where(r => r.CoffeeShopId == coffeeShop.Id)
                        .AverageAsync(r => (double)r.Rating);
                    coffeeShop.Rating = avgRating;
                }
                else
                {
                    coffeeShop.Rating = 0;
                }
            }

            // Update user stats
            var user = await _context.Users.FindAsync(review.UserId);
            if (user != null)
            {
                user.TotalReviews--;
            }

            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}