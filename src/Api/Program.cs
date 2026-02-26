using Api.Middleware.MultiTenancy;

var builder = WebApplication.CreateBuilder(args);

Console.WriteLine(builder.Configuration["ApplicationInsights:ConnectionString"]);
builder.Services.AddApplicationInsightsTelemetry();

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Multi-tenancy services.
builder.Services.AddScoped<ITenantContextAccessor, TenantContextAccessor>();
builder.Services.AddScoped<TenantResolutionMiddleware>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.UseMiddleware<TenantResolutionMiddleware>(); // Before controllers to ensure tenant context is available

app.MapControllers();

app.Run();
