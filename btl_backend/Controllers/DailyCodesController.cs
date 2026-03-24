// Controllers/DailyCodesController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using btl_backend.Data;
using btl_backend.Models;
using btl_backend.DTOs;

namespace btl_backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DailyCodesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly Random _random = new();

        public DailyCodesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/dailycodes/{coffeeShopId}
        [HttpGet("{coffeeShopId}")]
        public async Task<ActionResult<DailyCodeResponseDto>> GetDailyCode(int coffeeShopId)
        {
            var today = DateTime.UtcNow.Date;
            
            var dailyCode = await _context.DailyCodes
                .FirstOrDefaultAsync(d => d.CoffeeShopId == coffeeShopId && 
                                          d.ExpiryDate == today &&
                                          d.IsActive);
            
            if (dailyCode == null)
            {
                var newCode = _random.Next(10000, 99999).ToString();
                dailyCode = new DailyCode
                {
                    CoffeeShopId = coffeeShopId,
                    Code = newCode,
                    ExpiryDate = today,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow
                };
                _context.DailyCodes.Add(dailyCode);
                await _context.SaveChangesAsync();
            }
            
            return Ok(new DailyCodeResponseDto
            {
                Id = dailyCode.Id,
                CoffeeShopId = dailyCode.CoffeeShopId,
                Code = dailyCode.Code,
                ExpiryDate = dailyCode.ExpiryDate,
                IsActive = dailyCode.IsActive
            });
        }

        // POST: api/dailycodes/validate
        [HttpPost("validate")]
        public async Task<ActionResult> ValidateCode([FromBody] ValidateCodeDto dto)
        {
            var today = DateTime.UtcNow.Date;
            
            var dailyCode = await _context.DailyCodes
                .FirstOrDefaultAsync(d => d.CoffeeShopId == dto.CoffeeShopId && 
                                          d.Code == dto.Code &&
                                          d.ExpiryDate == today &&
                                          d.IsActive);
            
            if (dailyCode == null)
            {
                return BadRequest(new { message = "Mã code không hợp lệ hoặc đã hết hạn" });
            }
            
            return Ok(new { valid = true, message = "Code hợp lệ" });
        }
    }
}