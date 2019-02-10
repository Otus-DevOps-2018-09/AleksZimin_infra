variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable reddit_app_count {
  description = "Count of reddit-app instances"
  default     = 1
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}

variable "mongodb_ip" {
  description = "mongodb internal ip adress"
}
