variable "name" {
  description = "External location name."
  type        = string
}

variable "url" {
  description = "ADLS Gen2 container URL."
  type        = string
}

variable "credential_name" {
  description = "Name of the Unity Catalog storage credential."
  type        = string
}

variable "platform_principal" {
  description = "Databricks principal that deploys platform resources."
  type        = string
}

variable "etl_service_principal" {
  description = "Databricks ETL service principal display name."
  type        = string
}
