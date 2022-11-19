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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<TodoItem>().Ignore(c => c.AdditionalProperties);
        }
    }
}