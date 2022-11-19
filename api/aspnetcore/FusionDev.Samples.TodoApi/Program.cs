using FusionDev.Samples.TodoApi.Controllers;
using Microsoft.EntityFrameworkCore;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddScoped<ITodoController, TodoControllerImpl2>();

builder.Services.AddDbContext<TodoContext>( opt => opt.UseInMemoryDatabase("TodoList"));

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerDocument();

var app = builder.Build();

using(var scope = app.Services.CreateScope())
{
    var tdc = scope.ServiceProvider.GetService<TodoContext>();
    if(tdc != null)
    {
        tdc.Database.EnsureCreated();
        tdc.Init();

    }

}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseOpenApi();
    app.UseSwaggerUi3();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();



app.Run();
