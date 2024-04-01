variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
}

variable "azurerm_virtual_network_name" {
    type = string
    description = "Network in Azure"
}

variable "address_space" {
   type = string
   description = "VPC address space"
   default = ["10.0.0.0/16"]
}

variable "azurerm_subnet_name"{
    type = string
    description = "subnet name"
}

variable "azurerm_network_interface_name" {
    type = string
    description = "network interface"
  
}

variable "admin_username" {
   type = string
   description = "admin username"
}
variable "admin_password" {
  type = string
  description = "admin password"
}

