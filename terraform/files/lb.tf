resource "google_compute_instance_group" "reddit-app-ig" {
  name        = "reddit-app-ig"
  description = "Instance group for reddit application"
  zone        = "${var.zone}"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  named_port {
    name = "http-puma"
    port = "9292"
  }
}

resource "google_compute_global_forwarding_rule" "reddit-app" {
  name       = "reddit-app-rule"
  target     = "${google_compute_target_http_proxy.reddit-app.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "reddit-app" {
  name        = "reddit-app-proxy"
  description = "Http proxy for reddit application"
  url_map     = "${google_compute_url_map.reddit-app.self_link}"
}

resource "google_compute_url_map" "reddit-app" {
  name            = "reddit-app-lb"
  description     = "Load balancer for reddit application"
  default_service = "${google_compute_backend_service.reddit-app.self_link}"

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.reddit-app.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.reddit-app.self_link}"
    }
  }
}

resource "google_compute_backend_service" "reddit-app" {
  name        = "reddit-app-backend"
  port_name   = "http-puma"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = "${google_compute_instance_group.reddit-app-ig.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.reddit-app.self_link}"]
}

resource "google_compute_http_health_check" "reddit-app" {
  name               = "test"
  request_path       = "/"
  port               = 9292
  check_interval_sec = 5
  timeout_sec        = 5
}
