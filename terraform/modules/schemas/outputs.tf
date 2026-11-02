output "schema_names" {
  description = "Names of the created schemas."
  value       = sort([for schema in databricks_schema.this : schema.name])
}
