# module "rbac" {
#   source = "./modules/rbac"

#   role_assignments = {
#    "example_assignment" = {
#       scope                = "/subscriptions/<subscription_id>/resourceGroups/<rg_name>"
#       role_definition_name = "Contributor"
#       principal_id         = "<user_or_sp_object_id>"
#     }
#   }

#   # Optional: Define a custom role
#   custom_role_name           = "CustomRole"
#   custom_role_scope          = "/subscriptions/<subscription_id>"
#   custom_role_description    = "A custom role for specific actions."
#   custom_role_permissions    = ["Microsoft.Compute/virtualMachines/read"]
#   custom_role_not_actions    = ["Microsoft.Compute/virtualMachines/delete"]
#   custom_role_assignable_scopes = [
#     "/subscriptions/<subscription_id>"
#   ]
# }
