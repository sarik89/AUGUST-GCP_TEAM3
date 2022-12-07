resource "google_compute_firewall" "allow-traffic" {
  name    = "test-firewall"
  network = google_compute_network.vpc-network-team3.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22", "3306"]
  }
  source_tags   = ["wordpress-firewall"]
  source_ranges = ["0.0.0.0/0"]
}