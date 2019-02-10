terraform {
  backend "gcs" {
    bucket = "infra-220012-prod-tfstate"
    prefix = "terraform/state"
  }
}
