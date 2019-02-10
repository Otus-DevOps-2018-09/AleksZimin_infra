variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}

variable disk_image {
  description = "Disk image"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable reddit_app_count {
  description = "Count of reddit-app instances"
  default     = 1
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable public_key_path_appuser1 {
  description = "Path to the public key used for ssh access for appuser1"
}

variable public_key_path_appuser2 {
  description = "Path to the public key used for ssh access for appuser2"
}

variable public_key_path_appuser3 {
  description = "Path to the public key used for ssh access for appuser3"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}
