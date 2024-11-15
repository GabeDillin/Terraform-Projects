data "azurerm_resource_group" "vmss_rg" {
  name     = var.vmss_rg
}

resource "random_string" "fqdn" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                            = "${var.vmss_prefix}-${random_string.fqdn.result}"
  location                        = var.location
  resource_group_name             = var.vmss_rg
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = "false" 
  sku                             = "Standard_D2_v4"
  instances                       = var.vmss_instance
  
  identity {
    type                          = "SystemAssigned"
  }
  
  os_disk {
    caching                       = "ReadWrite"
    storage_account_type          = "StandardSSD_LRS"
  }
  
  source_image_reference {
    publisher                     = "Canonical"
    offer                         = "0001-com-ubuntu-server-jammy"
    sku                           = "22_04-lts"
    version                       = "latest"
  }

  network_interface {
    name                          = "${var.vmss_prefix}-${random_string.fqdn.result}-nic"
    primary                       = true

    ip_configuration {
      name                        = "${var.vmss_prefix}-${random_string.fqdn.result}-iconfig"
      primary                     = true
      subnet_id                   = var.vmss_subnet_id
    }
  }
}
