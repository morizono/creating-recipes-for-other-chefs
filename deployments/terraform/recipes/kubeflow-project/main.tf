provider "google" {}

data "google_client_config" "current" {}

module "project" {
  source          = "../../modules/project"
  project_name    = "${var.project_name}"
  org_id          = "${var.org_id}"
  billing_account = "${var.billing_account}"
}

module "project_services" {
  source     = "../../modules/project/modules/services"
  project_id = "${module.project.project_id}"
  services   = "iam.googleapis.com,cloudresourcemanager.googleapis.com,compute.googleapis.com,cloudbilling.googleapis.com,container.googleapis.com,deploymentmanager.googleapis.com,servicemanagement.googleapis.com,storage-component.googleapis.com,storagetransfer.googleapis.com"
}

module "storage_bucket" {
  source        = "../../modules/storage_bucket"
  name          = "${format("%s-%s-%s", module.project.project_name, "pachyderm", module.project.guid)}"
  project       = "${module.project_services.project_id}"
  location      = "${var.location}"
  storage_class = "REGIONAL"
}
