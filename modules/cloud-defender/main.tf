terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Security contact configuration for Azure Cloud Defender notifications
resource "azurerm_security_center_contact" "security_contact" {
  email               = var.security_contact_email
  phone               = var.security_contact_phone
  alert_notifications = var.alert_notifications
  alerts_to_admins    = var.alerts_to_admins
}

# Enable Azure Cloud Defender (Standard tier) for various resource types
resource "azurerm_security_center_subscription_pricing" "cloud_defender" {
  for_each = toset(var.resource_types)

  tier          = "Standard" # Enables Cloud Defender for each resource type
  resource_type = each.value
}

# Auto-provisioning of monitoring agents (optional)
resource "azurerm_security_center_auto_provisioning" "auto_provisioning" {
  auto_provision = var.auto_provision
}

# Optional: Security Center policy (can apply to subscriptions or management groups)
resource "azurerm_security_center_policy" "security_policy" {
  management_group_id = var.management_group_id
}

# Optional: Policy assignment to specific scopes
resource "azurerm_policy_assignment" "cloud_defender_policy" {
  count                = var.assign_policy ? 1 : 0
  name                 = var.policy_assignment_name
  policy_definition_id = var.policy_definition_id
  scope                = var.policy_scope
  enforcement_mode     = var.enforcement_mode
}
