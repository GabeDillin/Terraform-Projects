output "role_assignment_ids" {
  description = "The IDs of the role assignments."
  value       = [for assignment in azurerm_role_assignment.rbac : assignment.id]
}

output "custom_role_id" {
  description = "The ID of the custom role (if created)."
  value       = azurerm_role_definition.custom_role.id
}
