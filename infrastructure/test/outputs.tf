output "docdb_password" {
  sensitive = true
  value     = random_password.docdb_password.result
}