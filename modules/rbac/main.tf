provider "azurerm" {
  features {}
}

# Resource group to apply RBAC
resource "azurerm_role_assignment" "rbac" {
  for_each = var.role_assignments

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id

  condition            = lookup(each.value, "condition", null)
  condition_version    = lookup(each.value, "condition_version", null)

  depends_on = [azurerm_role_definition.custom_role]
}

# Optional: Creating a custom role for specific RBAC permissions
resource "azurerm_role_definition" "custom_role" {
  name        = var.custom_role_name
  scope       = var.custom_role_scope
  description = var.custom_role_description

  permissions {
    actions = var.custom_role_permissions
    not_actions = var.custom_role_not_actions
  }

  assignable_scopes = var.custom_role_assignable_scopes
}
