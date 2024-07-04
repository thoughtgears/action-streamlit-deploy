terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

locals {
  service_apis = [
    "run.googleapis.com",
  ]
}

resource "google_project_service" "this" {
  for_each = toset(local.service_apis)
  project  = var.project_id
  service  = each.value
}

resource "google_service_account" "cloud_run_streamlit" {
  project      = var.project_id
  account_id   = "run-${var.streamlit_name}"
  display_name = "[Run] Streamlit ${var.streamlit_name}"
}

resource "google_cloud_run_v2_service" "streamlit" {
  project  = var.project_id
  location = var.region
  name     = var.streamlit_name
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    scaling {
      max_instance_count = 1
    }
    service_account = google_service_account.cloud_run_streamlit.email
    containers {
      image = "${var.docker_image}@${var.docker_digest}"
      resources {
        limits = {
          cpu    = "1"
          memory = "256Mi"
        }
        cpu_idle = true
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "allUsers" {
  for_each = var.public ? toset(["allUsers"]) : toset([])
  project  = google_cloud_run_v2_service.streamlit.project
  location = google_cloud_run_v2_service.streamlit.location
  name     = google_cloud_run_v2_service.streamlit.name
  member   = each.value
  role     = "roles/run.invoker"
}
