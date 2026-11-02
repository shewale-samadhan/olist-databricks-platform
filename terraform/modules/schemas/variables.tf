variable "catalog_name" {
  description = "Parent catalog name."
  type        = string
}

variable "schema_names" {
  description = "Set of schema names to create."
  type        = set(string)
}

variable "etl_service_principal" {
  description = "Databricks ETL service principal display name."
  type        = string
}
