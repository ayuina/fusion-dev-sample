using System;

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

        public Task<TodoItem> CreateTodoItemAsync(TodoItem body)
        {
            throw new NotImplementedException();
        }

        public Task<TodoItem> DeleteTodoByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<TodoItem> GetTodoByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<ICollection<TodoItem>> ListAllTodoItemAsync()
        {
            throw new NotImplementedException();
        }

        public Task<TodoItem> UpdateTodoByIdAsync(int id, TodoItem body)
        {
            throw new NotImplementedException();
        }
    }
}
