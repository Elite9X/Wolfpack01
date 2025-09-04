# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "bucketbrain"
    prefix = "terraform/6725"
    credentials = "startup-455518-3e4c150dea4c.json"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}
