# VPC
#--------------------------------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

resource "google_compute_network" "brian-white" {
  name                    = "brian-white"
  auto_create_subnetworks = false
}
# Subnets
#-----------------------------------------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

# Public Subnet
resource "google_compute_subnetwork" "brian-white" {
  name          = "brian-white"
  ip_cidr_range = "10.130.0.0/24"
  region        = "asia-east1"
  network       = google_compute_network.brian-white.id
}

# Private Subnet
resource "google_compute_subnetwork" "brian-white-private" {
  name                     = "brian-white-private"
  ip_cidr_range            = "10.120.0.0/24"
  region                   = "southamerica-east1"
  network                  = google_compute_network.brian-white.id
  private_ip_google_access = true
}
# Firewall
#--------------------------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall

# Allow RDP
resource "google_compute_firewall" "brian-white-rdp-allow" {
  name    = "brian-white-allow-rdp"
  network = google_compute_network.brian-white.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rdp-public"]
}

# Allow Internal Traffic
resource "google_compute_firewall" "brian-white-internal" {
  name    = "brian-white-internal"
  network = google_compute_network.brian-white.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_tags = ["brian-access"]
  target_tags = ["brian-internal"]
}

# Allow Health Check
resource "google_compute_firewall" "allow_health_check" {
  name    = "allow-health-check"
  network = google_compute_network.brian-white.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["brian-internal"]
}
# VM 
#------------------------------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
# Taiwan RDP VM

resource "google_compute_instance" "brian-windows-vm" {
  name         = "brian-windows-vm"
  machine_type = "n2-standard-4"
  zone         = "asia-east1-a"
  tags         = ["rdp-public"]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2022-dc-v20240612"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.brian-white.name
    access_config {}
  }
}
# Manage Instance Group
#---------------------------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones

data "google_compute_zones" "available" {
  status = "UP"
  /* region = "asia-east1" */
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager
resource "google_compute_region_instance_group_manager" "taiwan" {
  name               = "taiwan-mig"
  region             = "asia-east1"
  base_instance_name = "brian-windows-vm"
  target_size        = 3

  version {
    instance_template = google_compute_instance_template.taiwan.id
  }

  /* distribution_policy_zones = [
    "asia-east1-a",
    "asia-east1-b",
    "asia-east1-c",
  ] */

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.health-hc.id
    initial_delay_sec = 60
  }
}