using System;

namespace FusionDev.Samples.TodoApi.Controllers
{
    public class TodoControllerImpl : ITodoController
    {
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
            var seed = new Random();
            
            ICollection<TodoItem> ret = new List<TodoItem>() {
                new TodoItem() { 
                    Id = 1, Title = "Task1", Status = "Active", Task = "経費を清算する", 
                    UpdatedOn = DateTimeOffset.Now.AddDays(-seed.Next(1, 5)), Duedate = DateTime.Now.AddDays(seed.Next(1, 5)) },
                new TodoItem() { 
                    Id = 2, Title = "Task2", Status = "Done", Task = "出張を申請する", 
                    UpdatedOn = DateTimeOffset.Now.AddDays(-seed.Next(1, 5)), Duedate = DateTime.Now.AddDays(seed.Next(1, 5)) },
                new TodoItem() { 
                    Id = 3, Title = "Task3", Status = "Active", Task = "体温を報告する", 
                    UpdatedOn = DateTimeOffset.Now.AddDays(-seed.Next(1, 5)), Duedate = DateTime.Now.AddDays(seed.Next(1, 5)) }
                };

            return Task.FromResult(ret);
            //return Task.FromResult(
            //    );
        }

        public Task<TodoItem> UpdateTodoByIdAsync(int id, TodoItem body)
        {
            throw new NotImplementedException();
        }
    }
}