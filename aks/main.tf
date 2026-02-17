terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

# -------------------------
# VARIABLES
# -------------------------

variable "cluster_name" {
  type    = string
  default = "practice-aks"
}

variable "location" {
  type    = string
  default = "Central India"
}

variable "kubernetes_version" {
  type    = string
  default = "1.32"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "node_vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

# -------------------------
# PROVIDER
# -------------------------

provider "azurerm" {
  features {}
}

# -------------------------
# RESOURCE GROUP
# -------------------------

resource "azurerm_resource_group" "rg" {
  name     = "${var.cluster_name}-rg"
  location = var.location
}

# -------------------------
# VIRTUAL NETWORK
# -------------------------

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.cluster_name}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.200.0.0/16"]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.200.1.0/24"]
}

# -------------------------
# AKS CLUSTER
# -------------------------

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.cluster_name

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name            = "system"
    node_count      = var.node_count
    vm_size         = var.node_vm_size
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
}

# -------------------------
# OUTPUTS
# -------------------------

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
