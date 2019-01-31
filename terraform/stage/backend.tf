terraform {
  backend "gcs" {
    bucket = "infra-220012-stage-tfstate"
    prefix = "terraform/state"
  }
}
