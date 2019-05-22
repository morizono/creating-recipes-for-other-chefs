resource "google_storage_bucket" "sto_buc" {
  name = "${var.name}"
  project = "${var.project}"
  location = "${var.location}"
  storage_class = "${var.storage_class}"
}