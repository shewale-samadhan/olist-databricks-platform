terraform {
  required_version = ">= 1.6.0"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.114.1"
    }
  }
}

provider "databricks" {
  host            = var.databricks_host
  azure_client_id = var.databricks_client_id
  azure_tenant_id = var.azure_tenant_id
  auth_type       = "azure-cli"
}
