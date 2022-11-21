using System;
using Microsoft.EntityFrameworkCore;

namespace FusionDev.Samples.TodoApi.Controllers
{
    public static class DataInitializer
    {
        public static void Init(this TodoContext ctx)
        {
            var seed = new Random();
            ctx.TodoItems.AddRange(
                new TodoItem() { 
                    Id = 100, Title = "Task1", Status = "Active", Task = "経費を清算する", 
                    UpdatedOn = DateTimeOffset.Now.AddDays(-seed.Next(1, 5)), Duedate = DateTime.Now.AddDays(seed.Next(1, 5)) },
                new TodoItem() { 
                    Id = 200, Title = "Task2", Status = "Done", Task = "出張を申請する", 
                    UpdatedOn = DateTimeOffset.Now.AddDays(-seed.Next(1, 5)), Duedate = DateTime.Now.AddDays(seed.Next(1, 5)) },
                new TodoItem() { 
                    Id = 300, Title = "Task3", Status = "Active", Task = "体温を報告する", 
                    UpdatedOn = DateTimeOffset.Now.AddDays(-seed.Next(1, 5)), Duedate = DateTime.Now.AddDays(seed.Next(1, 5)) }
            );
            ctx.SaveChanges();
        }
    }

}