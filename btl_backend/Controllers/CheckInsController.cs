using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using btl_backend.Data;
using btl_backend.Models;
using btl_backend.DTOs;

namespace btl_backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CheckInsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CheckInsController> _logger;

        public CheckInsController(ApplicationDbContext context, ILogger<CheckInsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // POST: api/checkins
        [HttpPost]
        public async Task<ActionResult<CheckInResponseDto>> CreateCheckIn(CreateCheckInDto createDto)
        {
            // For now, using a default user ID. Later will get from JWT token
            var userId = 1; // TODO: Get from JWT token

            var coffeeShop = await _context.CoffeeShops.FindAsync(createDto.CoffeeShopId);
            if (coffeeShop == null)
            {
                return NotFound(new { message = "Coffee shop not found" });
            }

            // Check if user already checked in today
            var today = DateTime.UtcNow.Date;
            var existingCheckIn = await _context.CheckIns
                .FirstOrDefaultAsync(c => c.UserId == userId && 
                                          c.CoffeeShopId == createDto.CoffeeShopId &&
                                          c.CheckInTime.Date == today);
            
            if (existingCheckIn != null)
            {
                return BadRequest(new { message = "You have already checked in to this coffee shop today" });
            }

            var pointsEarned = 10; // Base points

            var checkIn = new CheckIn
            {
                UserId = userId,
                CoffeeShopId = createDto.CoffeeShopId,
                CheckInTime = DateTime.UtcNow,
                PointsEarned = pointsEarned,
                Note = createDto.Note
            };

            _context.CheckIns.Add(checkIn);

            // Update coffee shop stats
            coffeeShop.TotalCheckIns++;

            // Update user stats and points
            var user = await _context.Users.FindAsync(userId);
            if (user != null)
            {
                user.TotalVisits++;
                user.Points += pointsEarned;
                
                // Update membership tier based on points
                if (user.Points >= 2000)
                {
                    user.MembershipTier = "Gold";
                }
                else if (user.Points >= 1000)
                {
                    user.MembershipTier = "Silver";
                }
                else
                {
                    user.MembershipTier = "Bronze";
                }
            }

            await _context.SaveChangesAsync();

            var response = new CheckInResponseDto
            {
                Id = checkIn.Id,
                UserId = checkIn.UserId,
                UserName = user?.Username ?? "Unknown",
                CoffeeShopId = checkIn.CoffeeShopId,
                CoffeeShopName = coffeeShop.Name,
                CoffeeShopImage = coffeeShop.ImageUrl,
                CheckInTime = checkIn.CheckInTime,
                PointsEarned = pointsEarned,
                Note = checkIn.Note
            };

            return CreatedAtAction(nameof(GetCheckInsByUser), new { userId = checkIn.UserId }, response);
        }

        // GET: api/checkins/user/{userId}
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<CheckInResponseDto>>> GetCheckInsByUser(
            int userId,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 20)
        {
            var checkIns = await _context.CheckIns
                .Include(c => c.CoffeeShop)
                .Where(c => c.UserId == userId)
                .OrderByDescending(c => c.CheckInTime)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(c => new CheckInResponseDto
                {
                    Id = c.Id,
                    UserId = c.UserId,
                    CoffeeShopId = c.CoffeeShopId,
                    CoffeeShopName = c.CoffeeShop != null ? c.CoffeeShop.Name : "Unknown",
                    CoffeeShopImage = c.CoffeeShop != null ? c.CoffeeShop.ImageUrl : null,
                    CheckInTime = c.CheckInTime,
                    PointsEarned = c.PointsEarned,
                    Note = c.Note
                })
                .ToListAsync();

            return Ok(checkIns);
        }

        // GET: api/checkins/coffeeshop/{coffeeShopId}
        [HttpGet("coffeeshop/{coffeeShopId}")]
        public async Task<ActionResult<IEnumerable<CheckInResponseDto>>> GetCheckInsByCoffeeShop(
            int coffeeShopId,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 20)
        {
            var checkIns = await _context.CheckIns
                .Include(c => c.User)
                .Where(c => c.CoffeeShopId == coffeeShopId)
                .OrderByDescending(c => c.CheckInTime)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(c => new CheckInResponseDto
                {
                    Id = c.Id,
                    UserId = c.UserId,
                    UserName = c.User != null ? c.User.Username : "Unknown",
                    CoffeeShopId = c.CoffeeShopId,
                    CheckInTime = c.CheckInTime,
                    PointsEarned = c.PointsEarned,
                    Note = c.Note
                })
                .ToListAsync();

            return Ok(checkIns);
        }

        // GET: api/checkins/today
        [HttpGet("today")]
        public async Task<ActionResult<IEnumerable<CheckInResponseDto>>> GetTodayCheckIns()
        {
            var today = DateTime.UtcNow.Date;
            
            var checkIns = await _context.CheckIns
                .Include(c => c.User)
                .Include(c => c.CoffeeShop)
                .Where(c => c.CheckInTime.Date == today)
                .OrderByDescending(c => c.CheckInTime)
                .Take(50)
                .Select(c => new CheckInResponseDto
                {
                    Id = c.Id,
                    UserId = c.UserId,
                    UserName = c.User != null ? c.User.Username : "Unknown",
                    CoffeeShopId = c.CoffeeShopId,
                    CoffeeShopName = c.CoffeeShop != null ? c.CoffeeShop.Name : "Unknown",
                    CheckInTime = c.CheckInTime,
                    PointsEarned = c.PointsEarned,
                    Note = c.Note
                })
                .ToListAsync();

            return Ok(checkIns);
        }
    }
}