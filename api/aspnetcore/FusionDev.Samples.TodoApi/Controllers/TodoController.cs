//----------------------
// <auto-generated>
//     Generated using the NSwag toolchain v13.16.1.0 (NJsonSchema v10.7.2.0 (Newtonsoft.Json v11.0.0.0)) (http://NSwag.org)
// </auto-generated>
//----------------------

#pragma warning disable 108 // Disable "CS0108 '{derivedDto}.ToJson()' hides inherited member '{dtoBase}.ToJson()'. Use the new keyword if hiding was intended."
#pragma warning disable 114 // Disable "CS0114 '{derivedDto}.RaisePropertyChanged(String)' hides inherited member 'dtoBase.RaisePropertyChanged(String)'. To make the current member override that implementation, add the override keyword. Otherwise add the new keyword."
#pragma warning disable 472 // Disable "CS0472 The result of the expression is always 'false' since a value of type 'Int32' is never equal to 'null' of type 'Int32?'
#pragma warning disable 1573 // Disable "CS1573 Parameter '...' has no matching param tag in the XML comment for ...
#pragma warning disable 1591 // Disable "CS1591 Missing XML comment for publicly visible type or member ..."
#pragma warning disable 8073 // Disable "CS8073 The result of the expression is always 'false' since a value of type 'T' is never equal to 'null' of type 'T?'"
#pragma warning disable 3016 // Disable "CS3016 Arrays as attribute arguments is not CLS-compliant"
#pragma warning disable 8603 // Disable "CS8603 Possible null reference return"

namespace FusionDev.Samples.TodoApi.Controllers
{
    using System = global::System;

    [System.CodeDom.Compiler.GeneratedCode("NSwag", "13.16.1.0 (NJsonSchema v10.7.2.0 (Newtonsoft.Json v11.0.0.0))")]
    public interface ITodoController
    {

        /// <summary>
        /// Get Todo Item
        /// </summary>


        /// <returns>successful operation</returns>

        System.Threading.Tasks.Task<TodoItem> GetTodoByIdAsync(int id);

        /// <summary>
        /// Update Todo Item
        /// </summary>


        /// <returns>successful operation</returns>

        System.Threading.Tasks.Task<TodoItem> UpdateTodoByIdAsync(int id, TodoItem body);

        /// <summary>
        /// Delete Todo Item
        /// </summary>


        /// <returns>successful operation</returns>

        System.Threading.Tasks.Task<TodoItem> DeleteTodoByIdAsync(int id);

        /// <summary>
        /// List All Todo Item
        /// </summary>

        /// <returns>successful operation</returns>

        System.Threading.Tasks.Task<System.Collections.Generic.ICollection<TodoItem>> ListAllTodoItemAsync();

        /// <summary>
        /// Create Todo Item
        /// </summary>


        /// <returns>Todo created</returns>

        System.Threading.Tasks.Task<TodoItem> CreateTodoItemAsync(TodoItem body);

    }

    [System.CodeDom.Compiler.GeneratedCode("NSwag", "13.16.1.0 (NJsonSchema v10.7.2.0 (Newtonsoft.Json v11.0.0.0))")]
    [Microsoft.AspNetCore.Mvc.Route("todos/v1")]

    public partial class TodoController : Microsoft.AspNetCore.Mvc.ControllerBase
    {
        private ITodoController _implementation;

        public TodoController(ITodoController implementation)
        {
            _implementation = implementation;
        }

        /// <summary>
        /// Get Todo Item
        /// </summary>
        /// <returns>successful operation</returns>
        [Microsoft.AspNetCore.Mvc.HttpGet, Microsoft.AspNetCore.Mvc.Route("{id}")]
        public System.Threading.Tasks.Task<TodoItem> GetTodoById(int id)
        {

            return _implementation.GetTodoByIdAsync(id);
        }

        /// <summary>
        /// Update Todo Item
        /// </summary>
        /// <returns>successful operation</returns>
        [Microsoft.AspNetCore.Mvc.HttpPut, Microsoft.AspNetCore.Mvc.Route("{id}")]
        public System.Threading.Tasks.Task<TodoItem> UpdateTodoById(int id, [Microsoft.AspNetCore.Mvc.FromBody] TodoItem body)
        {

            return _implementation.UpdateTodoByIdAsync(id, body);
        }

