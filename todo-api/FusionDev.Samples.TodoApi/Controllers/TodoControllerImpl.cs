using System;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace FusionDev.Samples.TodoApi.Controllers
{
    public class TodoControllerImpl2 : ITodoController
    {
        private IConfiguration config;

        private ILogger<TodoControllerImpl2> logger;

        private TodoContext context;

        public TodoControllerImpl2(IConfiguration config, ILogger<TodoControllerImpl2> logger, TodoContext context)
        {
            this.config = config;
            this.logger = logger;
            this.context = context;
        }

        async Task<ActionResult<IEnumerable<TodoItem>>> ITodoController.ListAllTodoItemAsync()
        {
            this.logger.LogInformation("listing items...");
            var ret = await this.context.TodoItems.ToListAsync();
            return new OkObjectResult(ret);
        }

        async Task<ActionResult<TodoItem>> ITodoController.GetTodoByIdAsync(int id)
        {
            this.logger.LogInformation("Finding items...");
            var ret = await this.context.TodoItems.FindAsync(id);
            if(ret == null)
            {
                return new NotFoundResult();
            }
            return new OkObjectResult(ret);
        }
        async Task<ActionResult<TodoItem>> ITodoController.CreateTodoItemAsync(TodoItem body)
        {
            this.logger.LogInformation("Creating items...");
            await this.context.TodoItems.AddAsync(body);
            await this.context.SaveChangesAsync();
            // return new CreatedAtActionResult(
            //     nameof(TodoController.GetTodoById), 
            //     nameof(TodoController), 
            //     new {id = body.Id},
            //     body  );
                        return new CreatedAtActionResult("GetTodoById", "Todo",

                new {id = body.Id},
                body  );

        }


        async Task<ActionResult<TodoItem>> ITodoController.UpdateTodoByIdAsync(int id, TodoItem body)
        {
            this.logger.LogInformation("Updating items...");

            if(id != body.Id)
                return new BadRequestResult();

            context.Entry(body).State = EntityState.Modified;
            await context.SaveChangesAsync();
            return body;
        }

        async Task<ActionResult<TodoItem>> ITodoController.DeleteTodoByIdAsync(int id)
        {
            this.logger.LogInformation("Deleting items...");

            var item = await context.TodoItems.FindAsync(id);
            if(item == null)
                return new NotFoundResult();

            context.TodoItems.Remove(item);
            await context.SaveChangesAsync();
            return item;
            
        }

    }
}
