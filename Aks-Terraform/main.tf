resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.cluster_name
  node_resource_group = var.node_resource_group

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    # availability_zones  = [1, 2, 3]
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet" # azure (CNI)
  }
}

resource "kubernetes_storage_class" "example" {
  metadata {
    name =  var.resource_group_name
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  parameters = {
    type = "pd-standard"
  }
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = var.azurerm_log_analytics_workspace
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = var.azurerm_log_analytics_workspace
  target_resource_id = azurerm_kubernetes_cluster.aks.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "kube-apiserver"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}

# Example Terraform configuration for Azure Monitor alerts
resource "azurerm_monitor_metric_alert" "example" {
  name                   = var.azurerm_monitor_metric_alert
  resource_group_name    = azurerm_resource_group.rg.name
  scopes                 = [azurerm_kubernetes_cluster.aks.id]
  description            = "Example Metric Alert"
  severity               = 3
  enabled                = true

  criteria {
    metric_namespace = "Microsoft.ContainerService"
    metric_name      = "CPUUtilization"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

# Example Terraform configuration for RBAC
resource "azurerm_role_definition" "example" {
  name        = "my-custom-role"
  scope       = azurerm_kubernetes_cluster.aks.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = ["*"]
    not_actions = []
  }
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = azurerm_role_definition.example.name
  principal_id         = data.azurerm_client_config.current.object_id
}
