output "name" {
  description = "Storage credential name."
  value       = databricks_storage_credential.this.name
}

output "id" {
  description = "Storage credential ID."
  value       = databricks_storage_credential.this.id
}
