output "frontend_urls" {
  value = [for c in docker_container.frontend : "http://localhost:${c.ports[0].external}"]
}

output "backend_urls" {
  value = [for c in docker_container.backend : "http://localhost:${c.ports[0].external}"]
}

output "db_port" {
  value = docker_container.database.ports[0].external
}