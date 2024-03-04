terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
}

provider "azurerm" {
subscription_id = "8063ac5c-b4d0-4e88-a7d0-54b34e6a8bd5"
tenant_id = "261f0e27-7129-44c5-b43d-9d6b8f99527a"
client_id = "1b05de14-66f4-4530-8ef5-1373b757311c"
client_secret = "Vfl8Q~2JOqZ7us33EJEFfRtdweulh~ZzO.Xzfc6w"
features {}
}
locals {
    resource_group_name = "avdRG"
    location ="australia east"
    Virtual_network = {
        name = "avd-network"
        address_space ="10.0.0.0/16"
    }
    subnet = {
        name = "subnetA"
        address_prefixes = ["10.0.0.0/24"]
    }
}
resource "azurerm_resource_group" "apprg" {
    name = local.resource_group_name
    location = local.location
  
}
resource "azurerm_virtual_network" "avd-network" {
 name = local.Virtual_network.name
 resource_group_name = local.resource_group_name
 location = local.location
 address_space = [local.Virtual_network.address_space]
 depends_on = [ azurerm_resource_group.apprg ]
}
resource "azurerm_subnet" "subnetA" {
    name = local.subnet.name
    resource_group_name = local.resource_group_name
    virtual_network_name = local.Virtual_network.name
    address_prefixes = local.subnet.address_prefixes
  depends_on = [ azurerm_virtual_network.avd-network ]
}
resource "azurerm_network_interface" "avdinterface" {
    name = "avdinterface"
    resource_group_name = local.resource_group_name
    location = local.location
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    }
    depends_on = [ azurerm_subnet.subnetA ]
  }
  resource "azurerm_windows_virtual_machine" "avdvm1" {
  name                = "avdvm1"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.avdinterface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }
}
