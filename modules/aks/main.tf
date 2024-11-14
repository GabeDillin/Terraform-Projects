///////////////////////////////////////////////////
//
//  Module to provision Azure Kubernetes Service
//
///////////////////////////////////////////////////


// retrieve the vnet and dns zone refeences
data "azurerm_subnet" "aks" {
  name                 = "aks"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

data "azurerm_subnet" "AppGw" {
  name                 = "AppGw"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

data "azurerm_private_dns_zone" "akszone" {
  provider             = azurerm.hub
  name                 = "privatelink.westus2.azmk8s.io"
  resource_group_name  = var.dns_zone_rg
}

//retrieve diagnostics log workspace info 
data "azurerm_log_analytics_workspace" "infralaw01" {
  name                 = "devinfralaw01"
  resource_group_name  = "${substr(var.aks_cluster_name, 0, 3)}-infra-sysmgmt-rg"
}

//create the user-assigned identity for the AKS private cluster
resource "azurerm_user_assigned_identity" "aks-uaid" {
  name                 = "${var.aks_cluster_name}-uaid"
  resource_group_name  = var.aks_rg 
  location             = var.aks_location
}

// the AKS user-assigned ID must have DNS Zone contributor permission
resource "azurerm_role_assignment" "akszone" {
  scope                = data.azurerm_private_dns_zone.akszone.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks-uaid.principal_id
}

// create the cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                            = var.aks_cluster_name
  resource_group_name             = var.aks_rg
  location                        = var.aks_location
  dns_prefix                      = var.dns_prefix
  automatic_upgrade_channel       = var.upgrade_channel
  private_dns_zone_id             = data.azurerm_private_dns_zone.akszone.id
  // sku_tier                       = "Standard"  # use Standard tier to get access to Kubecost for cost management
  private_cluster_enabled         = true
  oidc_issuer_enabled             = true
  workload_identity_enabled       = true
  local_account_disabled          = true
  azure_policy_enabled            = true

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks-uaid.id]
  }

  // this is to enable and integrate AKS with Azure Keyvault 
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  # oms_agent {
  #   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.infralaw01.id
  #   msi_auth_for_monitoring_enabled = true
  # }

  // this is to enable the Application Gateway and Ingress Controller
  ingress_application_gateway {
    // gateway_id = azurerm_application_gateway.network.id  #use this instead to work with an existing appGW 
    gateway_name = "${var.aks_cluster_name}-agw"
    subnet_id  = data.azurerm_subnet.AppGw.id
  }

  service_mesh_profile {
    external_ingress_gateway_enabled = false 
    internal_ingress_gateway_enabled = true 
    mode                             = "Istio"
    revisions                        = ["asm-1-22"]
  }

  // set maintenance window to 3-7 AM UTC time which is 7-10 PM PST time on Sat and Sunday
  maintenance_window {
    allowed {
      day   = "Saturday"
      hours = [3, 7]
    }
    allowed {
      day   = "Sunday"
      hours = [3, 7]
    }
  }

  lifecycle {
    prevent_destroy = false
  }
  
// create the system pool
  default_node_pool {
    name                         = "system"
    node_count                   = var.system_node_count
    vnet_subnet_id               = data.azurerm_subnet.aks.id
    host_encryption_enabled      = true
    vm_size                      = var.syspool_vm_size
    only_critical_addons_enabled = true # enable this to prevent user pods from running on the system pool
    temporary_name_for_rotation  = "systemtemp"
    os_disk_type                 = "Ephemeral"
    os_disk_size_gb              = 120
    auto_scaling_enabled         = true
    min_count                    = 2
    max_count                    = 4  
    max_pods                     = 60
    node_labels                  = {
      pool_type                  = "system"
    }
  upgrade_settings {
      max_surge            = "10%"
    }
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    admin_group_object_ids = var.aks_admin_group_object_ids
  }

  network_profile {
    network_plugin = "azure"
    outbound_type  = "userDefinedRouting"
  }
  
  tags = {
    environment = substr(var.aks_rg, 0, 3)
    team        = "apps"
    owner       = ""
    projectID   = ""
    opco        = ""
  }
}

// create the user pool
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                    = "user"
  kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id          = data.azurerm_subnet.aks.id
  node_count              = var.user_node_count
  vm_size                 = var.userpool_vm_size
  os_disk_type            = "Ephemeral"
  os_disk_size_gb         = 120  
  auto_scaling_enabled    = true
  min_count               = 2
  max_count               = 8 
  max_pods                = 60
  host_encryption_enabled = true
  node_labels             = {
    pool_type             = "user"
  }
  
  tags = {
    environment = substr(var.aks_rg, 0, 3)
    team        = "apps"
    owner       = ""
    projectID   = ""
    opco        = ""
    }
}

//enable diag logging to log analytics workspace
resource "azurerm_monitor_diagnostic_setting" "diag_aks" {
  name                           = "DiagnosticsSettings"
  target_resource_id             = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.infralaw01.id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "kube-apiserver"
  }
  enabled_log {
    category = "kube-audit-admin"
  }
  # enabled_log {
  #   category = "kube-audit"
  # }
  # enabled_log {
  #   category = "kube-controller-manager"
  # }
  # enabled_log {
  #   category = "kube-scheduler"
  # }
  # enabled_log {
  #   category = "cluster-autoscaler"
  # }
  # enabled_log {
  #   category = "guard"
  # }
  # enabled_log {
  #   category = "cloud-controller-manager"
  # }
  metric {
    category = "AllMetrics"
    enabled  = false
  }
}

output "oidc_issuer_id" {
  value = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "workload_identity" {
  value = azurerm_kubernetes_cluster.aks.workload_identity_enabled
}

output "aks_config" { 
  value = azurerm_kubernetes_cluster.aks.kube_config 
}

#########################################################################################################
# 
#  The section below is a workaround for enabling the AppGw (as an integrated part of the AKS)
#  AppGw creates a self-created managed identity and this identity must be granted Vnet Contributor RBAC on
#  the AKS Vnet and Reader on the resource group, yet without knowing the object ID of the identity, you 
#  can't granted it the permission. Here we captured the identity by reviewing the AppGw errors in the activity log. 
# 
#  https://learn.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-existing
#  
##########################################################################################################

// retrieve the AKS Managed resource group name based on the AKS nodes
data "azurerm_resource_group" "aks_managed_rg" {
  name = azurerm_kubernetes_cluster.aks.node_resource_group
}

// retrieve the AKS resource group
data "azurerm_resource_group" "rg" {
  name = var.aks_rg
}

// retrieve the appgw self-created managed identity 
data "azurerm_user_assigned_identity" "ingress_identity" {
  name                = "ingressapplicationgateway-${var.aks_cluster_name}"
  resource_group_name = data.azurerm_resource_group.aks_managed_rg.name
}

// assign the AppGw self-created managed identity with Vnet Contributor role 
resource "azurerm_role_assignment" "mi_vnet_rbac" {
  principal_id         = data.azurerm_user_assigned_identity.ingress_identity.principal_id
  role_definition_name = "Network Contributor"
  scope                = var.dev_vnet_id
}

// assign the AppGw self-created managed identity the Reader role
resource "azurerm_role_assignment" "mi_reader_rbac" {
  principal_id         = data.azurerm_user_assigned_identity.ingress_identity.principal_id
  role_definition_name = "Reader"
  scope                = data.azurerm_resource_group.rg.id
}
