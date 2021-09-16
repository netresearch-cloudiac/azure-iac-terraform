# Azure Infrastructure as Code using Terraform
This repository coonsists for the Azure Terrafrom template for standard infrastructure patterns

## Repository branch structure
- main    --> production branch (protected)
- develop --> development branch where developer branches are merged for staging and testing
- [user branch] --> developers will create their own branch to develop/patch and raise a pull request to merge to develop branch

## Development Environment setup
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started)
- [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Install Git](https://git-scm.com/downloads)
- [Install VScode](https://code.visualstudio.com/download) (and below extenstions)
    - Bracket pair colorizer 2
    - Azure terraform
    - Hashicorp terraform
    - git extension pack
    - Terraform azure autocomplete
    - Azure cli tools

## Templates

| Name | Description | Components | Status |
|----|----|----|----|
| common-mgt | common services for management of the Azure cloud | Storage - Terraform remote state, KeyVault | Inprogress|
| vnet-structre | vnet for the azure environment | VNETs, peerings | Not started|
|[Tier4app](/04-slb2srv1reg) | One Loadbalancer with two web servers | one azure standard load balancer with two windows servers | In Progress|

## Terraform Setup

### Service Principal
- Create a service pricipal for automating the Azure Infra setup

### Enviroment Variable setup
- Setup below enviroment variables to connecting to Azure using service principal
```shell
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID
ARM_TENANT_ID
```

# References
## Github actions
- Terraform Github actions offical repo - https://github.com/hashicorp/setup-terraform
- Terraform GitHub Actions Examples - https://github.com/xsalazar/terraform-github-actions-example
- How to use enviroment secrets in action - [Popular GitHub Repos by Language](https://github.com/pied-piper-inc/build-2021)
- Deploying to Azure using Terraform and Github Actions - https://www.blendmastersoftware.com/blog/deploying-to-azure-using-terraform-and-github-actions
- sharing variable between jobs - https://github.community/t/sharing-a-variable-between-jobs/16967/9
- Github Actions | Terraform | Github CI CD 
    - https://www.youtube.com/watch?v=JpnEjwTcczc
    - https://www.youtube.com/watch?v=36hY0-O4STg&t=1s
- Environment Scoped Secrets for GitHub Action Workflows 
    - https://dev.to/github/environment-scoped-secrets-for-github-action-workflows-337a
    - https://www.youtube.com/watch?v=tkKpGWMCG4Q
        - Github code for above video - https://github.com/pied-piper-inc/build-2021

## Azure piplines
- Terraform Extension for Azure DevOps - https://github.com/microsoft/azure-pipelines-extensions/tree/master/Extensions/Terraform/Src
## Enterprise CI/CD
- Enterprise CI/CD Best Practices (3part series) - https://dev.to/kostiscodefresh/series/13231
- Terraform workflow - https://www.terraform.io/guides/core-workflow.html

## Cloud Operating Model
- How can organizations adopt the cloud operating model? - https://www.hashicorp.com/resources/what-is-cloud-operating-model-adoption
- Unlocking the Cloud Operating Model: People, Process, Tools - https://www.hashicorp.com/resources/unlocking-cloud-operating-model-people-process-tools
- AWS Events - Cloud Operating Models for Accelerated Transformation - Level 200 - https://www.youtube.com/watch?v=ksJ5_UdYIag
- AWS re:Invent 2020: Transform your organization’s culture with a Cloud Center of Excellence - https://www.youtube.com/watch?v=VN1vj0d3Z1Y
- What is DevOps - https://www.netapp.com/devops-solutions/what-is-devops/


## Terraform template links
- Terraform on Azure documentation - https://docs.microsoft.com/en-us/azure/developer/terraform/
- Azure Terrafrom configuration templates - https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples
- Create an Azure VM cluster with loadbalancer with Terraform and HCL - https://docs.microsoft.com/en-us/azure/developer/terraform/create-vm-cluster-with-infrastructure
- example terraform outputs - https://github.com/Azure/terraform-azurerm-compute/blob/master/outputs.tf
- Deploying to multiple Azure subscriptions using Terraform - https://medium.com/codex/deploying-to-multiple-azure-subscriptions-using-terraform-81249a58a600

### Terrafrom special cases
- Multi-Cloud Open DC/OS on AWS with Terraform AWS and Azure (with Cisco csr 1000v) - https://github.com/bernadinm/hybrid-cloud

## Azure Networking VNET links
- How network security groups filter network traffic - https://docs.microsoft.com/en-us/azure/virtual-network/network-security-group-how-it-works
### Public IP address
- Public IP addresses Basic vs Standard - https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-addresses
- IP Addresses pricing - https://azure.microsoft.com/en-au/pricing/details/ip-addresses/

## Load Balancer
- Loadbalancer-2VM - https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/virtual-machines/virtual_machine/2-vms-loadbalancer-lbrules
