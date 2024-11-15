# Create a network interface
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = [azurerm_network_interface.vm_nic.id]
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  
  encryption_at_host_enabled      = var.encryption_at_host_enabled

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = var.ignore_changes
  }
}
