using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using btl_backend.Data;
using btl_backend.Models;
using btl_backend.DTOs;

namespace btl_backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PostsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<PostsController> _logger;

        public PostsController(ApplicationDbContext context, ILogger<PostsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // GET: api/posts
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PostResponseDto>>> GetPosts(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 20)
        {
            var posts = await _context.Posts
                .Include(p => p.User)
                .Include(p => p.CoffeeShop)
                .OrderByDescending(p => p.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(p => new PostResponseDto
                {
                    Id = p.Id,
                    UserId = p.UserId,
                    UserName = p.User != null ? p.User.Username : "Unknown",
                    UserAvatar = p.User != null ? p.User.Avatar : null,
                    Content = p.Content,
                    Images = string.IsNullOrEmpty(p.Images) ? null : JsonConvert.DeserializeObject<List<string>>(p.Images),
                    CoffeeShopId = p.CoffeeShopId,
                    CoffeeShopName = p.CoffeeShop != null ? p.CoffeeShop.Name : null,
                    Likes = p.Likes,
                    Comments = p.Comment,
                    CreatedAt = p.CreatedAt,
                    UpdatedAt = p.UpdatedAt
                })
                .ToListAsync();

            return Ok(posts);
        }

        // GET: api/posts/user/{userId}
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<PostResponseDto>>> GetPostsByUser(int userId)
        {
            var posts = await _context.Posts
                .Include(p => p.User)
                .Include(p => p.CoffeeShop)
                .Where(p => p.UserId == userId)
                .OrderByDescending(p => p.CreatedAt)
                .Select(p => new PostResponseDto
                {
                    Id = p.Id,
                    UserId = p.UserId,
                    UserName = p.User != null ? p.User.Username : "Unknown",
                    UserAvatar = p.User != null ? p.User.Avatar : null,
                    Content = p.Content,
                    Images = string.IsNullOrEmpty(p.Images) ? null : JsonConvert.DeserializeObject<List<string>>(p.Images),
                    CoffeeShopId = p.CoffeeShopId,
                    CoffeeShopName = p.CoffeeShop != null ? p.CoffeeShop.Name : null,
                    Likes = p.Likes,
                    Comments = p.Comment,
                    CreatedAt = p.CreatedAt,
                    UpdatedAt = p.UpdatedAt
                })
                .ToListAsync();

            return Ok(posts);
        }

        // GET: api/posts/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<PostResponseDto>> GetPost(int id)
        {
            var post = await _context.Posts
                .Include(p => p.User)
                .Include(p => p.CoffeeShop)
                .FirstOrDefaultAsync(p => p.Id == id);

            if (post == null)
            {
                return NotFound(new { message = "Post not found" });
            }

            return Ok(new PostResponseDto
            {
                Id = post.Id,
                UserId = post.UserId,
                UserName = post.User?.Username ?? "Unknown",
                UserAvatar = post.User?.Avatar,
                Content = post.Content,
                Images = string.IsNullOrEmpty(post.Images) ? null : JsonConvert.DeserializeObject<List<string>>(post.Images),
                CoffeeShopId = post.CoffeeShopId,
                CoffeeShopName = post.CoffeeShop?.Name,
                Likes = post.Likes,
                Comments = post.Comment,
                CreatedAt = post.CreatedAt,
                UpdatedAt = post.UpdatedAt
            });
        }

        // POST: api/posts
        [HttpPost]
        public async Task<ActionResult<PostResponseDto>> CreatePost(CreatePostDto createDto)
        {
            var user = await _context.Users.FindAsync(createDto.UserId);
            if (user == null)
            {
                return NotFound(new { message = "User not found" });
            }

            var post = new Post
            {
                UserId = createDto.UserId,
                Content = createDto.Content,
                Images = createDto.Images != null && createDto.Images.Any() 
                    ? JsonConvert.SerializeObject(createDto.Images) 
                    : null,
                CoffeeShopId = createDto.CoffeeShopId,
                CreatedAt = DateTime.UtcNow
            };

            _context.Posts.Add(post);
            await _context.SaveChangesAsync();

            var response = new PostResponseDto
            {
                Id = post.Id,
                UserId = post.UserId,
                UserName = user.Username,
                UserAvatar = user.Avatar,
                Content = post.Content,
                Images = createDto.Images,
                CoffeeShopId = post.CoffeeShopId,
                Likes = post.Likes,
                Comments = post.Comment,
                CreatedAt = post.CreatedAt
            };

            if (post.CoffeeShopId.HasValue)
            {
                var coffeeShop = await _context.CoffeeShops.FindAsync(post.CoffeeShopId);
                response.CoffeeShopName = coffeeShop?.Name;
            }

            return CreatedAtAction(nameof(GetPost), new { id = post.Id }, response);
        }

        // PUT: api/posts/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult<PostResponseDto>> UpdatePost(int id, UpdatePostDto updateDto)
        {
            var post = await _context.Posts
                .Include(p => p.User)
                .Include(p => p.CoffeeShop)
                .FirstOrDefaultAsync(p => p.Id == id);

            if (post == null)
            {
                return NotFound(new { message = "Post not found" });
            }

            post.Content = updateDto.Content;
            post.Images = updateDto.Images != null && updateDto.Images.Any() 
                ? JsonConvert.SerializeObject(updateDto.Images) 
                : null;
            post.CoffeeShopId = updateDto.CoffeeShopId;
            post.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return Ok(new PostResponseDto
            {
                Id = post.Id,
                UserId = post.UserId,
                UserName = post.User?.Username ?? "Unknown",
                UserAvatar = post.User?.Avatar,
                Content = post.Content,
                Images = updateDto.Images,
                CoffeeShopId = post.CoffeeShopId,
                CoffeeShopName = post.CoffeeShop?.Name,
                Likes = post.Likes,
                Comments = post.Comment,
                CreatedAt = post.CreatedAt,
                UpdatedAt = post.UpdatedAt
            });
        }

        // POST: api/posts/{id}/like
        [HttpPost("{id}/like")]
        public async Task<ActionResult> LikePost(int id)
        {
            var post = await _context.Posts.FindAsync(id);
            
            if (post == null)
            {
                return NotFound(new { message = "Post not found" });
            }

            post.Likes++;
            await _context.SaveChangesAsync();

            return Ok(new { likes = post.Likes });
        }

        // DELETE: api/posts/{id}
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeletePost(int id)
        {
            var post = await _context.Posts.FindAsync(id);
            
            if (post == null)
            {
                return NotFound(new { message = "Post not found" });
            }

            _context.Posts.Remove(post);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}