variable "databricks_host" {
  description = "URL of the existing production Azure Databricks workspace."
  type        = string
}

variable "databricks_client_id" {
  description = "Application/client ID of sp-olist-databricks-platform."
  type        = string
}

variable "azure_tenant_id" {
  description = "Microsoft Entra tenant ID used by the Azure CLI authenticated service connection."
  type        = string
}

variable "storage_account_name" {
  description = "Name of the existing ADLS Gen2 storage account."
  type        = string
}

variable "storage_container_name" {
  description = "Existing ADLS Gen2 container used by production."
  type        = string
  default     = "prod"
}

variable "access_connector_id" {
  description = "Full Azure resource ID of the existing Databricks Access Connector in rg-olist-prod."
  type        = string
}

variable "etl_service_principal_name" {
  description = "Databricks service principal display name used by ETL jobs."
  type        = string
  default     = "sp-olist-databricks-cicd"
}

variable "storage_credential_name" {
  description = "Unity Catalog storage credential name."
  type        = string
  default     = "olist-prod-storage-credential"
}

variable "external_location_name" {
  description = "Unity Catalog external location name."
  type        = string
  default     = "olist-prod-external-location"
}

variable "catalog_name" {
  description = "Production Unity Catalog catalog name."
  type        = string
  default     = "olist_prod"
}

variable "schema_names" {
  description = "Production medallion schemas."
  type        = set(string)
  default     = ["bronze", "silver", "gold"]
}
