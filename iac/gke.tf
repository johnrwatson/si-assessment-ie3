resource "google_container_cluster" "k8s" {
  provider   = google
  name       = "si-assessment-ie3"
  location   = "us-west1"
  network    = google_compute_network.vpc_network.self_link
  subnetwork = google_compute_subnetwork.public_subnet.self_link

  resource_labels = {
    "product"     = "si-assessment-ie3",
    "environment" = "development",
    "terraform"   = "true",
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Enable Autopilot for this cluster
  enable_autopilot = true

  # Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters.
  release_channel {
    channel = "REGULAR"
  }
  ip_allocation_policy {}
  maintenance_policy {
    recurring_window {
      end_time   = "1970-01-01T20:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SU"
      start_time = "1970-01-01T08:00:00Z"
    }
  }
}
