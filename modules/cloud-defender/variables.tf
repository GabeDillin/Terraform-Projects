variable "security_contact_email" {
  description = "Email address for security notifications"
  type        = string
}

variable "security_contact_phone" {
  description = "Phone number for security notifications"
  type        = string
  default     = null
}

variable "alert_notifications" {
  description = "Enable/disable security alert notifications"
  type        = bool
  default     = true
}

variable "alerts_to_admins" {
  description = "Send alerts to subscription administrators"
  type        = bool
  default     = true
}

variable "resource_types" {
  description = "Resource types to enable Cloud Defender (e.g., 'VirtualMachines', 'StorageAccounts')"
  type        = list(string)
  default     = ["VirtualMachines", "StorageAccounts", "SqlServers"]
}

variable "auto_provision" {
  description = "Enable/disable auto-provisioning of monitoring agents"
  type        = string
  default     = "On"
}

variable "management_group_id" {
  description = "Management group ID for security center policies"
  type        = string
  default     = null
}

variable "assign_policy" {
  description = "Flag to assign a custom policy"
  type        = bool
  default     = false
}

variable "policy_assignment_name" {
  description = "The name of the policy assignment"
  type        = string
  default     = "cloud-defender-policy"
}

variable "policy_definition_id" {
  description = "The ID of the policy definition to assign"
  type        = string
  default     = null
}

variable "policy_scope" {
  description = "The scope where the policy should be assigned (subscription or resource group)"
  type        = string
  default     = null
}

variable "enforcement_mode" {
  description = "Enforcement mode of the policy assignment (e.g., 'Default', 'DoNotEnforce')"
  type        = string
  default     = "Default"
}
