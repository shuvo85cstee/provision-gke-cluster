provider "google" {
  project = "rapid-hall-421622"
  region  = "europe-west3"
}

resource "google_storage_bucket" "terraform_state_bucket" {
  name          = "assesment-tf-remote-state"
  force_destroy = true
  location      = "europe-west3"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

