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
    "artifactregistry.googleapis.com",
    "firestore.googleapis.com"
  ]
}

resource "google_artifact_registry_repository" "streamlit" {
  project       = var.project_id
  location      = var.region
  format        = "DOCKER"
  repository_id = "streamlit"
}

resource "google_service_account" "cloud_run_streamlit" {
  project      = var.project_id
  account_id   = "run-${var.streamlit_name}"
  display_name = "[Run] Streamlit ${var.streamlit_name}"
}

variable "region" {
  description = "The region in which the resources will be deployed."
}

variable "project_id" {
  description = "The project in which the resources will be deployed."
}

variable "streamlit_name" {
  description = "The name of the streamlit service."

  validation {
    condition     = length(var.streamlit_name) <= 24
    error_message = "The streamlit name must be 24 characters or less."
  }
}

output "docker_repository_uri" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/streamlit"
}

output "service_account_email" {
  value = google_service_account.cloud_run_streamlit.email
}