        /// <summary>
        /// Delete Todo Item
        /// </summary>
        /// <returns>successful operation</returns>
        [Microsoft.AspNetCore.Mvc.HttpDelete, Microsoft.AspNetCore.Mvc.Route("{id}")]
        public System.Threading.Tasks.Task<TodoItem> DeleteTodoById(int id)
        {

            return _implementation.DeleteTodoByIdAsync(id);
        }

        /// <summary>
        /// List All Todo Item
        /// </summary>
        /// <returns>successful operation</returns>
        [Microsoft.AspNetCore.Mvc.HttpGet, Microsoft.AspNetCore.Mvc.Route("")]
        public System.Threading.Tasks.Task<System.Collections.Generic.ICollection<TodoItem>> ListAllTodoItem()
        {

            return _implementation.ListAllTodoItemAsync();
        }

        /// <summary>
        /// Create Todo Item
        /// </summary>
        /// <returns>Todo created</returns>
        [Microsoft.AspNetCore.Mvc.HttpPost, Microsoft.AspNetCore.Mvc.Route("")]
        public System.Threading.Tasks.Task<TodoItem> CreateTodoItem([Microsoft.AspNetCore.Mvc.FromBody] TodoItem body)
        {

            return _implementation.CreateTodoItemAsync(body);
        }

    }

    [System.CodeDom.Compiler.GeneratedCode("NJsonSchema", "13.16.1.0 (NJsonSchema v10.7.2.0 (Newtonsoft.Json v11.0.0.0))")]
    public partial class TodoItem
    {
        [Newtonsoft.Json.JsonProperty("id", Required = Newtonsoft.Json.Required.DisallowNull, NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore)]
        public int Id { get; set; }

        [Newtonsoft.Json.JsonProperty("title", Required = Newtonsoft.Json.Required.DisallowNull, NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore)]
        public string Title { get; set; }

        [Newtonsoft.Json.JsonProperty("task", Required = Newtonsoft.Json.Required.DisallowNull, NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore)]
        public string Task { get; set; }

        [Newtonsoft.Json.JsonProperty("status", Required = Newtonsoft.Json.Required.DisallowNull, NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore)]
        public string Status { get; set; }

        [Newtonsoft.Json.JsonProperty("duedate", Required = Newtonsoft.Json.Required.DisallowNull, NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore)]
        [Newtonsoft.Json.JsonConverter(typeof(DateFormatConverter))]
        public System.DateTimeOffset Duedate { get; set; }

        [Newtonsoft.Json.JsonProperty("updatedOn", Required = Newtonsoft.Json.Required.DisallowNull, NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore)]
        public System.DateTimeOffset UpdatedOn { get; set; }

        private System.Collections.Generic.IDictionary<string, object> _additionalProperties = new System.Collections.Generic.Dictionary<string, object>();

        [Newtonsoft.Json.JsonExtensionData]
        public System.Collections.Generic.IDictionary<string, object> AdditionalProperties
        {
            get { return _additionalProperties; }
            set { _additionalProperties = value; }
        }

    }

    [System.CodeDom.Compiler.GeneratedCode("NJsonSchema", "13.16.1.0 (NJsonSchema v10.7.2.0 (Newtonsoft.Json v11.0.0.0))")]
    public partial class TodoList : System.Collections.ObjectModel.Collection<TodoItem>
    {

    }

    [System.CodeDom.Compiler.GeneratedCode("NJsonSchema", "13.16.1.0 (NJsonSchema v10.7.2.0 (Newtonsoft.Json v11.0.0.0))")]
    internal class DateFormatConverter : Newtonsoft.Json.Converters.IsoDateTimeConverter
    {
        public DateFormatConverter()
        {
            DateTimeFormat = "yyyy-MM-dd";
        }
    }


}

#pragma warning restore 1591
#pragma warning restore 1573
#pragma warning restore  472
#pragma warning restore  114
#pragma warning restore  108
#pragma warning restore 3016
#pragma warning restore 8603