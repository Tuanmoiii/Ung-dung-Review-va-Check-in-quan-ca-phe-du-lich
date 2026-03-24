using Microsoft.EntityFrameworkCore;
using btl_backend.Models;

namespace btl_backend.Data
{
    public static class SeedData
    {
        public static void Initialize(IServiceProvider serviceProvider)
        {
            using var context = new ApplicationDbContext(
                serviceProvider.GetRequiredService<DbContextOptions<ApplicationDbContext>>());
            
            // Check if already seeded
            if (context.CoffeeShops.Any())
            {
                return;
            }
            
            // ==================== 1. USERS (10 users) ====================
            var users = new User[]
            {
                new User 
                { 
                    Username = "alex_rivera", 
                    Email = "alex@email.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                    Avatar = "https://lh3.googleusercontent.com/aida-public/AB6AXuCZV7-Ba03FU_znEYU2cLhpb96ln-_XRyDm-_VmwB_-TrR6Vnlx6Nl6eWEIpdLy2cUiQD_jd3xRp9jOjpG_gOOKdmEy9eDl8mCSsshfYl-PTiFupkK86EbfXqmZOE9yaml8YxSg0mDt11o99M4pc8T6mcERBsYjZyQuFkHkIEygJVih6Q6RuW4mmaxbEtBlz-fxrtS25jmCT1etawLCqWWrVvcFrQFOkKcz6uLM7LF5cYXJS0m4Qxv4VIFc1nWR3r750mDr_P0IYl4",
                    Points = 1240,
                    TotalVisits = 42,
                    TotalReviews = 18,
                    MembershipTier = "Gold",
                    Role = "user",
                    CreatedAt = DateTime.UtcNow.AddMonths(-6)
                },
                new User 
                { 
                    Username = "admin", 
                    Email = "admin@gmail.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("123123"),
                    Avatar = "https://lh3.googleusercontent.com/aida-public/AB6AXuCY3R_i2349S295gg_AdVSK-gS_7tWrA4ZdlSw_daJgjsE6PhXEtiir6_yTzMq7VPmBfuI6YJn96fqV0jQXYEhPvY-GAw0NKlv3NFaRn-jhaCYxSjZWZWeyiUgbpzE1zfp8ibOoCS2vABeqwqycyerUZZHCl-uxC2TEykW8GReBiWX877uKb4g4ieGIvfx3tDANEcg5l0NhExet-XGGkDNjOZgIEkBymxxz4DrS1OcHXXvq8WB1xphPbPTJ6YjaL_PFCQAGuiSZXrg",
                    Points = 890,
                    TotalVisits = 28,
                    TotalReviews = 12,
                    MembershipTier = "Silver",
                    Role = "admin",
                    CreatedAt = DateTime.UtcNow.AddMonths(-4)
                },
                new User 
                { 
                    Username = "jordan_m", 
                    Email = "jordan@email.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                    Points = 450,
                    TotalVisits = 15,
                    TotalReviews = 5,
                    MembershipTier = "Bronze",
                    Role = "user",
                    CreatedAt = DateTime.UtcNow.AddMonths(-2)
                },
                new User 
                { 
                    Username = "emily_wong", 
                    Email = "emily@email.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                    Avatar = "https://randomuser.me/api/portraits/women/1.jpg",
                    Points = 2100,
                    TotalVisits = 78,
                    TotalReviews = 32,
                    MembershipTier = "Gold",
                    Role = "user",
                    CreatedAt = DateTime.UtcNow.AddMonths(-8)
                },
                new User 
                { 
                    Username = "mike_tran", 
                    Email = "mike@email.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                    Points = 670,
                    TotalVisits = 23,
                    TotalReviews = 8,
                    MembershipTier = "Silver",
                    Role = "user",
                    CreatedAt = DateTime.UtcNow.AddMonths(-3)
                },
                new User 
                { 
                    Username = "lisa_nguyen", 
                    Email = "lisa@email.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                    Points = 1560,
                    TotalVisits = 51,
                    TotalReviews = 24,
                    MembershipTier = "Gold",
                    Role = "user",
                    CreatedAt = DateTime.UtcNow.AddMonths(-5)
                },
                new User 
                { 
                    Username = "kevin_pham", 
                    Email = "kevin@email.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                    Points = 320,
                    TotalVisits = 12,
                    TotalReviews = 4,
                    MembershipTier = "Bronze",
                    Role = "user",
                    CreatedAt = DateTime.UtcNow.AddMonths(-1)
                },
                new User 
                { 
                    Username = "anna_lee", 
                    Email = "anna@email.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                    Points = 890,
                    TotalVisits = 34,
                    TotalReviews = 15,
                    MembershipTier = "Silver",
                    Role = "user",
                    CreatedAt = DateTime.UtcNow.AddMonths(-4)
                },
                new User 
                { 
                    Username = "david_kim", 
                    Email = "david@email.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                    Points = 2450,
                    TotalVisits = 89,
                    TotalReviews = 41,
                    MembershipTier = "Gold",
                    Role = "admin",
                    CreatedAt = DateTime.UtcNow.AddMonths(-10)
                },
                new User 
                { 
                    Username = "sofia_garcia", 
                    Email = "sofia@email.com", 
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                    Points = 540,
                    TotalVisits = 19,
                    TotalReviews = 7,
                    MembershipTier = "Bronze",
                    Role = "user",
                    CreatedAt = DateTime.UtcNow.AddMonths(-2)
                }
            };
            
            context.Users.AddRange(users);
            context.SaveChanges();
            
            // ==================== 2. COFFEE SHOPS (10 shops) ====================
            var coffeeShops = new CoffeeShop[]
            {
                new CoffeeShop
                {
                    Name = "The Roasted Bean",
                    Description = "Artisanal coffee shop with specialty brews and cozy atmosphere. Perfect for deep work sessions or casual meetups. The pour-over here is actually transformative.",
                    Address = "124 Artisan Alley, Creative District",
                    City = "San Francisco",
                    Latitude = 37.7749,
                    Longitude = -122.4194,
                    ImageUrl = "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800",
                    Rating = 4.9,
                    TotalReviews = 248,
                    TotalCheckIns = 156,
                    PriceRange = "$$",
                    OpeningHours = "{\"Monday\":\"7:30-18:00\",\"Tuesday\":\"7:30-18:00\",\"Wednesday\":\"7:30-18:00\",\"Thursday\":\"7:30-18:00\",\"Friday\":\"7:30-18:00\",\"Saturday\":\"8:00-20:00\",\"Sunday\":\"9:00-16:00\"}",
                    IsVerified = true,
                    IsFeatured = true,
                    Tags = "[\"Aesthetic\",\"Quiet\",\"WiFi\",\"Work\"]",
                    Amenities = "[\"WiFi\",\"Parking\",\"Outdoor Seating\",\"Indoor Seating\"]"
                },
                new CoffeeShop
                {
                    Name = "The Arch Brews",
                    Description = "Art-deco inspired space with curated indie playlists. Known for their signature espresso blends and minimalist aesthetics.",
                    Address = "45 Market Street",
                    City = "San Francisco",
                    Latitude = 37.7845,
                    Longitude = -122.4089,
                    ImageUrl = "https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800",
                    Rating = 4.7,
                    TotalReviews = 124,
                    TotalCheckIns = 89,
                    PriceRange = "$$",
                    OpeningHours = "{\"Monday\":\"8:00-19:00\",\"Tuesday\":\"8:00-19:00\",\"Wednesday\":\"8:00-19:00\",\"Thursday\":\"8:00-19:00\",\"Friday\":\"8:00-20:00\",\"Saturday\":\"9:00-20:00\",\"Sunday\":\"9:00-18:00\"}",
                    IsVerified = true,
                    IsFeatured = false,
                    Tags = "[\"Aesthetic\",\"Work\",\"WiFi\"]",
                    Amenities = "[\"WiFi\",\"Indoor Seating\"]"
                },
                new CoffeeShop
                {
                    Name = "Pages & Steam",
                    Description = "A sanctuary for book lovers. No laptops after 6 PM. Perfect for reading and relaxing with a good book and great coffee.",
                    Address = "89 Literary Lane",
                    City = "San Francisco",
                    Latitude = 37.7694,
                    Longitude = -122.4862,
                    ImageUrl = "https://images.unsplash.com/photo-1453614512568-c4024d13c247?w=800",
                    Rating = 4.8,
                    TotalReviews = 98,
                    TotalCheckIns = 67,
                    PriceRange = "$",
                    OpeningHours = "{\"Monday\":\"9:00-18:00\",\"Tuesday\":\"9:00-18:00\",\"Wednesday\":\"9:00-18:00\",\"Thursday\":\"9:00-18:00\",\"Friday\":\"9:00-20:00\",\"Saturday\":\"10:00-18:00\",\"Sunday\":\"10:00-17:00\"}",
                    IsVerified = true,
                    IsFeatured = false,
                    Tags = "[\"Quiet\",\"Study\",\"Books\"]",
                    Amenities = "[\"Books\",\"Quiet Zone\",\"Reading Area\"]"
                },
                new CoffeeShop
                {
                    Name = "Wild Garden Loft",
                    Description = "Outdoor greenhouse seating with ultra-fast WiFi and artisan matchas. Surrounded by plants and natural light.",
                    Address = "234 Garden Street",
                    City = "San Francisco",
                    Latitude = 37.8024,
                    Longitude = -122.4058,
                    ImageUrl = "https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=800",
                    Rating = 4.6,
                    TotalReviews = 87,
                    TotalCheckIns = 54,
                    PriceRange = "$$",
                    OpeningHours = "{\"Monday\":\"8:00-17:00\",\"Tuesday\":\"8:00-17:00\",\"Wednesday\":\"8:00-17:00\",\"Thursday\":\"8:00-17:00\",\"Friday\":\"8:00-18:00\",\"Saturday\":\"9:00-18:00\",\"Sunday\":\"9:00-16:00\"}",
                    IsVerified = true,
                    IsFeatured = true,
                    Tags = "[\"Nature\",\"WiFi\",\"Aesthetic\"]",
                    Amenities = "[\"WiFi\",\"Outdoor Seating\",\"Parking\",\"Plants\"]"
                },
                new CoffeeShop
                {
                    Name = "The Rain Lab",
                    Description = "Specialty brews & lo-fi beats. Industrial style with cozy corners. The perfect spot for remote work and creative sessions.",
                    Address = "567 Industrial Way",
                    City = "San Francisco",
                    Latitude = 37.7589,
                    Longitude = -122.4246,
                    ImageUrl = "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=800",
                    Rating = 4.9,
                    TotalReviews = 312,
                    TotalCheckIns = 198,
                    PriceRange = "$$",
                    OpeningHours = "{\"Monday\":\"7:00-20:00\",\"Tuesday\":\"7:00-20:00\",\"Wednesday\":\"7:00-20:00\",\"Thursday\":\"7:00-20:00\",\"Friday\":\"7:00-21:00\",\"Saturday\":\"8:00-21:00\",\"Sunday\":\"8:00-19:00\"}",
                    IsVerified = true,
                    IsFeatured = true,
                    Tags = "[\"Work\",\"WiFi\",\"Coffee\"]",
                    Amenities = "[\"WiFi\",\"Parking\",\"Indoor Seating\",\"Power Outlets\"]"
                },
                new CoffeeShop
                {
                    Name = "Azure Peaks",
                    Description = "Silent hikes & morning coffee. Mountain views and fresh brews. Perfect for nature lovers.",
                    Address = "890 Mountain View Rd",
                    City = "San Francisco",
                    Latitude = 37.8278,
                    Longitude = -122.4239,
                    ImageUrl = "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800",
                    Rating = 4.7,
                    TotalReviews = 156,
                    TotalCheckIns = 112,
                    PriceRange = "$$$",
                    OpeningHours = "{\"Monday\":\"8:00-17:00\",\"Tuesday\":\"8:00-17:00\",\"Wednesday\":\"8:00-17:00\",\"Thursday\":\"8:00-17:00\",\"Friday\":\"8:00-18:00\",\"Saturday\":\"9:00-18:00\",\"Sunday\":\"9:00-17:00\"}",
                    IsVerified = false,
                    IsFeatured = false,
                    Tags = "[\"Nature\",\"Quiet\",\"Views\"]",
                    Amenities = "[\"Outdoor Seating\",\"Scenic Views\",\"Hiking Nearby\"]"
                },
                new CoffeeShop
                {
                    Name = "Cedar & Smoke",
                    Description = "Artisanal Bakery & Coffee. Fresh pastries daily. The best croissants in town.",
                    Address = "123 Cedar Street",
                    City = "San Francisco",
                    Latitude = 37.7834,
                    Longitude = -122.4163,
                    ImageUrl = "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800",
                    Rating = 4.8,
                    TotalReviews = 203,
                    TotalCheckIns = 145,
                    PriceRange = "$",
                    OpeningHours = "{\"Monday\":\"6:30-18:00\",\"Tuesday\":\"6:30-18:00\",\"Wednesday\":\"6:30-18:00\",\"Thursday\":\"6:30-18:00\",\"Friday\":\"6:30-19:00\",\"Saturday\":\"7:00-19:00\",\"Sunday\":\"7:00-17:00\"}",
                    IsVerified = true,
                    IsFeatured = false,
                    Tags = "[\"Bakery\",\"Breakfast\",\"Coffee\"]",
                    Amenities = "[\"WiFi\",\"Parking\",\"Takeout\"]"
                },
                new CoffeeShop
                {
                    Name = "Steam & Steel",
                    Description = "Industrial Style coffee shop. Perfect for remote work with fast WiFi and great coffee.",
                    Address = "456 Factory Blvd",
                    City = "San Francisco",
                    Latitude = 37.7702,
                    Longitude = -122.4113,
                    ImageUrl = "https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=800",
                    Rating = 4.6,
                    TotalReviews = 178,
                    TotalCheckIns = 134,
                    PriceRange = "$$",
                    OpeningHours = "{\"Monday\":\"7:00-19:00\",\"Tuesday\":\"7:00-19:00\",\"Wednesday\":\"7:00-19:00\",\"Thursday\":\"7:00-19:00\",\"Friday\":\"7:00-20:00\",\"Saturday\":\"8:00-20:00\",\"Sunday\":\"8:00-18:00\"}",
                    IsVerified = true,
                    IsFeatured = false,
                    Tags = "[\"Work\",\"WiFi\",\"Industrial\"]",
                    Amenities = "[\"WiFi\",\"Parking\",\"Indoor Seating\",\"Power Outlets\"]"
                },
                new CoffeeShop
                {
                    Name = "The Greenhouse",
                    Description = "Botanical Bliss. Surrounded by plants and natural light. A peaceful escape from the city.",
                    Address = "789 Green Street",
                    City = "San Francisco",
                    Latitude = 37.7655,
                    Longitude = -122.4332,
                    ImageUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuAsSXIt8KLjjdIzIej5O8TjmVS5OvtE46sfn0g23dZKNFsAc591TvfzUr8ASMKzEy38W6VPf3-uVZX0bhUxqAsFSMGe3ZIA_aHFELqDxzFiyVilFG0ho3dbvKOJzZ5eFTGkp3Q7bEACGs3KgBEf3Harw8BIkBg_2Nv5dUQNzOHk92xkb48E-WglA_VR1KXMT59cuS7sA1NXBQ1DdEBLncbbp4LK8peTAa9-BLD8wWS_402pozFWvnTNqsyufOaVjc9S_VlGTeOynKY",
                    TotalReviews = 95,
                    TotalCheckIns = 67,
                    PriceRange = "$$",
                    OpeningHours = "{\"Monday\":\"8:00-18:00\",\"Tuesday\":\"8:00-18:00\",\"Wednesday\":\"8:00-18:00\",\"Thursday\":\"8:00-18:00\",\"Friday\":\"8:00-19:00\",\"Saturday\":\"9:00-19:00\",\"Sunday\":\"9:00-17:00\"}",
                    IsVerified = true,
                    IsFeatured = false,
                    Tags = "[\"Nature\",\"Aesthetic\",\"Plants\"]",
                    Amenities = "[\"Outdoor Seating\",\"Plants\",\"Natural Light\"]"
                },
                new CoffeeShop
                {
                    Name = "The Morning Brew",
                    Description = "Cozy neighborhood cafe with the best breakfast sandwiches and fresh coffee. A local favorite.",
                    Address = "321 Morning Ave",
                    City = "San Francisco",
                    Latitude = 37.8095,
                    Longitude = -122.4101,
                    ImageUrl = "https://images.unsplash.com/photo-1481833761820-0509d3217039?w=800",
                    Rating = 4.7,
                    TotalReviews = 312,
                    TotalCheckIns = 245,
                    PriceRange = "$",
                    OpeningHours = "{\"Monday\":\"6:00-17:00\",\"Tuesday\":\"6:00-17:00\",\"Wednesday\":\"6:00-17:00\",\"Thursday\":\"6:00-17:00\",\"Friday\":\"6:00-18:00\",\"Saturday\":\"7:00-18:00\",\"Sunday\":\"7:00-16:00\"}",
                    IsVerified = true,
                    IsFeatured = true,
                    Tags = "[\"Breakfast\",\"Coffee\",\"Local\"]",
                    Amenities = "[\"WiFi\",\"Parking\",\"Takeout\",\"Breakfast\"]"
                }
            };
            
            context.CoffeeShops.AddRange(coffeeShops);
            context.SaveChanges();
            
            // ==================== 3. REVIEWS (15 reviews) ====================
            var reviews = new Review[]
            {
                new Review
                {
                    UserId = users[0].Id,
                    CoffeeShopId = coffeeShops[0].Id,
                    Rating = 5,
                    Content = "Best oat latte in the district. The atmosphere is perfect for deep work sessions. No loud music, just the gentle hum of the roaster. Highly recommend the window seats! ☕️✨",
                    Likes = 124,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-2)
                },
                new Review
                {
                    UserId = users[1].Id,
                    CoffeeShopId = coffeeShops[0].Id,
                    Rating = 5,
                    Content = "Incredible selection of beans. The barista was very knowledgeable about the origins. A bit crowded on Saturdays but worth the wait.",
                    Likes = 89,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-5)
                },
                new Review
                {
                    UserId = users[2].Id,
                    CoffeeShopId = coffeeShops[1].Id,
                    Rating = 4,
                    Content = "Great atmosphere, love the art-deco style. Coffee was good but a bit pricey. Still worth visiting!",
                    Likes = 45,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-7)
                },
                new Review
                {
                    UserId = users[0].Id,
                    CoffeeShopId = coffeeShops[4].Id,
                    Rating = 5,
                    Content = "The Rain Lab is my go-to spot for work. Fast WiFi, great coffee, and the lo-fi beats create the perfect productivity vibe. Highly recommend! 🎧💻",
                    Likes = 67,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-10)
                },
                new Review
                {
                    UserId = users[1].Id,
                    CoffeeShopId = coffeeShops[2].Id,
                    Rating = 5,
                    Content = "Perfect for book lovers! Quiet atmosphere, great coffee, and you can read while sipping your favorite brew. Found my new reading spot! 📚",
                    Likes = 34,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-12)
                },
                new Review
                {
                    UserId = users[3].Id,
                    CoffeeShopId = coffeeShops[3].Id,
                    Rating = 4,
                    Content = "Beautiful greenhouse setting! The matcha latte is amazing. A bit crowded on weekends but worth the visit.",
                    Likes = 56,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-8)
                },
                new Review
                {
                    UserId = users[4].Id,
                    CoffeeShopId = coffeeShops[5].Id,
                    Rating = 5,
                    Content = "Stunning views! The coffee is great and the hiking trail nearby makes it a perfect morning stop.",
                    Likes = 78,
                    IsVerified = false,
                    CreatedAt = DateTime.UtcNow.AddDays(-15)
                },
                new Review
                {
                    UserId = users[5].Id,
                    CoffeeShopId = coffeeShops[6].Id,
                    Rating = 5,
                    Content = "Best croissants ever! The coffee is also excellent. Perfect for breakfast.",
                    Likes = 92,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-3)
                },
                new Review
                {
                    UserId = users[6].Id,
                    CoffeeShopId = coffeeShops[7].Id,
                    Rating = 4,
                    Content = "Great place to work. Fast WiFi and plenty of power outlets. Coffee is good too.",
                    Likes = 41,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-6)
                },
                new Review
                {
                    UserId = users[7].Id,
                    CoffeeShopId = coffeeShops[8].Id,
                    Rating = 5,
                    Content = "Beautiful plant-filled space! So peaceful and relaxing. Perfect escape from the city.",
                    Likes = 63,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-4)
                },
                new Review
                {
                    UserId = users[8].Id,
                    CoffeeShopId = coffeeShops[9].Id,
                    Rating = 5,
                    Content = "The best breakfast sandwich in town! Coffee is always fresh. Great local spot.",
                    Likes = 112,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-1)
                },
                new Review
                {
                    UserId = users[0].Id,
                    CoffeeShopId = coffeeShops[3].Id,
                    Rating = 4,
                    Content = "Love the outdoor seating. Perfect for sunny days. Matcha is delicious!",
                    Likes = 38,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-14)
                },
                new Review
                {
                    UserId = users[1].Id,
                    CoffeeShopId = coffeeShops[4].Id,
                    Rating = 5,
                    Content = "My favorite remote work spot! The atmosphere is perfect for focus.",
                    Likes = 87,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-9)
                },
                new Review
                {
                    UserId = users[2].Id,
                    CoffeeShopId = coffeeShops[7].Id,
                    Rating = 4,
                    Content = "Industrial vibe is cool. Coffee is strong and good. Would come back.",
                    Likes = 29,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-11)
                },
                new Review
                {
                    UserId = users[9].Id,
                    CoffeeShopId = coffeeShops[0].Id,
                    Rating = 5,
                    Content = "Absolutely love this place! The staff is friendly and the coffee is top notch.",
                    Likes = 56,
                    IsVerified = true,
                    CreatedAt = DateTime.UtcNow.AddDays(-13)
                }
            };
            
            context.Reviews.AddRange(reviews);
            context.SaveChanges();
            
            // ==================== 4. POSTS (15 community posts) ====================
            var posts = new Post[]
            {
                new Post
                {
                    UserId = users[0].Id,
                    Content = "Just discovered the most amazing pour-over at The Roasted Bean! Anyone else tried their Ethiopian Yirgacheffe? ☕️✨",
                    Images = null,
                    CoffeeShopId = coffeeShops[0].Id,
                    Likes = 45,
                    Comment = 12,
                    CreatedAt = DateTime.UtcNow.AddHours(-3)
                },
                new Post
                {
                    UserId = users[1].Id,
                    Content = "Does anyone know a good coffee shop with outdoor seating and fast WiFi? Need a new remote work spot! 💻🌿",
                    Images = null,
                    CoffeeShopId = null,
                    Likes = 23,
                    Comment = 8,
                    CreatedAt = DateTime.UtcNow.AddHours(-5)
                },
                new Post
                {
                    UserId = users[2].Id,
                    Content = "Finally found a quiet place to read! Pages & Steam is a book lover's paradise. No laptops after 6 PM is actually a blessing. 📖",
                    Images = null,
                    CoffeeShopId = coffeeShops[2].Id,
                    Likes = 67,
                    Comment = 15,
                    CreatedAt = DateTime.UtcNow.AddDays(-1)
                },
                new Post
                {
                    UserId = users[3].Id,
                    Content = "The Rain Lab is my new happy place! The lo-fi beats and industrial vibe are perfect for getting work done. Highly recommend! 🎧",
                    Images = "[\"https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400\"]",
                    CoffeeShopId = coffeeShops[4].Id,
                    Likes = 89,
                    Comment = 24,
                    CreatedAt = DateTime.UtcNow.AddDays(-2)
                },
                new Post
                {
                    UserId = users[4].Id,
                    Content = "Morning routine: hike at Azure Peaks then coffee. Best way to start the day! Who's joining? 🏔️☕",
                    Images = null,
                    CoffeeShopId = coffeeShops[5].Id,
                    Likes = 34,
                    Comment = 7,
                    CreatedAt = DateTime.UtcNow.AddDays(-3)
                },
                new Post
                {
                    UserId = users[5].Id,
                    Content = "Cedar & Smoke has the best croissants in town! Flaky, buttery, perfect. What's your go-to bakery item? 🥐",
                    Images = "[\"https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400\"]",
                    CoffeeShopId = coffeeShops[6].Id,
                    Likes = 56,
                    Comment = 18,
                    CreatedAt = DateTime.UtcNow.AddDays(-4)
                },
                new Post
                {
                    UserId = users[6].Id,
                    Content = "Working from Steam & Steel today. The industrial aesthetic and strong coffee are giving me life! 💪☕",
                    Images = null,
                    CoffeeShopId = coffeeShops[7].Id,
                    Likes = 41,
                    Comment = 9,
                    CreatedAt = DateTime.UtcNow.AddDays(-5)
                },
                new Post
                {
                    UserId = users[7].Id,
                    Content = "The Greenhouse is like a tropical paradise! So many plants, so peaceful. Best place to escape the city stress. 🌿🌺",
                    Images = "[\"https://images.unsplash.com/photo-1536240476400-bc1b8a3e7c5f?w=400\"]",
                    CoffeeShopId = coffeeShops[8].Id,
                    Likes = 78,
                    Comment = 22,
                    CreatedAt = DateTime.UtcNow.AddDays(-6)
                },
                new Post
                {
                    UserId = users[8].Id,
                    Content = "Question: What's your favorite coffee drink to order when trying a new shop? I usually go for a flat white to test the quality. ☕🤔",
                    Images = null,
                    CoffeeShopId = null,
                    Likes = 92,
                    Comment = 31,
                    CreatedAt = DateTime.UtcNow.AddDays(-7)
                },
                new Post
                {
                    UserId = users[9].Id,
                    Content = "Just had the best breakfast sandwich at The Morning Brew! The coffee is amazing too. Highly recommend this local gem! 🍳☕",
                    Images = null,
                    CoffeeShopId = coffeeShops[9].Id,
                    Likes = 63,
                    Comment = 14,
                    CreatedAt = DateTime.UtcNow.AddDays(-8)
                },
                new Post
                {
                    UserId = users[0].Id,
                    Content = "Anyone been to The Arch Brews? I've heard great things about their espresso blends. Worth the visit? 🤔",
                    Images = null,
                    CoffeeShopId = coffeeShops[1].Id,
                    Likes = 28,
                    Comment = 11,
                    CreatedAt = DateTime.UtcNow.AddDays(-9)
                },
                new Post
                {
                    UserId = users[1].Id,
                    Content = "Wild Garden Loft is beautiful! Working surrounded by plants is so refreshing. Their matcha latte is a must-try. 🌿🍵",
                    Images = "[\"https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=400\"]",
                    CoffeeShopId = coffeeShops[3].Id,
                    Likes = 71,
                    Comment = 19,
                    CreatedAt = DateTime.UtcNow.AddDays(-10)
                },
                new Post
                {
                    UserId = users[2].Id,
                    Content = "Looking for coffee shop recommendations with great pastries! Any hidden gems? 🥐☕",
                    Images = null,
                    CoffeeShopId = null,
                    Likes = 37,
                    Comment = 23,
                    CreatedAt = DateTime.UtcNow.AddDays(-11)
                },
                new Post
                {
                    UserId = users[3].Id,
                    Content = "Just discovered that The Rain Lab has a secret menu! Ask for the 'Rainy Day' special - you won't regret it. 🤫☕",
                    Images = null,
                    CoffeeShopId = coffeeShops[4].Id,
                    Likes = 112,
                    Comment = 45,
                    CreatedAt = DateTime.UtcNow.AddDays(-12)
                },
                new Post
                {
                    UserId = users[4].Id,
                    Content = "Best study spots in the city? Looking for somewhere quiet with good coffee and power outlets. Drop your recommendations! 📚💻",
                    Images = null,
                    CoffeeShopId = null,
                    Likes = 84,
                    Comment = 27,
                    CreatedAt = DateTime.UtcNow.AddDays(-14)
                }
            };
            
            context.Posts.AddRange(posts);
            context.SaveChanges();
            
            // ==================== 5. COMMENTS (20 comments for posts) ====================
            var comments = new Comment[]
            {
                new Comment { PostId = posts[0].Id, UserId = users[1].Id, Content = "I love their Ethiopian beans! So smooth.", CreatedAt = DateTime.UtcNow.AddHours(-2) },
                new Comment { PostId = posts[0].Id, UserId = users[2].Id, Content = "Need to try this place! Sounds amazing ☕", CreatedAt = DateTime.UtcNow.AddHours(-1) },
                new Comment { PostId = posts[0].Id, UserId = users[3].Id, Content = "Their pour-over is definitely top tier!", CreatedAt = DateTime.UtcNow.AddHours(-1) },
                
                new Comment { PostId = posts[1].Id, UserId = users[4].Id, Content = "Wild Garden Loft has great outdoor seating and WiFi!", CreatedAt = DateTime.UtcNow.AddHours(-4) },
                new Comment { PostId = posts[1].Id, UserId = users[5].Id, Content = "The Greenhouse also has amazing outdoor space 🌿", CreatedAt = DateTime.UtcNow.AddHours(-3) },
                
                new Comment { PostId = posts[2].Id, UserId = users[6].Id, Content = "I love this place! So peaceful for reading.", CreatedAt = DateTime.UtcNow.AddDays(-1).AddHours(-5) },
                new Comment { PostId = posts[2].Id, UserId = users[7].Id, Content = "No laptops rule is actually really nice.", CreatedAt = DateTime.UtcNow.AddDays(-1).AddHours(-4) },
                new Comment { PostId = posts[2].Id, UserId = users[8].Id, Content = "Adding to my reading list! 📚", CreatedAt = DateTime.UtcNow.AddDays(-1).AddHours(-3) },
                
                new Comment { PostId = posts[3].Id, UserId = users[9].Id, Content = "The Rain Lab is my favorite! The vibe is unmatched.", CreatedAt = DateTime.UtcNow.AddDays(-2).AddHours(-5) },
                new Comment { PostId = posts[3].Id, UserId = users[0].Id, Content = "Glad you love it! Their cold brew is amazing too.", CreatedAt = DateTime.UtcNow.AddDays(-2).AddHours(-4) },
                new Comment { PostId = posts[3].Id, UserId = users[1].Id, Content = "The lo-fi playlist is chef's kiss 👌", CreatedAt = DateTime.UtcNow.AddDays(-2).AddHours(-3) },
                
                new Comment { PostId = posts[4].Id, UserId = users[2].Id, Content = "That sounds like an amazing morning routine!", CreatedAt = DateTime.UtcNow.AddDays(-3).AddHours(-2) },
                new Comment { PostId = posts[4].Id, UserId = users[3].Id, Content = "I need to check out Azure Peaks!", CreatedAt = DateTime.UtcNow.AddDays(-3).AddHours(-1) },
                
                new Comment { PostId = posts[5].Id, UserId = users[4].Id, Content = "Their almond croissant is my absolute favorite! 🥐", CreatedAt = DateTime.UtcNow.AddDays(-4).AddHours(-3) },
                new Comment { PostId = posts[5].Id, UserId = users[5].Id, Content = "Cedar & Smoke is a hidden gem!", CreatedAt = DateTime.UtcNow.AddDays(-4).AddHours(-2) },
                
                new Comment { PostId = posts[6].Id, UserId = users[6].Id, Content = "Industrial aesthetic is so cool! Great for productivity.", CreatedAt = DateTime.UtcNow.AddDays(-5).AddHours(-4) },
                new Comment { PostId = posts[6].Id, UserId = users[7].Id, Content = "The coffee there is strong 💪", CreatedAt = DateTime.UtcNow.AddDays(-5).AddHours(-3) },
                
                new Comment { PostId = posts[7].Id, UserId = users[8].Id, Content = "The Greenhouse is my happy place! So peaceful.", CreatedAt = DateTime.UtcNow.AddDays(-6).AddHours(-2) },
                new Comment { PostId = posts[7].Id, UserId = users[9].Id, Content = "I need to visit! Sounds amazing 🌿", CreatedAt = DateTime.UtcNow.AddDays(-6).AddHours(-1) },
                
                new Comment { PostId = posts[8].Id, UserId = users[0].Id, Content = "Flat white is the best test! Great choice.", CreatedAt = DateTime.UtcNow.AddDays(-7).AddHours(-5) },
                new Comment { PostId = posts[8].Id, UserId = users[1].Id, Content = "I always order a cortado to test quality!", CreatedAt = DateTime.UtcNow.AddDays(-7).AddHours(-4) },
                new Comment { PostId = posts[8].Id, UserId = users[2].Id, Content = "Espresso is the true test of a coffee shop ☕", CreatedAt = DateTime.UtcNow.AddDays(-7).AddHours(-3) }
            };
            
            context.Comments.AddRange(comments);
            context.SaveChanges();
            
           
           // ==================== 6. DAILY CODES (mã code check-in hàng ngày) ====================
            var dailyCodes = new DailyCode[]
            {
                new DailyCode { CoffeeShopId = coffeeShops[0].Id, Code = "12345", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow },
                new DailyCode { CoffeeShopId = coffeeShops[1].Id, Code = "23456", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow },
                new DailyCode { CoffeeShopId = coffeeShops[2].Id, Code = "34567", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow },
                new DailyCode { CoffeeShopId = coffeeShops[3].Id, Code = "45678", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow },
                new DailyCode { CoffeeShopId = coffeeShops[4].Id, Code = "56789", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow },
                new DailyCode { CoffeeShopId = coffeeShops[5].Id, Code = "67890", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow },
                new DailyCode { CoffeeShopId = coffeeShops[6].Id, Code = "78901", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow },
                new DailyCode { CoffeeShopId = coffeeShops[7].Id, Code = "89012", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow },
                new DailyCode { CoffeeShopId = coffeeShops[8].Id, Code = "90123", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow },
                new DailyCode { CoffeeShopId = coffeeShops[9].Id, Code = "01234", ExpiryDate = DateTime.UtcNow.Date, IsActive = true, CreatedAt = DateTime.UtcNow }
            };

            context.DailyCodes.AddRange(dailyCodes);
            context.SaveChanges();

            
            // ==================== 7. CHECK-INS (20 check-ins) ====================
            var checkIns = new CheckIn[]
            {
                new CheckIn { UserId = users[0].Id, CoffeeShopId = coffeeShops[0].Id, CheckInTime = DateTime.UtcNow.AddDays(-2), PointsEarned = 10 },
                new CheckIn { UserId = users[0].Id, CoffeeShopId = coffeeShops[4].Id, CheckInTime = DateTime.UtcNow.AddDays(-5), PointsEarned = 10 },
                new CheckIn { UserId = users[0].Id, CoffeeShopId = coffeeShops[6].Id, CheckInTime = DateTime.UtcNow.AddDays(-8), PointsEarned = 10 },
                new CheckIn { UserId = users[0].Id, CoffeeShopId = coffeeShops[9].Id, CheckInTime = DateTime.UtcNow.AddDays(-12), PointsEarned = 10 },
                new CheckIn { UserId = users[1].Id, CoffeeShopId = coffeeShops[0].Id, CheckInTime = DateTime.UtcNow.AddDays(-3), PointsEarned = 10 },
                new CheckIn { UserId = users[1].Id, CoffeeShopId = coffeeShops[2].Id, CheckInTime = DateTime.UtcNow.AddDays(-6), PointsEarned = 10 },
                new CheckIn { UserId = users[1].Id, CoffeeShopId = coffeeShops[4].Id, CheckInTime = DateTime.UtcNow.AddDays(-10), PointsEarned = 10 },
                new CheckIn { UserId = users[2].Id, CoffeeShopId = coffeeShops[1].Id, CheckInTime = DateTime.UtcNow.AddDays(-4), PointsEarned = 10 },
                new CheckIn { UserId = users[3].Id, CoffeeShopId = coffeeShops[3].Id, CheckInTime = DateTime.UtcNow.AddDays(-1), PointsEarned = 10 },
                new CheckIn { UserId = users[3].Id, CoffeeShopId = coffeeShops[8].Id, CheckInTime = DateTime.UtcNow.AddDays(-7), PointsEarned = 10 },
                new CheckIn { UserId = users[4].Id, CoffeeShopId = coffeeShops[5].Id, CheckInTime = DateTime.UtcNow.AddDays(-9), PointsEarned = 10 },
                new CheckIn { UserId = users[5].Id, CoffeeShopId = coffeeShops[6].Id, CheckInTime = DateTime.UtcNow.AddDays(-11), PointsEarned = 10 },
                new CheckIn { UserId = users[5].Id, CoffeeShopId = coffeeShops[0].Id, CheckInTime = DateTime.UtcNow.AddDays(-14), PointsEarned = 10 },
                new CheckIn { UserId = users[6].Id, CoffeeShopId = coffeeShops[7].Id, CheckInTime = DateTime.UtcNow.AddDays(-3), PointsEarned = 10 },
                new CheckIn { UserId = users[7].Id, CoffeeShopId = coffeeShops[8].Id, CheckInTime = DateTime.UtcNow.AddDays(-5), PointsEarned = 10 },
                new CheckIn { UserId = users[8].Id, CoffeeShopId = coffeeShops[9].Id, CheckInTime = DateTime.UtcNow.AddDays(-2), PointsEarned = 10 },
                new CheckIn { UserId = users[8].Id, CoffeeShopId = coffeeShops[1].Id, CheckInTime = DateTime.UtcNow.AddDays(-15), PointsEarned = 10 },
                new CheckIn { UserId = users[9].Id, CoffeeShopId = coffeeShops[2].Id, CheckInTime = DateTime.UtcNow.AddDays(-6), PointsEarned = 10 },
                new CheckIn { UserId = users[0].Id, CoffeeShopId = coffeeShops[2].Id, CheckInTime = DateTime.UtcNow.AddDays(-18), PointsEarned = 10 },
                new CheckIn { UserId = users[1].Id, CoffeeShopId = coffeeShops[8].Id, CheckInTime = DateTime.UtcNow.AddDays(-20), PointsEarned = 10 }
            };
            
            context.CheckIns.AddRange(checkIns);
            context.SaveChanges();
            
            // ==================== 8. FAVORITES (15 favorites) ====================
            var favorites = new Favorite[]
            {
                new Favorite { UserId = users[0].Id, CoffeeShopId = coffeeShops[0].Id, CreatedAt = DateTime.UtcNow.AddDays(-10) },
                new Favorite { UserId = users[0].Id, CoffeeShopId = coffeeShops[4].Id, CreatedAt = DateTime.UtcNow.AddDays(-10) },
                new Favorite { UserId = users[0].Id, CoffeeShopId = coffeeShops[9].Id, CreatedAt = DateTime.UtcNow.AddDays(-10) },
                new Favorite { UserId = users[1].Id, CoffeeShopId = coffeeShops[2].Id, CreatedAt = DateTime.UtcNow.AddDays(-8) },
                new Favorite { UserId = users[1].Id, CoffeeShopId = coffeeShops[5].Id, CreatedAt = DateTime.UtcNow.AddDays(-8) },
                new Favorite { UserId = users[2].Id, CoffeeShopId = coffeeShops[1].Id, CreatedAt = DateTime.UtcNow.AddDays(-5) },
                new Favorite { UserId = users[3].Id, CoffeeShopId = coffeeShops[3].Id, CreatedAt = DateTime.UtcNow.AddDays(-7) },
                new Favorite { UserId = users[3].Id, CoffeeShopId = coffeeShops[8].Id, CreatedAt = DateTime.UtcNow.AddDays(-7) },
                new Favorite { UserId = users[4].Id, CoffeeShopId = coffeeShops[6].Id, CreatedAt = DateTime.UtcNow.AddDays(-4) },
                new Favorite { UserId = users[5].Id, CoffeeShopId = coffeeShops[4].Id, CreatedAt = DateTime.UtcNow.AddDays(-6) },
                new Favorite { UserId = users[6].Id, CoffeeShopId = coffeeShops[7].Id, CreatedAt = DateTime.UtcNow.AddDays(-3) },
                new Favorite { UserId = users[7].Id, CoffeeShopId = coffeeShops[9].Id, CreatedAt = DateTime.UtcNow.AddDays(-9) },
                new Favorite { UserId = users[8].Id, CoffeeShopId = coffeeShops[0].Id, CreatedAt = DateTime.UtcNow.AddDays(-12) },
                new Favorite { UserId = users[8].Id, CoffeeShopId = coffeeShops[2].Id, CreatedAt = DateTime.UtcNow.AddDays(-12) },
                new Favorite { UserId = users[9].Id, CoffeeShopId = coffeeShops[5].Id, CreatedAt = DateTime.UtcNow.AddDays(-2) }
            };
            
            context.Favorites.AddRange(favorites);
            context.SaveChanges();

            
        }
        
    }
    
}