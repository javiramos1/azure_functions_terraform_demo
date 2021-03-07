# Azure Functions with Terraform Example

Demo of Azure Funcions + Terraform.

Run `make` to deploy. See `Makefile` for details.

The project is divided in two main folders:

- `infra`: Terraform files that deploy the function app.
- `functions`: Contains the Azure functions. Main application which contains the NodeJS functions that execute the business logic.


**NOTE: NPM and NodeJS must be isntalled**


## Usage

**Create a file** `func.tfvars` with the following variables:

- `SUBSCRIPTION_ID`: The given subscription ID
- `TENANT_ID`: Azure tenant ID

Use the `make` command to deploy and destroy the infrastructure.

### Variables

You can set the following varialbles in the `infra/var.tf` file:

- RESOURCE_GROUP
- LOCATION

### Commands

- **make**: Creates a Linux based Function App using a service plan, it also installs application insights for monitoring. After that, it deploys the functions. There are 2 main goals in total that can be run individually, check the Make file for details. Use `make setup` to create the function app, `make deploy` to deploy the functions.
- **make destroy**: Destroy function app.

## App

The `/functions` folder contains the main functions and the NodeJS environment.

You must intall **npm** to run the functions.

Remember to run `npm install` the first time.

Run `make run` to execute the application locally.

**Application Insights** is enabled for monitoring.

Functions implement a **exponential back-off retry** policy for error handling. Error will be handle by Azure Functions.

### Local Run

To run locally you must create a `local.settings.json` file with all the environment variables, it should look something like this:

```
{
  "IsEncrypted": false,
  "Values": {
    "FUNCTIONS_WORKER_RUNTIME": "node",
    "AzureWebJobsStorage": "DefaultEndpointsProtocol=https;AccountName=...;AccountKey=....,EndpointSuffix=core.windows.net"
  }
}
```

`make init` will set the `AzureWebJobsStorage` for you.


## Infrastructure 

The infrastructure is divided in two Terraform projects. 

### **Main**

This Terrafform project creates the Azure Function App including application insights and the function envrionment properties.

### Modules

- **func**: Creates the function app including application insights and the function envrionment properties. It also creates the storage account to upload the functions code.

**Output**: `temp_infra/func.json`