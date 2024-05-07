resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "vpc-${terraform.workspace}"
  auto_create_subnetworks = false
}

# Create Subnet
resource "google_compute_subnetwork" "subnet" {
  project       = var.project_id
  name          = "${terraform.workspace}-subnet-1"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.ip_cidr_range
}

# create cloud router for nat gateway
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${terraform.workspace}-nat-router"
  network = google_compute_network.vpc.name
  region  = var.region
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  project_id = var.project_id
  version    = "~> 1.2"
  region     = var.region
  router     = google_compute_router.router.name
  name       = "${terraform.workspace}-nat--config"

}
