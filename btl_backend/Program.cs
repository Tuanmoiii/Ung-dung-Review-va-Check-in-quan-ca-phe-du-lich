using Microsoft.EntityFrameworkCore;
using btl_backend.Data;
using btl_backend.Models;
using Microsoft.Extensions.Logging;

var builder = WebApplication.CreateBuilder(args);

// Đọc connection string từ appsettings hoặc environment
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Nếu có environment variable DATABASE_URL thì dùng (cho Render)
var envConnection = Environment.GetEnvironmentVariable("DATABASE_URL");
if (!string.IsNullOrEmpty(envConnection))
{
    connectionString = envConnection;
}

// Mặc định dùng SQLite
if (string.IsNullOrEmpty(connectionString))
{
    connectionString = "Data Source=coffeereview.db";
}

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add DbContext - dùng SQLite
builder.Services.AddDbContext<ApplicationDbContext>(options =>
{
    options.UseSqlite(connectionString);
    Console.WriteLine("Using SQLite database");
});

// Add CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.SetIsOriginAllowed(origin => true)
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowAll");
app.UseAuthorization();
app.MapControllers();

// Seed database
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<ApplicationDbContext>();
        
        // Tạo database và tables nếu chưa có
        context.Database.EnsureCreated();
        Console.WriteLine("Database created successfully!");
        
        // Seed data
        SeedData.Initialize(services);
        Console.WriteLine("Database seeded successfully!");
    }
    catch (Exception ex)
    {
        var logger = services.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "An error occurred while seeding the database.");
        Console.WriteLine($"Error: {ex.Message}");
    }
}

app.Run();