resource "google_storage_bucket" "companies_web" {
  name          = "companies-static-website-bucket"
  location      = "SOUTHAMERICA-EAST1"
  force_destroy = true

  uniform_bucket_level_access = true

  #   cors {
  #     origin          = ["http://image-store.com"]
  #     method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
  #     response_header = ["*"]
  #     max_age_seconds = 3600
  #   }
}

resource "google_storage_bucket_iam_member" "companies_web" {
  bucket = google_storage_bucket.companies_web.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_compute_backend_bucket" "companies" {
  name        = "companies"
  description = "Companies static website bucket"
  bucket_name = google_storage_bucket.companies_web.name
}
