using System;
using Microsoft.EntityFrameworkCore;

namespace FusionDev.Samples.TodoApi.Controllers
{
    public class TodoContext : DbContext
    {
        public TodoContext(DbContextOptions options) : base(options)
        {

        }

        public DbSet<TodoItem> TodoItems { get; set; } = null!;

    }
}