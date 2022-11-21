
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

## build for app service

dotnet publish -o ../publish/default 
Compress-Archive -Path ..\publish\default\* ..\publish\default.zip

## build for linux vm
dotnet publish -o ../publish/linux-x64 --self-contained -r linux-x64 /p:PublishSingleFile=true
copy to linux vm

## run on linux

```bash
chmod 744 ./FusionDev.Samples.TodoApi 
sudo setcap CAP_NET_BIND_SERVICE=+eip ./FusionDev.Samples.TodoApi 
export ASPNETCORE_URLS=http://*:80
export ASPNETCORE_ENVIRONMENT=Development

  "ApplicationInsights": {
    "ConnectionString": "Copy connection string from Application Insights Resource Overview"
  }
  
./FusionDev.Samples.TodoApi 
```

https://swimburger.net/blog/dotnet/how-to-run-aspnet-core-as-a-service-on-linux


## Generate Api Controller with nswag command line

```bash
npm install nswag -g

# for linux
nswag openapi2cscontroller \
    /input:../../../todo-api-spec.json \
    /classname:Todo \
    /namespace:FusionDev.Samples.TodoApi.Controllers \
    /output:Controllers/TodoController.cs \
    /UseActionResultType:true \
    /UseLiquidTemplates:true \
    /AspNetNamespace:"Microsoft.AspNetCore.Mvc" \
    /ControllerBaseClass:"Microsoft.AspNetCore.Mvc.ControllerBase" \
    /ControllerStyle:partial \
    /ResponseArrayType:IEnumerable 

dotnet-aspnet-codegenerator controller -name TodoItemsController \
  -async -api -m TodoItem -dc TodoContext -outDir Controllers
```

```powershell
choco install nswagstudio

nswag openapi2cscontroller `
    /input:..\..\..\todo-api-spec.json `
    /classname:Todo `
    /namespace:FusionDev.Samples.TodoApi.Controllers `
    /output:Controllers/TodoController.cs `
    /UseActionResultType:true `
    /UseLiquidTemplates:true `
    /AspNetNamespace:"Microsoft.AspNetCore.Mvc" `
    /ControllerBaseClass:"Microsoft.AspNetCore.Mvc.ControllerBase" `
    /ControllerStyle:partial `
    /ResponseArrayType:IEnumerable 

```
### nswag options

Command: openapi2cscontroller
  Generates CSharp Web API controller code from a Swagger/OpenAPI specification.

