
# ASP.NET Core Web API

```powershell
dotnet new webapi -o FusionDev.Samples.TodoApi
dotnet remove package Swashbuckle.AspNetCore
dotnet add package NSwag.AspNetCore
 del .\FusionDev.Samples.TodoApi\Controllers\WeatherForecastController.cs
```

# NSwag

- [NSwag と ASP.NET Core の概要](https://learn.microsoft.com/ja-jp/aspnet/core/tutorials/getting-started-with-nswag?view=aspnetcore-6.0&tabs=visual-studio)

```powershell
# install from  winget
winget install --id RicoSuter.NSwagStudio --version 13.16.1.0 

# create controller from open api spec file
& 'C:\Program Files (x86)\Rico Suter\NSwagStudio\nswag.cmd' openapi2cscontroller `
    /input:..\..\todo-api-spec.json `
    /output:.\FusionDev.Samples.TodoApi\Controllers\TodoController.cs `
    /namespace:FusionDev.Samples.TodoApi.Controllers `
    /classname:Todo
```
## 
```csharp

```
