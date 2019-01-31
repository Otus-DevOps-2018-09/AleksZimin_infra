provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source           = "../modules/app"
  zone             = "${var.zone}"
  app_disk_image   = "${var.app_disk_image}"
  reddit_app_count = "${var.reddit_app_count}"
  private_key_path = "${var.private_key_path}"
  mongodb_ip       = "${module.db.db_ip}"
}

module "db" {
  source           = "../modules/db"
  zone             = "${var.zone}"
  db_disk_image    = "${var.db_disk_image}"
  private_key_path = "${var.private_key_path}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["178.66.18.87/32"]
}

# Ресурсы google_compute_project_metadata и google_compute_project_metadata_item перезаписывают указанные метаданные проекта.
/* resource "google_compute_project_metadata_item" "appuser1_ssh_key" {
  key = "ssh-keys"
  value = "${local.username_appuser1}:${file(var.public_key_path_appuser1)}"
} */

resource "google_compute_project_metadata" "ssh_keys_appusers" {
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}${local.ssh_key_appuser1}${local.ssh_key_appuser2}${local.ssh_key_appuser3}"
  }
}

locals {
  # Выражение внутри // определяется terradorm как regexp
  # Во вложенном replace удаляем \n в конце строки. Во внешнем replace удаляем все, кроме имени пользователя
  # Флаг (?-U) отключает нежадный режим (по умолчанию он и так отключен. Добавил для примера)
  username_appuser1 = "${replace("${replace("${file(var.public_key_path_appuser1)}", "/\n/", "")}", "/(?-U)^.* /", "")}"

  username_appuser2 = "${replace("${replace("${file(var.public_key_path_appuser2)}", "/\n/", "")}", "/(?-U)^.* /", "")}"
  username_appuser3 = "${replace("${replace("${file(var.public_key_path_appuser3)}", "/\n/", "")}", "/(?-U)^.* /", "")}"
  ssh_key_appuser1  = "${local.username_appuser1}:${file(var.public_key_path_appuser1)}"
  ssh_key_appuser2  = "${local.username_appuser2}:${file(var.public_key_path_appuser2)}"
  ssh_key_appuser3  = "${local.username_appuser3}:${file(var.public_key_path_appuser3)}"
}
