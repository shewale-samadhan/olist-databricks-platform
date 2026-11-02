variable "name" {
  description = "Unity Catalog catalog name."
  type        = string
}

variable "storage_root" {
  description = "Managed storage root for the catalog, under the configured external location."
  type        = string
}

variable "etl_service_principal" {
  description = "Databricks ETL service principal display name."
  type        = string
}
