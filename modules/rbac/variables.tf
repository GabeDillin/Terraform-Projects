variable "role_assignments" {
  description = "A map of role assignments for RBAC."
  type = map(object({
    scope                = string
    role_definition_name = string
    principal_id         = string
    condition            = optional(string)
    condition_version    = optional(string)
  }))
}

variable "custom_role_name" {
  description = "The name of the custom role to be created (if needed)."
  type        = string
  default     = null
}

variable "custom_role_scope" {
  description = "The scope where the custom role will be created."
  type        = string
  default     = null
}

variable "custom_role_description" {
  description = "Description of the custom role."
  type        = string
  default     = null
}

variable "custom_role_permissions" {
  description = "Actions allowed by the custom role."
  type        = list(string)
  default     = []
}

variable "custom_role_not_actions" {
  description = "Actions not allowed by the custom role."
  type        = list(string)
  default     = []
}

variable "custom_role_assignable_scopes" {
  description = "Scopes where the custom role can be assigned."
  type        = list(string)
  default     = []
}
