provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]
  count        = "${var.reddit_app_count}"

  # Использование директивы sshKeys на уровне инстансов deprecated(из презентации), поэтому убрал отсюда
  /* metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  } */

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
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
  ssh_key_appuser1 = "${local.username_appuser1}:${file(var.public_key_path_appuser1)}"
  ssh_key_appuser2 = "${local.username_appuser2}:${file(var.public_key_path_appuser2)}"
  ssh_key_appuser3 = "${local.username_appuser3}:${file(var.public_key_path_appuser3)}"
}
