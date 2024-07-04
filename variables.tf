variable "region" {
  type        = string
  description = "The region in which the resources will be deployed."
}

variable "project_id" {
  type        = string
  description = "The project in which the resources will be deployed."
}

variable "streamlit_name" {
  type        = string
  description = "The name of the streamlit service."

  validation {
    condition     = length(var.streamlit_name) <= 24
    error_message = "The streamlit name must be 24 characters or less."
  }
}

variable "docker_image" {
  type        = string
  description = "The Docker image to deploy to Cloud Run."
}

variable "docker_digest" {
  type        = string
  description = "The Docker image digest."
}

variable "public" {
  type        = bool
  description = "Whether the service should be public or not."
  default     = false
}