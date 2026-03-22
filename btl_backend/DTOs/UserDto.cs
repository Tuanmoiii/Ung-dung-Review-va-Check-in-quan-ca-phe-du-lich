namespace btl_backend.DTOs
{
    public class LoginDto
    {
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public bool RememberMe { get; set; } = false;
    }

    public class RegisterDto
    {
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string ConfirmPassword { get; set; } = string.Empty;
    }

    public class UserProfileDto
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? Avatar { get; set; }
        public int Points { get; set; }
        public int TotalVisits { get; set; }
        public int TotalReviews { get; set; }
        public string MembershipTier { get; set; } = "Bronze";
        public DateTime CreatedAt { get; set; }
    }

    public class UpdateProfileDto
    {
        public string? Username { get; set; }
        public string? Avatar { get; set; }
    }

    public class ChangePasswordDto
    {
        public string CurrentPassword { get; set; } = string.Empty;
        public string NewPassword { get; set; } = string.Empty;
        public string ConfirmNewPassword { get; set; } = string.Empty;
    }

    public class AuthResponseDto
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Token { get; set; } = string.Empty;
        public string MembershipTier { get; set; } = string.Empty;
        public int Points { get; set; }
    }
}