resource "random_id" "id" {
  byte_length = 5
  prefix      = "${var.project_name}-"
}

resource "google_project" "my_project" {
  depends_on = ["random_id.id"]
  name = "${var.project_name}"
  project_id = "${random_id.id.hex}"
  org_id = "${var.org_id}"
  billing_account = "${var.billing_account}"
}