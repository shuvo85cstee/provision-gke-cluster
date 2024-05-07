provider "google" {
  project = "gcp_project"
  region  = "gcp_region"
}

resource "google_storage_bucket" "terraform_state_bucket" {
  name          = "gcp_bucket_name"
  force_destroy = true
  location      = "gcp_region"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

