Original article: [Azure Function Serverless Deployment Dotnet](https://byalexblog.net/article/azure-function-serverless-deployment-dotnet/)

Consumption plan is the cheapest way to run your Azure Function. However, it has some limitations. For example, you can not use Web Deploy, Docker Container, Source Control, FTP, Cloud sync or Local Git. You can use [External package URL](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#external-package-url) or [Zip deploy](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#zip-deploy) instead. In this article I will show you how to deploy Dotnet Isolated Azure Function App to Linux Consumption Azure Function resource using Zip Deployment.

## Create azure function resource

I will use [terraform](https://www.terraform.io) to create the azure function resource. The terraform template is available on [here](https://github.com/lAnubisl/AzureFunctionDotnetIsolatedLinuxConsumptionZipDeployment/blob/main/Infrastructure/main.tf).

## Create azure function dotnet application

You can create azure function in a different ways. Here is the Microsoft documentation about how to do this in [Visual Studio](https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-your-first-function-visual-studio), [Visual Studio Code](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp) or [Command Line](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-csharp?tabs=azure-cli). In this example I will use Azure Function [Isolated worker process](https://learn.microsoft.com/en-us/azure/azure-functions/dotnet-isolated-process-guide). The function itself is not so important. I will use the default function that is created by Visual Studio Code. You can find the source code on my [github](https://github.com/lAnubisl/AzureFunctionDotnetIsolatedLinuxConsumptionZipDeployment/tree/main/Source). Here is the function HTTP trigger code.

```csharp
[Function("Ready")]
public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req)
{
    _logger.LogInformation("C# HTTP trigger function processed a request.");
    var response = req.CreateResponse(HttpStatusCode.OK);
    response.Headers.Add("Content-Type", "text/plain; charset=utf-8");
    response.WriteString("Welcome to Azure Functions!");
    return response;
}
```

## Deployment

There are [many ways](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies) you can use to deploy your azure funtion. However, for Linux Consumption Plan there are only two ways: you can use [External package URL](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#external-package-url) or [Zip deploy](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#zip-deploy).
![](https://byalexblog.net/images/azure-function-serverless-deployment-dotnet/deployment_options.png)
I will use Zip deploy option for this example.

First, you need to build the project.
``` bash
dotnet build project.csproj --configuration Release --output publish
```
  Then you need to create deployment package. You can find more information about deployment package structure [here](https://learn.microsoft.com/en-us/azure/azure-functions/deployment-zip-push#deployment-zip-file-requirements). In short, you need to create a zip file with all the files from the publish folder but not the publish folder itself!
``` bash
cd publish
rm local.settings.json
zip -r ../publish.zip .
cd ..
```
Double check that you generate the zip file correctly. If you don't then you can face an issue when Azure says 'Deployment successful' but the function app is not working.
![](https://byalexblog.net/images/azure-function-serverless-deployment-dotnet/deployment_package_structure.png)

  Then you need to deploy the package to the function app. You can find credentials on Azure Portal or use Terraform Outputs.
``` bash
# deploy the artifact to the function app. You can find credentials on Azure Portal or use Terraform Outputs.
DEPLOYMENT_APP='func-dotnet-deployment-test'
DEPLOYMENT_USER='$func-dotnet-deployment-test'
DEPLOYMENT_PASSWORD='***********************'
CREDENTIALS=$DEPLOYMENT_USER:$DEPLOYMENT_PASSWORD
curl -v -X POST --user $CREDENTIALS --data-binary @"publish.zip" https://$DEPLOYMENT_APP.scm.azurewebsites.net:443/api/zipdeploy
```

After deployment you can check the logs.
``` bash
curl -X GET --user $CREDENTIALS https://$DEPLOYMENT_APP.scm.azurewebsites.net:443/deployments
```

After successful deployment you can check that the archive is locates in the storage account of the function app inside the 'scm-releases' container.
![](https://byalexblog.net/images/azure-function-serverless-deployment-dotnet/deployment_package_in_storage.png)

Another interesting thing is [trigger syncing](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies#trigger-syncing). But eventually the [Zip deploy will perform this synchronization for you](https://github.com/projectkudu/kudu/wiki/Deploying-from-a-zip-file-or-url#comparison-with-zip-api:~:text=Zipdeploy%20will%20perform%20this%20synchronization%20for%20you).

![](https://byalexblog.net/images/azure-function-serverless-deployment-dotnet/functions_list.png)

## Conclusion
Zip Deploy can be used to deploy dotnet isolated azure function to Linux Consumption Plan. It is simple and does not require additional software installed on the CD runner or shared credentials like [Azure Service Principal](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals?tabs=browser). 