# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "region_a" {
  name                     = "left-region"
  ip_cidr_range            = "10.26.45.0/24"
  region                   = "us-west1"
  network                  = google_compute_network.vpc1.id
  private_ip_google_access = true
}
#---------------------------------------------------------------
resource "google_compute_subnetwork" "region_b" {
  name                     = "central-region"
  ip_cidr_range            = "10.26.11.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.vpc1.id
  private_ip_google_access = true
}
# region_a = us-west1
# region_b = us-central1