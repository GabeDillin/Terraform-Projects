variable "policy_name" {
  description = "The name of the custom Azure Policy."
  type        = string
}

variable "policy_display_name" {
  description = "The display name of the custom policy."
  type        = string
}

variable "policy_description" {
  description = "The description of the custom policy."
  type        = string
}

variable "policy_mode" {
  description = "The mode of the Azure Policy (All, Indexed, etc.)."
  type        = string
  default     = "All"
}

variable "policy_type" {
  description = "The type of policy (e.g., Custom or BuiltIn)."
  type        = string
  default     = "Custom"
}

variable "policy_metadata" {
  description = "Metadata for the custom policy."
  type        = map(string)
  default     = {}
}

variable "policy_rule" {
  description = "The JSON rule defining the policy logic."
  type        = string
}

variable "policy_parameters" {
  description = "The parameters for the policy."
  type        = map(any)
  default     = {}
}

# Initiative Variables
variable "create_initiative" {
  description = "Whether to create an initiative (collection of policies)."
  type        = bool
  default     = false
}

variable "initiative_name" {
  description = "The name of the policy initiative."
  type        = string
  default     = ""
}

variable "initiative_display_name" {
  description = "The display name of the policy initiative."
  type        = string
  default     = ""
}

variable "initiative_description" {
  description = "The description of the policy initiative."
  type        = string
  default     = ""
}

variable "initiative_policy_type" {
  description = "The type of policy initiative (Custom or BuiltIn)."
  type        = string
  default     = "Custom"
}

variable "initiative_metadata" {
  description = "Metadata for the policy initiative."
  type        = map(string)
  default     = {}
}

variable "initiative_parameters" {
  description = "The parameters for the policy initiative."
  type        = map(any)
  default     = {}
}

# Policy Assignment Variables
variable "policy_assignment_name" {
  description = "The name of the policy assignment."
  type        = string
}

variable "policy_assignment_display_name" {
  description = "The display name of the policy assignment."
  type        = string
}

variable "policy_scope" {
  description = "The scope at which the policy will be assigned (e.g., subscription, management group, or resource group)."
  type        = string
}

variable "policy_assignment_description" {
  description = "The description of the policy assignment."
  type        = string
  default     = ""
}

variable "policy_assignment_parameters" {
  description = "Parameters to pass when assigning the policy."
  type        = map(any)
  default     = {}
}

variable "enforcement_mode" {
  description = "Whether or not the policy assignment is enforced. Set to true for 'DoNotEnforce'."
  type        = string
  default     = "Default"
}
