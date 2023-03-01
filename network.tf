# Url map
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
      paths   = ["/students/*"]
      service = google_compute_backend_bucket.students.id
    }

    path_rule {
      paths   = ["/companies/*", "/*"]
      service = google_compute_backend_bucket.companies.id
    }
  }
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = sensitive("${var.project_id}-vpc")
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = sensitive("${var.project_id}-subnet")
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/16"
}

resource "google_compute_firewall" "vpc" {
  name    = "vpc-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["30000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# API Gateway
# api_config {
#     network    = google_compute_network.vpc.self_link
#     subnetwork = google_compute_subnetwork.subnet.self_link

#     backend_config {
#       gke_service {
#         gke_namespace = "my-namespace"
#         gke_service   = "my-service"
#         gke_cluster   = google_container_cluster.primary.name
#         service_path  = "/api"
#       }
#     }
#   }


# resource "google_api_gateway_api" "api_gw" {
#   provider = google-beta
#   api_id   = "internship40"
# }

# resource "google_api_gateway_api_config" "api_gw" {
#   provider      = google-beta
#   api           = google_api_gateway_api.api_gw.api_id
#   api_config_id = "config"

#   openapi_documents {
#     document {
#       path = "https://github.com/Laboratorio-Eng-Soft-II/companies-api/"
#     }
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
#   gateway_config {
#     backend_config {

#     }
#   }

# }

# resource "google_api_gateway_gateway" "api_gw" {
#   provider   = google-beta
#   api_config = google_api_gateway_api_config.api_gw.id
#   gateway_id = "api-gw"
# }
