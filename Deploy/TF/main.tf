terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you are using version 1.x, the "features" block is not allowed.
  # version = "~>2.0"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}
data "azurerm_client_config" "current" {}

######################################################################
##  VARS
######################################################################
variable "app_name" {
  type    = string
  default = "bnkApp"
}

variable "region" {
  type    = string
  default = "centralus"
}

variable "loc" {
  type    = string
  default = "cus"
}

######################################################################
##  RESOURCES
######################################################################

resource "azurerm_resource_group" "rg" {
  name     = "tf-${var.app_name}-${var.loc}"
  location = var.region
}


