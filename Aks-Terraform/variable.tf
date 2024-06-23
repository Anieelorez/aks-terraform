variable "resource_group_name" {}
variable "location" {}

variable "cluster_name" {}

variable "kubernetes_version" {}

variable "system_node_count" {}

variable "node_resource_group" {}

variable "acr_name" {}

variable "azurerm_log_analytics_workspace" {
  type = string
  description = "monitoring aks "
}

variable "azurerm_monitor_metric_alert" {
  type =  string
  description = "alerting system for aks" 
}