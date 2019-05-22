resource "random_id" "id" {
  byte_length = 5
}

resource "google_project" "my_project" {
  depends_on = ["random_id.id"]
  name = "${var.project_name}"
  project_id = "${format("%s-%s", var.project_name, random_id.id.hex)}"
  org_id = "${var.org_id}"
  billing_account = "${var.billing_account}"
}