# Client -> Static IP -> Fwd Rule -> HTTP Proxy -> URL Map (URL Map chooses backend service)


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
# Resource: Reserve Global Static IP Address
resource "google_compute_global_address" "lb" {
  name     = "lb-static-ip"
  # region = "us-south1"
}

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule
# # Resource: Global Forwarding Rule
# # Defines how incoming traffic is forwarded to the load balancer proxy based on port and protocol
resource "google_compute_global_forwarding_rule" "lb" {
  name     = "lb-forwarding-rule"
  # region = "us-south1"
  target   = google_compute_target_http_proxy.lb.self_link

  # Listen for traffic on Port 80 using TCP
  port_range            = "80"
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.lb.address
  load_balancing_scheme = "EXTERNAL_MANAGED" # Current Gen LB (not classic)
  

#   # During the destroy process, we need to ensure LB is deleted first, before proxy-only subnet
#   # This is in file 3-subnets.tf
  # depends_on = [google_compute_subnetwork.regional_proxy_subnet]
}

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_http_proxy
# # Resource: Global HTTP Proxy
# # Acts as the HTTP frontend proxy that uses the URL map to decide where to send traffic.
resource "google_compute_target_http_proxy" "lb" {
  name      = "lb-http-proxy"
  #  region = "us-south1" #(optional if provider default is set)

  # URL Map is declared below
  url_map = google_compute_url_map.lb.self_link
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map
# Resource: Global URL Map
# Maps incoming HTTP request URLs to backend services.
# We only use one backend service here so we simply set a default service and have the URL map route all traffic to it.
resource "google_compute_url_map" "lb" {
  name            = "lb-url-map"
 # region         = "us-south1"
  default_service = google_compute_backend_service.lb.self_link
}
