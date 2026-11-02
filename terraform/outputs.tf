output "storage_credential_name" {
  description = "Created Unity Catalog storage credential."
  value       = module.storage_credential.name
}

output "external_location_name" {
  description = "Created Unity Catalog external location."
  value       = module.external_location.name
}

output "external_location_url" {
  description = "ADLS Gen2 URL registered as the external location."
  value       = module.external_location.url
}

output "catalog_name" {
  description = "Created production catalog."
  value       = module.catalog.name
}

output "schema_names" {
  description = "Created medallion schemas."
  value       = module.schemas.schema_names
}
