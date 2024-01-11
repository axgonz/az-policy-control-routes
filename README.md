# Azure Policy Control Routes (sample)

An example of how multiple definitions can be used together to implement a desired security control.

## Setup

To create tennant scoped deployments

1. Enable evelated global admin access https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin

2. Assign permissions on the tennant root

``` bash
az role assignment create  --scope '/' --role 'Owner' --assignee-object-id $(az ad signed-in-user show --query id)
```

> **Important!** Make sure to remove access once when no longer required.

## Deploy

``` bash
az deployment tenant create --name policyDefinitions --location australiaeast --template-file .\policy\main.bicep
``