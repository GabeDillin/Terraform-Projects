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

# Define a custom Azure Policy
resource "azurerm_policy_definition" "custom_policy" {
  name         = var.policy_name
  policy_type  = var.policy_type
  mode         = var.policy_mode
  display_name = var.policy_display_name
  description  = var.policy_description
  metadata     = var.policy_metadata

  policy_rule  = var.policy_rule
  parameters   = var.policy_parameters
}

# Optional: Define an Azure Policy Initiative (a collection of policies)
resource "azurerm_policy_set_definition" "policy_initiative" {
  count        = var.create_initiative ? 1 : 0
  name         = var.initiative_name
  display_name = var.initiative_display_name
  description  = var.initiative_description
  policy_type  = var.initiative_policy_type
  metadata     = var.initiative_metadata

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.custom_policy.id
    parameters           = var.initiative_parameters
  }

  depends_on = [azurerm_policy_definition.custom_policy]
}

# Assign the policy to a specific scope (management group, subscription, or resource group)
resource "azurerm_policy_assignment" "policy_assignment" {
  name                 = var.policy_assignment_name
  display_name         = var.policy_assignment_display_name
  policy_definition_id = azurerm_policy_definition.custom_policy.id
  scope                = var.policy_scope

  parameters           = var.policy_assignment_parameters
  description          = var.policy_assignment_description
  enforcement_mode     = var.enforcement_mode

  depends_on = [azurerm_policy_definition.custom_policy]
}
