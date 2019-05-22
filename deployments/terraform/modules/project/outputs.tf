output "project_id" {
  value = "${google_project.my_project.project_id}"
}

output "project_name" {
  value = "${google_project.my_project.name}"
}

output "guid" {
  value = "${random_id.id.hex}"
}