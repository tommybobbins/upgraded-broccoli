resource "google_dns_managed_zone" "private_dns" {
  name        = var.project
  dns_name    = "${var.project}.private."
  description = "Internal DNSi ${var.project}.private."

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc.id
    }
  }
}

resource "google_dns_record_set" "es_test_internal_dns" {
  name         = "es-test.${var.project}.private."
  type         = "A"
  ttl          = 60
  managed_zone = google_dns_managed_zone.private_dns.name
  #  rrdatas      = [google_compute_address.kong_internal_ip.address]
  rrdatas = ["10.1.2.3"]
}
