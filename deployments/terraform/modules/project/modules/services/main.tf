
resource "google_project_services" "services" {
  project = "${var.project_id}"
  services   = "${split(",", var.services)}"
}