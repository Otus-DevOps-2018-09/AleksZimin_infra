output "reddit_apps_external_ip" {
  value = "${formatlist("Instance %v has external ip %v",google_compute_instance.app.*.id, google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}

output "reddit_apps_urls" {
  value = "${formatlist("http://%s:9292/",google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}
