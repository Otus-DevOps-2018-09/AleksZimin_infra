variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}
