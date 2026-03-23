using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using btl_backend.Data;
using btl_backend.Models;
using btl_backend.DTOs;

namespace btl_backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class FavoritesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<FavoritesController> _logger;

        public FavoritesController(ApplicationDbContext context, ILogger<FavoritesController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // GET: api/favorites
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FavoriteResponseDto>>> GetFavorites()
        {
            // For now, using a default user ID. Later will get from JWT token
            var userId = 1; // TODO: Get from JWT token

            var favorites = await _context.Favorites
                .Include(f => f.CoffeeShop)
                .Where(f => f.UserId == userId)
                .OrderByDescending(f => f.CreatedAt)
                .Select(f => new FavoriteResponseDto
                {
                    Id = f.Id,
                    CoffeeShopId = f.CoffeeShopId,
                    CoffeeShopName = f.CoffeeShop != null ? f.CoffeeShop.Name : "Unknown",
                    CoffeeShopImage = f.CoffeeShop != null ? f.CoffeeShop.ImageUrl : null,
                    Rating = f.CoffeeShop != null ? f.CoffeeShop.Rating : 0,
                    PriceRange = f.CoffeeShop != null ? f.CoffeeShop.PriceRange : null,
                    CreatedAt = f.CreatedAt
                })
                .ToListAsync();

            return Ok(favorites);
        }

        // POST: api/favorites/{coffeeShopId}
        [HttpPost("{coffeeShopId}")]
        public async Task<ActionResult> AddFavorite(int coffeeShopId)
        {
            // For now, using a default user ID. Later will get from JWT token
            var userId = 1; // TODO: Get from JWT token

            var coffeeShop = await _context.CoffeeShops.FindAsync(coffeeShopId);
            if (coffeeShop == null)
            {
                return NotFound(new { message = "Coffee shop not found" });
            }

            // Check if already favorite
            var existingFavorite = await _context.Favorites
                .FirstOrDefaultAsync(f => f.UserId == userId && f.CoffeeShopId == coffeeShopId);
            
            if (existingFavorite != null)
            {
                return BadRequest(new { message = "Already in favorites" });
            }

            var favorite = new Favorite
            {
                UserId = userId,
                CoffeeShopId = coffeeShopId,
                CreatedAt = DateTime.UtcNow
            };

            _context.Favorites.Add(favorite);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Added to favorites", favoriteId = favorite.Id });
        }

        // DELETE: api/favorites/{coffeeShopId}
        [HttpDelete("{coffeeShopId}")]
        public async Task<ActionResult> RemoveFavorite(int coffeeShopId)
        {
            // For now, using a default user ID. Later will get from JWT token
            var userId = 1; // TODO: Get from JWT token

            var favorite = await _context.Favorites
                .FirstOrDefaultAsync(f => f.UserId == userId && f.CoffeeShopId == coffeeShopId);
            
            if (favorite == null)
            {
                return NotFound(new { message = "Favorite not found" });
            }

            _context.Favorites.Remove(favorite);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Removed from favorites" });
        }

        // GET: api/favorites/check/{coffeeShopId}
        [HttpGet("check/{coffeeShopId}")]
        public async Task<ActionResult> IsFavorite(int coffeeShopId)
        {
            // For now, using a default user ID. Later will get from JWT token
            var userId = 1; // TODO: Get from JWT token

            var isFavorite = await _context.Favorites
                .AnyAsync(f => f.UserId == userId && f.CoffeeShopId == coffeeShopId);

            return Ok(new { isFavorite });
        }
    }
}