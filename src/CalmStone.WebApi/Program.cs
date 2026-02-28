using Api.Data;
using Api.Middleware.MultiTenancy;
using Microsoft.Azure.Cosmos;

var builder = WebApplication.CreateBuilder(args);

Console.WriteLine(builder.Configuration["ApplicationInsights:ConnectionString"]);
builder.Services.AddApplicationInsightsTelemetry();
builder.Services.AddSingleton(sp =>
{
    var configuration = sp.GetRequiredService<IConfiguration>();

    var connectionString = configuration["Cosmos:ConnectionString"];
    var databaseName = configuration["Cosmos:DatabaseName"];

    var client = new CosmosClient(connectionString);

    return client.GetDatabase(databaseName);
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<ITenantContextAccessor, TenantContextAccessor>();
builder.Services.AddScoped<TenantResolutionMiddleware>();
builder.Services.AddScoped<NoteRepository>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.UseMiddleware<TenantResolutionMiddleware>();

app.MapControllers();

app.Run();
