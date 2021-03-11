provider "google" {
  project = "ianlimle-projects"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

resource "google_compute_network" "vpc_network" {
  name    = "dev-vpc"
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "dev-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = "asia-southeast1"
  network       = google_compute_network.vpc_network.id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_security_policy" "policy" {
  name = "my-policy"

  rule {
    action   = "deny(403)"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["9.9.9.0/24"]
      }
    }
    description = "Deny access to IPs in 9.9.9.0/24"
  }

  rule {
    action   = "allow"
    priority = "1001"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }
}

resource "google_compute_instance" "vm_instance" {
  name         = "dev-instance"
  machine_type = "f1-micro"
  zone         = "asia-southeast1-b"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

output "dev-vpc-id" {
  value = google_compute_network.vpc_network.id
}

output "dev-subnet-id" {
  value = google_compute_subnetwork.network-with-private-secondary-ip-ranges.id
}

