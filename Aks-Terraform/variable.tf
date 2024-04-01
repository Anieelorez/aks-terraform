variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}

variable "node_resource_group" {
  type        = string
  description = "RG name for cluster resources in Azure"
}

variable "acr_name" {
  type        = string
  description = "ACR name"
}

variable "azurerm_log_analytics_workspace" {
  type = string
  description = "monitoring aks "
}

variable "azurerm_monitor_metric_alert" {
  type =  string
  description = "alerting system for aks" 
}