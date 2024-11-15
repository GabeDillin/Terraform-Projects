# variables.tf

variable "vm_name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "location" {
  description = "The location where the resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to which the VM's NIC will be attached."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_B2ms"
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  type        = string
  sensitive   = true
}

variable "disable_password_authentication" {
  description = "Should password authentication be disabled?"
  type        = bool
  default     = false
}

variable "encryption_at_host_enabled" {
  description = "Is encryption at host enabled?"
  type        = bool
  default     = true
}

variable "os_disk_caching" {
  description = "The caching type of the OS disk."
  type        = stringCPU
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "image_publisher" {
  description = "The publisher of the OS image."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the OS image."
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "The SKU of the OS image."
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "The version of the OS image."
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "A map of tags to assign to the VM."
  type        = map(string)
  default     = {
    environment = "dev"
    owner       = "sysadmin"
  }
}

variable "ignore_changes" {
  description = "A list of resource attributes to ignore changes for."
  type        = list(string)
  default     = ["admin_username", "admin_password"]
}
