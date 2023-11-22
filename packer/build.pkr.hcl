source "azure-arm" "win_vm" {
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  tenant_id                         = var.tenant_id
  subscription_id                   = var.subscription_id

  location                          = var.location
  managed_image_name                = var.image_name
  managed_image_resource_group_name = var.resource_group_name

  
  communicator                      = "winrm"
  os_type                           = "Windows"
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2022-Datacenter-smalldisk"
  
  vm_size                           = "Standard_B1s"
  winrm_insecure                    = true
  winrm_timeout                     = "15m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"

  shared_image_gallery_destination {
    subscription   = var.subscription_id
    resource_group = var.resource_group_name
    gallery_name   = "galTest"
    image_name     = var.image_name
    image_version  = "1.0.0"
    replication_regions = [
      var.location
    ]
  }
}

build {
  sources = ["source.azure-arm.win_vm"]

  provisioner "powershell" {
    inline = [
        "Add-WindowsFeature Web-Server",
        "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
        "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
        "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
        "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
        ]
  }
}

