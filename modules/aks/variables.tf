provider "azurerm" {
  features {}
  alias           = "hub"
  subscription_id = var.subscription_id_hub
}
variable "subscription_id_hub" {
  type        = string
  default     = "xxx-xxx-xxx" 
}
variable "aks_rg" {}
variable "aks_location" {}
variable "aks_cluster_name" {}
variable "vnet_name" {}
variable "vnet_rg" {}

variable "dns_prefix" {
  default     = "aks"
}
variable "private_aks_dns_zone" {
  default     = "System"
}
variable "system_node_count" {
  type        = number
  default     = 2
}
variable "user_node_count" {
  type        = number
  default     = 3
}

// See article below for VM series selection
// https://techcommunity.microsoft.com/t5/fasttrack-for-azure/everything-you-want-to-know-about-ephemeral-os-disks-and-azure/ba-p/3565605

variable "syspool_vm_size" {
  default     = "Standard_DS3_v2" 
}
variable "userpool_vm_size" {
  default     = "Standard_DS3_v2" 
}
variable "upgrade_channel" {
  default     = "stable"  # or "stable" to upgrade to stable k8s version
} 
variable "aks_admin_group_object_ids" {
  default  = ["xxxxx-xxxxx-xxxxx"]
}
variable "dns_zone_rg" {
  default     = "hub-infra-sysmgmt-rg"
}
variable "aks_zone_name" {
  default     = "akszone"
}
variable "loganalytics_rg" {
  default     = "dev-infra-sysmgmt-rg"
}
variable "dev_vnet_id" {
  default = "xxx-xxxx-xxxx"
}
