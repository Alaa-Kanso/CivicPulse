using Microsoft.EntityFrameworkCore;
using CivicPulse.Infrastructure.Data;
using CivicPulse.Api.Services.Security;
using CivicPulse.Api.Settings;
using CivicPulse.Api.Startup;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<CivicPulseDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("CivicPulseDb")));

builder.Services.AddSingleton<IPasswordHasher, BcryptPasswordHasher>();

builder.Services.Configure<AdminSeedOptions>(
    builder.Configuration.GetSection("AdminSeed"));

var app = builder.Build();

await AdminSeeder.SeedAsync(app.Services);

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
