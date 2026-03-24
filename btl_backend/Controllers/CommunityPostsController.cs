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
    public class CommunityPostsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CommunityPostsController> _logger;

        public CommunityPostsController(ApplicationDbContext context, ILogger<CommunityPostsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // GET: api/communityposts
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CommunityPostResponseDto>>> GetCommunityPosts(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 10)
        {
            var postsData = await _context.CommunityPosts
                .Include(p => p.User)
                .OrderByDescending(p => p.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(p => new
                {
                    p.Id,
                    p.UserId,
                    UserName = p.User != null ? p.User.Username : "Unknown",
                    UserAvatar = p.User != null ? p.User.Avatar : null,
                    p.Content,
                    p.Images,
                    p.VenueName,
                    p.Likes,
                    p.CreatedAt
                })
                .ToListAsync();

            var posts = postsData.Select(p => new CommunityPostResponseDto
            {
                Id = p.Id,
                UserId = p.UserId,
                UserName = p.UserName,
                UserAvatar = p.UserAvatar,
                Content = p.Content,
                Images = string.IsNullOrEmpty(p.Images) ? null : JsonSerializer.Deserialize<List<string>>(p.Images),
                VenueName = p.VenueName,
                Likes = p.Likes,
                CreatedAt = p.CreatedAt
            }).ToList();

            var totalCount = await _context.CommunityPosts.CountAsync();
            Response.Headers.Add("X-Total-Count", totalCount.ToString());

            return Ok(posts);
        }

        // GET: api/communityposts/user/{userId}
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<CommunityPostResponseDto>>> GetCommunityPostsByUser(int userId)
        {
            var postsData = await _context.CommunityPosts
                .Include(p => p.User)
                .Where(p => p.UserId == userId)
                .OrderByDescending(p => p.CreatedAt)
                .Select(p => new
                {
                    p.Id,
                    p.UserId,
                    UserName = p.User != null ? p.User.Username : "Unknown",
                    UserAvatar = p.User != null ? p.User.Avatar : null,
                    p.Content,
                    p.Images,
                    p.VenueName,
                    p.Likes,
                    p.CreatedAt
                })
                .ToListAsync();

            var posts = postsData.Select(p => new CommunityPostResponseDto
            {
                Id = p.Id,
                UserId = p.UserId,
                UserName = p.UserName,
                UserAvatar = p.UserAvatar,
                Content = p.Content,
                Images = string.IsNullOrEmpty(p.Images) ? null : JsonSerializer.Deserialize<List<string>>(p.Images),
                VenueName = p.VenueName,
                Likes = p.Likes,
                CreatedAt = p.CreatedAt
            }).ToList();

            return Ok(posts);
        }

        // POST: api/communityposts
        [HttpPost]
        public async Task<ActionResult<CommunityPostResponseDto>> CreateCommunityPost(CreateCommunityPostDto createDto)
        {
            var user = await _context.Users.FindAsync(createDto.UserId);
            if (user == null)
            {
                return NotFound(new { message = "User not found" });
            }

            var post = new CommunityPost
            {
                UserId = createDto.UserId,
                Content = createDto.Content,
                Images = createDto.Images != null && createDto.Images.Any() ? JsonSerializer.Serialize(createDto.Images) : null,
                VenueName = createDto.VenueName,
                CreatedAt = DateTime.UtcNow
            };

            _context.CommunityPosts.Add(post);
            await _context.SaveChangesAsync();

            var response = new CommunityPostResponseDto
            {
                Id = post.Id,
                UserId = post.UserId,
                UserName = user.Username,
                UserAvatar = user.Avatar,
                Content = post.Content,
                Images = post.Images != null ? JsonSerializer.Deserialize<List<string>>(post.Images) : null,
                VenueName = post.VenueName,
                Likes = post.Likes,
                CreatedAt = post.CreatedAt
            };

            return CreatedAtAction(nameof(GetCommunityPosts), new { id = post.Id }, response);
        }

        // PUT: api/communityposts/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult<CommunityPostResponseDto>> UpdateCommunityPost(int id, UpdateCommunityPostDto updateDto)
        {
            var post = await _context.CommunityPosts.Include(p => p.User).FirstOrDefaultAsync(p => p.Id == id);
            if (post == null)
            {
                return NotFound(new { message = "Community post not found" });
            }

            post.Content = updateDto.Content;
            post.Images = updateDto.Images != null && updateDto.Images.Any() ? JsonSerializer.Serialize(updateDto.Images) : null;
            post.VenueName = updateDto.VenueName;
            post.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            var response = new CommunityPostResponseDto
            {
                Id = post.Id,
                UserId = post.UserId,
                UserName = post.User?.Username ?? "Unknown",
                UserAvatar = post.User?.Avatar,
                Content = post.Content,
                Images = post.Images != null ? JsonSerializer.Deserialize<List<string>>(post.Images) : null,
                VenueName = post.VenueName,
                Likes = post.Likes,
                CreatedAt = post.CreatedAt
            };

            return Ok(response);
        }

        // POST: api/communityposts/{id}/like
        [HttpPost("{id}/like")]
        public async Task<ActionResult> LikeCommunityPost(int id)
        {
            var post = await _context.CommunityPosts.FindAsync(id);
            if (post == null)
            {
                return NotFound(new { message = "Community post not found" });
            }

            post.Likes++;
            await _context.SaveChangesAsync();

            return Ok(new { likes = post.Likes });
        }

        // DELETE: api/communityposts/{id}
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteCommunityPost(int id)
        {
            var post = await _context.CommunityPosts.FindAsync(id);
            if (post == null)
            {
                return NotFound(new { message = "Community post not found" });
            }

            _context.CommunityPosts.Remove(post);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}