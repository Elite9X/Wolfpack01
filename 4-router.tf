# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "region_a" {
  name    = "west-router"
  region  = "us-west1"
  network = google_compute_network.vpc1.id
}
#--------------------------------------------------
resource "google_compute_router" "region_b" {
  name    = "central-router"
  region  = "us-central1"
  network = google_compute_network.vpc1.id
}