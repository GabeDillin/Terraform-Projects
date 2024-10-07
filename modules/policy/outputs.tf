output "policy_definition_id" {
  description = "The ID of the created policy definition."
  value       = azurerm_policy_definition.custom_policy.id
}

output "policy_assignment_id" {
  description = "The ID of the policy assignment."
  value       = azurerm_policy_assignment.policy_assignment.id
}

output "policy_initiative_id" {
  description = "The ID of the policy initiative (if created)."
  value       = azurerm_policy_set_definition.policy_initiative.id
  condition   = var.create_initiative
}
