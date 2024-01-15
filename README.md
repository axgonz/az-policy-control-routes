# Azure Policy Control Routes (sample)

An example of how multiple definitions can be used together to implement a desired security control.

## Setup

To create tenant scoped deployments

1. Enable elevated global admin access https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin

2. Assign permissions on the tenant root

    ``` bash
    az role assignment create  --scope '/' --role 'Owner' --assignee-object-id $(az ad signed-in-user show --query id)
    ```

    > **Important!** Make sure to remove access once when no longer required.

## Build

There are a number of BICEP files that must be built first so that they can be read in as JSON files in policy deployments.

``` bash
az bicep build --file .\policy\templates\udr.bicep
```

## Deploy

Deploy the policy definitions and initiatives.

``` bash
# Deploy everything
az deployment tenant create \
    --name policyDefinitions \
    --location australiaeast \
    --template-file .\policy\main.bicep

# Or deploy just a single definition
 az deployment mg create \
    --name policyDefinitions \
    --location australiaeast \
    --management-group-id policy_definitions \
    --template-file .\policy\definitions\udr_forces_next_hop.bicep
```

## Lock

The policy definitions can be accompanied with a deployment stack (deployed at the management group level) to create an enclave resource group for policy dependencies.

``` bash
# Use deployment stacks to create a space for policy controlled resources
az stack mg create --name 'rg_for_policy_resources' --management-group-id policy_definitions --location 'australiaeast' --template-file '.\stacks\main.bicep' --deny-settings-mode 'DenyDelete' --parameters 'subscriptionId <xxx-xx-xx-x>' --deny-settings-excluded-principals '<object-id> <object-id>'
```

When deploying the enclave resource group be sure to *assign* the desired policy initiatives first. Take note of the objectId of any managed identities used for DeployIfNotExists policies and append them to the above deployment stack command.