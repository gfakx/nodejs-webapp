# Define variables
variable "location" {
  description = "Azure region for the resources"
  default     = "canadacentral"
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  default     = "Standard"
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS cluster"
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for the AKS nodes"
  default     = "Standard_A2_v2"
}

# Create a resource group
resource "azurerm_resource_group" "gf-rg" {
  name     = "gfakxrg"
  location = var.location
}

# Create ACR
resource "azurerm_container_registry" "example" {
  name                = "gfakxacr"
  resource_group_name = azurerm_resource_group.gf-rg.name
  location            = azurerm_resource_group.gf-rg.location
  sku                 = var.acr_sku
}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "example" {
  name                = "gfakxaks"
  location            = azurerm_resource_group.gf-rg.location
  resource_group_name = azurerm_resource_group.gf-rg.name
  dns_prefix          = "gfakxaks"

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

# Create ACR pull for AKS - Role Assignment
resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.example.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.example.id
  skip_service_principal_aad_check = true
}
