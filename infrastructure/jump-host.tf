resource "google_compute_address" "jump_host_private_ip" {
  project      = var.project_id
  address_type = "INTERNAL"
  region       = var.region
  subnetwork   = google_compute_subnetwork.subnet.name
  name         = "${terraform.workspace}-jump-host-internal-ip"
  address      = var.jump_internal_ip
  description  = "An internal IP address for ${terraform.workspace} jump host"
}

resource "google_compute_address" "jump_host_public_ip" {
  project = var.project_id
  name    = "${terraform.workspace}-jump-public-ip"
}

resource "google_compute_instance" "jump_host" {
  project      = var.project_id
  zone         = "europe-west3-a"
  name         = "${terraform.workspace}-jump-host"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name
    network_ip = google_compute_address.jump_host_private_ip.address
    access_config {
      nat_ip = google_compute_address.jump_host_public_ip.address
    }
  }

}

# 35.235.240.0/20 is required for access through IAP

resource "google_compute_firewall" "rules" {
  project = var.project_id
  name    = "${terraform.workspace}-allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = [22]
  }
  source_ranges = ["5.28.101.41/32", "35.235.240.0/20"]
}
