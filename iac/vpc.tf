# VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "si-assessment-ie3"
  auto_create_subnetworks = false
}

# Public subnet
resource "google_compute_subnetwork" "public_subnet" {
  name          = "si-assessment-ie3-public"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.1.0/24"
}

# Private subnet
resource "google_compute_subnetwork" "private_subnet" {
  name          = "si-assessment-ie3-private"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.2.0/24"
}

# Firewall rule for allowing SSH access to instances in the public subnet
resource "google_compute_firewall" "public_subnet_firewall" {
  name          = "si-assessment-ie3-public-subnet-firewall"
  network       = google_compute_network.vpc_network.self_link
  source_ranges = ["213.31.7.48/32"] # Replace with your desired IP range
  target_tags   = ["si-assessment-ie3-public-subnet"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
}
