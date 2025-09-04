# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc1" {
  name                            = "vpc1"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

}

# resource "google_compute_network" "vpc2" {
#   name                            = "vpc2"
#   routing_mode                    = "REGIONAL"
#   auto_create_subnetworks         = false
#   mtu                             = 1460
#   delete_default_routes_on_create = false

# }
# resource "google_compute_network" "vpc3" {
#   name                            = "vpc3"
#   routing_mode                    = "REGIONAL"
#   auto_create_subnetworks         = false
#   mtu                             = 1460
#   delete_default_routes_on_create = false

# }