using Microsoft.EntityFrameworkCore;
using btl_backend.Models;

namespace btl_backend.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
        
        public DbSet<User> Users { get; set; }
        public DbSet<CoffeeShop> CoffeeShops { get; set; }
        public DbSet<Review> Reviews { get; set; }
        public DbSet<CheckIn> CheckIns { get; set; }
        public DbSet<Favorite> Favorites { get; set; }
        public DbSet<CommunityPost> CommunityPosts { get; set; }
        
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            
            // Configure relationships
            modelBuilder.Entity<Review>()
                .HasOne(r => r.User)
                .WithMany(u => u.Reviews)
                .HasForeignKey(r => r.UserId)
                .OnDelete(DeleteBehavior.Restrict);
                
            modelBuilder.Entity<Review>()
                .HasOne(r => r.CoffeeShop)
                .WithMany(c => c.Reviews)
                .HasForeignKey(r => r.CoffeeShopId)
                .OnDelete(DeleteBehavior.Restrict);
                
            modelBuilder.Entity<CheckIn>()
                .HasOne(c => c.User)
                .WithMany(u => u.CheckIns)
                .HasForeignKey(c => c.UserId)
                .OnDelete(DeleteBehavior.Restrict);
                
            modelBuilder.Entity<CheckIn>()
                .HasOne(c => c.CoffeeShop)
                .WithMany(cs => cs.CheckIns)
                .HasForeignKey(c => c.CoffeeShopId)
                .OnDelete(DeleteBehavior.Restrict);
                
            modelBuilder.Entity<Favorite>()
                .HasOne(f => f.User)
                .WithMany(u => u.Favorites)
                .HasForeignKey(f => f.UserId)
                .OnDelete(DeleteBehavior.Restrict);
                
            modelBuilder.Entity<Favorite>()
                .HasOne(f => f.CoffeeShop)
                .WithMany(c => c.Favorites)
                .HasForeignKey(f => f.CoffeeShopId)
                .OnDelete(DeleteBehavior.Restrict);
                
            modelBuilder.Entity<CommunityPost>()
                .HasOne(cp => cp.User)
                .WithMany(u => u.CommunityPosts)
                .HasForeignKey(cp => cp.UserId)
                .OnDelete(DeleteBehavior.Restrict);
                
            // Add unique constraint for favorite (prevent duplicate)
            modelBuilder.Entity<Favorite>()
                .HasIndex(f => new { f.UserId, f.CoffeeShopId })
                .IsUnique();
                
            // Add indexes for better performance
            modelBuilder.Entity<CoffeeShop>()
                .HasIndex(c => c.City);
                
            modelBuilder.Entity<CoffeeShop>()
                .HasIndex(c => c.Rating);
                
            modelBuilder.Entity<Review>()
                .HasIndex(r => r.CoffeeShopId);
                
            modelBuilder.Entity<Review>()
                .HasIndex(r => r.UserId);
        }
    }
}