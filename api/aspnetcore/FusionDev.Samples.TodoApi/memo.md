```bash
npm install nswag -g

nswag openapi2cscontroller \
    /input:../../../todo-api-spec.json \
    /classname:Todo \
    /namespace:FusionDev.Samples.TodoApi.Controllers \
    /output:Controllers/TodoController.cs \
    /UseLiquidTemplates:true \
    /AspNetNamespace:"Microsoft.AspNetCore.Mvc" \
    /ControllerBaseClass:"Microsoft.AspNetCore.Mvc.Controller"
```