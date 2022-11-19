using System;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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

        async Task<ActionResult<TodoItem>> ITodoController.GetTodoByIdAsync(int id)
        {
            var ret = await this.context.TodoItems.FindAsync(id);
            return new OkObjectResult(ret);
        }

        Task<ActionResult<TodoItem>> ITodoController.UpdateTodoByIdAsync(int id, TodoItem body)
        {
            throw new NotImplementedException();
        }

        Task<ActionResult<TodoItem>> ITodoController.DeleteTodoByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        async Task<ActionResult<IEnumerable<TodoItem>>> ITodoController.ListAllTodoItemAsync()
        {
            var ret = await this.context.TodoItems.ToListAsync();
            return new OkObjectResult(ret);
        }

        Task<ActionResult<TodoItem>> ITodoController.CreateTodoItemAsync(TodoItem body)
        {
            throw new NotImplementedException();
        }
    }
}
