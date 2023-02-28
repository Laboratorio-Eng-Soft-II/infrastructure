# Create url map
resource "google_compute_url_map" "url_map" {
  name            = "http-lb"
  description     = "Path-based route mapper"
  default_service = google_compute_backend_bucket.students.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "main"
  }

  path_matcher {
    name            = "main"
    default_service = google_compute_backend_bucket.companies.id

    path_rule {
      paths   = ["/students"]
      service = google_compute_backend_bucket.students.id
    }

    path_rule {
      paths   = ["/companies"]
      service = google_compute_backend_bucket.companies.id
    }
  }
}
