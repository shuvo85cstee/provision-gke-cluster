resource "google_compute_address" "nginx_proxy_public_ip" {
  project = var.project_id
  name    = "${terraform.workspace}-nginx-proxy-public-ip"
  region  = var.region
}

resource "google_compute_instance" "nginx_proxy" {
  project      = var.project_id
  zone         = "europe-west3-a"
  name         = "${terraform.workspace}-nginx-proxy"
  machine_type = "e2-medium"
  metadata = {
    ssh-keys = "iftekhar:${file(var.ssh_key_private)}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network            = google_compute_network.vpc.name
    subnetwork         = google_compute_subnetwork.subnet.name
    subnetwork_project = var.project_id
    access_config {
      nat_ip = google_compute_address.nginx_proxy_public_ip.address
    }
  }

}

resource "google_compute_firewall" "nginx-proxy-rules" {
  project = var.project_id
  name    = "${terraform.workspace}-allow-http-https"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = [80, 443]
  }
  source_ranges = ["0.0.0.0/0"]
}


resource "null_resource" "nginx-proxy" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u iftekhar -i ${google_compute_address.nginx_proxy_public_ip.address}, --private-key ${var.ssh_key_private}, ${var.playbook_path}"
  }
}