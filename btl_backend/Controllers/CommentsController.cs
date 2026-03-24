// Controllers/CommentsController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using btl_backend.Data;
using btl_backend.Models;
using btl_backend.DTOs;

namespace btl_backend.Controllers
{
    [ApiController]
    [Route("api/posts/{postId}/[controller]")]
    public class CommentsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public CommentsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/posts/1/comments
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CommentResponseDto>>> GetComments(
            int postId,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 20)
        {
            var comments = await _context.Comments
                .Include(c => c.User)
                .Where(c => c.PostId == postId)
                .OrderByDescending(c => c.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(c => new CommentResponseDto
                {
                    Id = c.Id,
                    PostId = c.PostId,
                    UserId = c.UserId,
                    UserName = c.User != null ? c.User.Username : "Unknown",
                    UserAvatar = c.User != null ? c.User.Avatar : null,
                    Content = c.Content,
                    CreatedAt = c.CreatedAt
                })
                .ToListAsync();

            return Ok(comments);
        }

        // POST: api/posts/1/comments
        [HttpPost]
        public async Task<ActionResult<CommentResponseDto>> CreateComment(
            int postId,
            CreateCommentDto createDto)
        {
            var post = await _context.Posts.FindAsync(postId);
            if (post == null)
            {
                return NotFound(new { message = "Post not found" });
            }

            var user = await _context.Users.FindAsync(createDto.UserId);
            if (user == null)
            {
                return NotFound(new { message = "User not found" });
            }

            var comment = new Comment
            {
                PostId = postId,
                UserId = createDto.UserId,
                Content = createDto.Content,
                CreatedAt = DateTime.UtcNow
            };

            _context.Comments.Add(comment);
            
            // Update comments count on post
            post.Comment++;
            
            await _context.SaveChangesAsync();

            return Ok(new CommentResponseDto
            {
                Id = comment.Id,
                PostId = comment.PostId,
                UserId = comment.UserId,
                UserName = user.Username,
                UserAvatar = user.Avatar,
                Content = comment.Content,
                CreatedAt = comment.CreatedAt
            });
        }

        // DELETE: api/posts/1/comments/5
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteComment(int postId, int id)
        {
            var comment = await _context.Comments
                .FirstOrDefaultAsync(c => c.Id == id && c.PostId == postId);
            
            if (comment == null)
            {
                return NotFound(new { message = "Comment not found" });
            }

            _context.Comments.Remove(comment);
            
            // Update comments count on post
            var post = await _context.Posts.FindAsync(postId);
            if (post != null)
            {
                post.Comment--;
            }
            
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}