# ALB Frontend Static IP
output "lb_static_ip" {
  value       = "http://${google_compute_global_address.lb.address}"
}

output "zones" {
    value = {
        region_a = join(", ", data.google_compute_zones.region_a.names)
        region_b = join(", ", data.google_compute_zones.region_b.names)
    }
}