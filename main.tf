terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "k8s-lab" {
  name     = "k8s-lab"
  location = var.location
}

module "nodes" {
  source    = "./nodes"
  subnet_id = azurerm_subnet.subnet.id
  rgname    = azurerm_resource_group.k8s-lab.name
  location  = var.location
  for_each  = toset(["master", "node01", "node02", "node03"])
  prefix    = each.key

}