Arguments: 
  ControllerBaseClass
    The controller base class (empty for 'ApiController').
  ControllerStyle
    The controller generation style (partial, abstract; default: partial).
  ControllerTarget
    controller target framework (default: AspNetCore).
  UseCancellationToken
    Add a cancellation token parameter (default: false).
  UseActionResultType
    Use ASP.Net Core (2.1) ActionResult type as return type (default: false)
  GenerateModelValidationAttributes
    Add model validation attributes (default: false).
  RouteNamingStrategy
    The strategy for naming controller routes (none, operationid; default: none).
  BasePath
    The Base path on which the API is served, which is relative to the Host
  ClassName
    The class name of the generated client.
  OperationGenerationMode
    The operation generation mode ('SingleClientFromOperationId' or 'MultipleClientsFromPathSegments').
  AdditionalNamespaceUsages
    The additional namespace usages.
  AdditionalContractNamespaceUsages
    The additional contract namespace usages.
  GenerateOptionalParameters
    Specifies whether to reorder parameters (required first, optional at the end) and generate optional parameters (default: false).
  GenerateJsonMethods
    Specifies whether to render ToJson() and FromJson() methods for DTOs (default: true).
  EnforceFlagEnums
    Specifies whether enums should be always generated as bit flags (default: false).
  ParameterArrayType
    The generic array .NET type of operation parameters (default: 'IEnumerable').
  ParameterDictionaryType
    The generic dictionary .NET type of operation parameters (default: 'IDictionary').
  ResponseArrayType
    The generic array .NET type of operation responses (default: 'ICollection').
  ResponseDictionaryType
    The generic dictionary .NET type of operation responses (default: 'IDictionary').
  WrapResponses
    Specifies whether to wrap success responses to allow full response access.
  WrapResponseMethods
    List of methods where responses are wrapped ('ControllerName.MethodName', WrapResponses must be true).
  GenerateResponseClasses
    Specifies whether to generate response classes (default: true).
  ResponseClass
    The response class (default 'SwaggerResponse', may use '{controller}' placeholder).
  Namespace
    The namespace of the generated classes.
  RequiredPropertiesMustBeDefined
    Specifies whether a required property must be defined in JSON (sets Required.Always when the property is required).
  DateType
    The date .NET type (default: 'DateTimeOffset').
  JsonConverters
    Specifies the custom Json.NET converter types (optional, comma separated).
  AnyType
    The any .NET type (default: 'object').
  DateTimeType
    The date time .NET type (default: 'DateTimeOffset').
  TimeType
    The time .NET type (default: 'TimeSpan').
  TimeSpanType
    The time span .NET type (default: 'TimeSpan').
  ArrayType
    The generic array .NET type (default: 'ICollection').
  ArrayInstanceType
    The generic array .NET instance type (default: empty = ArrayType).
  DictionaryType
    The generic dictionary .NET type (default: 'IDictionary').
  DictionaryInstanceType
    The generic dictionary .NET instance type (default: empty = DictionaryType).
  ArrayBaseType
    The generic array .NET type (default: 'Collection').
  DictionaryBaseType
    The generic dictionary .NET type (default: 'Dictionary').
  ClassStyle
    The CSharp class style, 'Poco' or 'Inpc' (default: 'Poco').
  JsonLibrary
    The CSharp JSON library, 'NewtonsoftJson' or 'SystemTextJson' (default: 'NewtonsoftJson', 'SystemTextJson' is experimental).
  GenerateDefaultValues
    Specifies whether to generate default values for properties (may generate CSharp 6 code, default: true).
  GenerateDataAnnotations
    Specifies whether to generate data annotation attributes on DTO classes (default: true).
  ExcludedTypeNames
    The excluded DTO type names (must be defined in an import or other namespace).
  ExcludedParameterNames
    The globally excluded parameter names.
  HandleReferences
    Use preserve references handling (All) in the JSON serializer (default: false).
  GenerateImmutableArrayProperties
    Specifies whether to remove the setter for non-nullable array properties (default: false).
  GenerateImmutableDictionaryProperties
    Specifies whether to remove the setter for non-nullable dictionary properties (default: false).
  JsonSerializerSettingsTransformationMethod
    The name of a static method which is called to transform the JsonSerializerSettings used in the generated ToJson()/FromJson() methods (default: none).
  InlineNamedArrays
    Inline named arrays (default: false).
  InlineNamedDictionaries
    Inline named dictionaries (default: false).
  InlineNamedTuples
    Inline named tuples (default: true).
  InlineNamedAny
    Inline named any types (default: false).
  GenerateDtoTypes
    Specifies whether to generate DTO classes.
  GenerateOptionalPropertiesAsNullable
    Specifies whether optional schema properties (not required) are generated as nullable properties (default: false).
  GenerateNullableReferenceTypes
    Specifies whether whether to generate Nullable Reference Type annotations (default: false).
  TemplateDirectory
    The Liquid template directory (experimental).
  TypeNameGenerator
    The custom ITypeNameGenerator implementation type in the form 'assemblyName:fullTypeName' or 'fullTypeName').
  PropertyNameGeneratorType
    The custom IPropertyNameGenerator implementation type in the form 'assemblyName:fullTypeName' or 'fullTypeName').
  EnumNameGeneratorType
    The custom IEnumNameGenerator implementation type in the form 'assemblyName:fullTypeName' or 'fullTypeName').
  Input
    A file path or URL to the data or the JSON data itself.
  ServiceHost
    Overrides the service host of the web document (optional, use '.' to remove the hostname).
  ServiceSchemes
    Overrides the allowed schemes of the web service (optional, comma separated, 'http', 'https', 'ws', 'wss').
  Output
    The output file path (optional).
  NewLineBehavior
    The new line behavior (Auto (OS default), CRLF, LF).

