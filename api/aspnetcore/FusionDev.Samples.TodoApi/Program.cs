var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

//remove swachbackle
//builder.Services.AddSwaggerGen();

// Register the Swagger services
builder.Services.AddSwaggerDocument();

// Register Todo Controller Implementation
builder.Services.AddSingleton(
        typeof(FusionDev.Samples.TodoApi.Controllers.ITodoController),
        new FusionDev.Samples.TodoApi.Controllers.TodoControllerImpl());

builder.Services.AddApplicationInsightsTelemetry();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    //remove swachbackle
    //app.UseSwagger();
    //app.UseSwaggerUI();

    // Register the Swagger generator and the Swagger UI middlewares
    app.UseOpenApi();
    app.UseSwaggerUi3();
}

//app.UseHttpsRedirection();

//app.UseAuthorization();

app.MapControllers();

app.Run();
