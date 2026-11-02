variable "name" {
  description = "Storage credential name."
  type        = string
}

variable "access_connector_id" {
  description = "Full Azure resource ID of the existing Databricks Access Connector."
  type        = string
}

variable "platform_principal" {
  description = "Databricks principal that deploys platform resources."
  type        = string
}
