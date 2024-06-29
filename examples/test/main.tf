terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

variable "region" {
  description = "The region in which the resources will be deployed."
}

variable "project_id" {
  description = "The project in which the resources will be deployed."
}

output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}