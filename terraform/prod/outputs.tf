output "reddit_apps_external_ip" {
  value = "${module.app.reddit_apps_external_ip}"
}

output "mongo_db_external_ip" {
  value = "${module.db.db_ext_ip}"
}

output "mongo_db_iternal_ip" {
  value = "${module.db.db_ip}"
}

output "reddit_apps_urls" {
  value = "${module.app.reddit_apps_urls}"
}
