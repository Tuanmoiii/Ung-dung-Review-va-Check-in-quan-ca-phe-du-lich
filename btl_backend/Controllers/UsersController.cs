using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using btl_backend.Data;
using btl_backend.Models;
using btl_backend.DTOs;
using BCryptNet = BCrypt.Net.BCrypt;  // Đổi alias thành BCryptNet

namespace btl_backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<UsersController> _logger;

        public UsersController(ApplicationDbContext context, ILogger<UsersController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // POST: api/users/register
        [HttpPost("register")]
        public async Task<ActionResult<AuthResponseDto>> Register(RegisterDto registerDto)
        {
            // Validate
            if (registerDto.Password != registerDto.ConfirmPassword)
            {
                return BadRequest(new { message = "Passwords do not match" });
            }

            // Check if email already exists
            if (await _context.Users.AnyAsync(u => u.Email == registerDto.Email))
            {
                return BadRequest(new { message = "Email already exists" });
            }

            // Check if username already exists
            if (await _context.Users.AnyAsync(u => u.Username == registerDto.Username))
            {
                return BadRequest(new { message = "Username already exists" });
            }

            // Create new user
            var user = new User
            {
                Username = registerDto.Username,
                Email = registerDto.Email,
                PasswordHash = BCryptNet.HashPassword(registerDto.Password),  // Dùng BCryptNet
                Points = 0,
                TotalVisits = 0,
                TotalReviews = 0,
                MembershipTier = "Bronze",
                Role = "user",
                CreatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            // Return response (without token for now)
            return Ok(new AuthResponseDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                MembershipTier = user.MembershipTier,
                Points = user.Points
            });
        }

        // POST: api/users/login
        [HttpPost("login")]
        public async Task<ActionResult<AuthResponseDto>> Login(LoginDto loginDto)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == loginDto.Email);
            
            if (user == null)
            {
                return Unauthorized(new { message = "Invalid email or password" });
            }

            // Verify password - dùng BCryptNet
            if (!BCryptNet.Verify(loginDto.Password, user.PasswordHash))
            {
                return Unauthorized(new { message = "Invalid email or password" });
            }

            // Update last login
            user.LastLoginAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            return Ok(new AuthResponseDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                MembershipTier = user.MembershipTier,
                Points = user.Points
            });
        }

        // GET: api/users/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<UserProfileDto>> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            
            if (user == null)
            {
                return NotFound(new { message = "User not found" });
            }

            return Ok(new UserProfileDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                Avatar = user.Avatar,
                Points = user.Points,
                TotalVisits = user.TotalVisits,
                TotalReviews = user.TotalReviews,
                MembershipTier = user.MembershipTier ?? "Bronze",
                CreatedAt = user.CreatedAt
            });
        }

        // GET: api/users/{id}/stats
        [HttpGet("{id}/stats")]
        public async Task<ActionResult> GetUserStats(int id)
        {
            var user = await _context.Users
                .Include(u => u.Reviews)
                .Include(u => u.CheckIns)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
            {
                return NotFound(new { message = "User not found" });
            }

            return Ok(new
            {
                user.Points,
                user.TotalVisits,
                user.TotalReviews,
                user.MembershipTier,
                RecentCheckIns = user.CheckIns?
                    .OrderByDescending(c => c.CheckInTime)
                    .Take(5)
                    .Select(c => new
                    {
                        c.Id,
                        c.CoffeeShopId,
                        c.CheckInTime,
                        c.PointsEarned
                    }),
                RecentReviews = user.Reviews?
                    .OrderByDescending(r => r.CreatedAt)
                    .Take(5)
                    .Select(r => new
                    {
                        r.Id,
                        r.CoffeeShopId,
                        r.Rating,
                        r.Content,
                        r.CreatedAt
                    })
            });
        }

        // PUT: api/users/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult<UserProfileDto>> UpdateProfile(int id, UpdateProfileDto updateDto)
        {
            var user = await _context.Users.FindAsync(id);
            
            if (user == null)
            {
                return NotFound(new { message = "User not found" });
            }

            if (!string.IsNullOrEmpty(updateDto.Username))
            {
                // Check if username is taken
                if (await _context.Users.AnyAsync(u => u.Username == updateDto.Username && u.Id != id))
                {
                    return BadRequest(new { message = "Username already taken" });
                }
                user.Username = updateDto.Username;
            }

            if (updateDto.Avatar != null)
            {
                user.Avatar = updateDto.Avatar;
            }

            await _context.SaveChangesAsync();

            return Ok(new UserProfileDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                Avatar = user.Avatar,
                Points = user.Points,
                TotalVisits = user.TotalVisits,
                TotalReviews = user.TotalReviews,
                MembershipTier = user.MembershipTier ?? "Bronze",
                CreatedAt = user.CreatedAt
            });
        }
    }
}