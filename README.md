# devops-test-webapi

\# Install Azure CLI on Windows https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli \
\# Install Packer https://www.packer.io/downloads \ 

```
az login

$location = "eastus" 
$rgname = "rgname"
$galleryname = "galTest"
$imagename = 'WinApiImageTest" 
```
\# Obtain your Azure subscription ID \ 
```
az account show --query "{ subscription_id: id }" \

$sub = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 
```
\# Create a resource group

```
az group create -n $rgname -l $location
``` 

\# Create a service principal
```
az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }" \
```
\# add these details as GitHub secrets

CLIENT_ID
CLIENT_SECRET
SUBSCRIPTION_ID
TENANT_ID

\# create shared image gallery
```
az sig create --subscription $sub --resource-group $rgname --gallery-name $galleryname --location $location
```
\# create image definition
```
az sig image-definition create --resource-group $rgname --gallery-name $galleryname --gallery-image-definition $imagename --publisher MicrosoftWindowsServer --offer WindowsServer --sku 2022-Datacenter-smalldisk --os-type Windows
```

\# Run Build VM Image action

\# Run Terraform Plan/Apply action

# Notes

## What does not work

* I am having trouble with embedding the app in the image. I tried to publish/upload/download the app via workflow and copy it to the new image, but didn't work properly.
* The resources need to be destroyed in order to recreate them. This is not done automatically yet.

## Different outcomes

* I wanted to also create the VM via Terraform instead of Portal or Az shell. It works


