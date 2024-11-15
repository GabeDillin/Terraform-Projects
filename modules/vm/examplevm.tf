module "my_vm" {
  source              = "./terraform-modules/vm"
  vm_name             = "my-vm"
  location            = "westus2"
  resource_group_name = "my-resource-group"
  subnet_id           = "subnet-id"
#   admin_username      = data.azurerm_key_vault_secret.jbox01adminuser.value
  admin_password      = "mypassword"
  tags = {
    environment = ""
    owner       = ""
  }
}
