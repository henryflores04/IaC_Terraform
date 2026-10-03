resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_image" "node" {
  name         = "node:20-alpine"
  keep_locally = true
}

resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = true
}

resource "docker_container" "frontend" {
  count = var.frontend_replicas
  name  = var.frontend_replicas > 1 ? "web-${var.environment}-${count.index + 1}" : "web-${var.environment}"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.front_back_net.name
  }

  ports {
    internal = 80
    external = var.frontend_base_port + (count.index * 10)
  }
}

resource "docker_container" "backend" {
  count = var.backend_replicas
  name  = var.backend_replicas > 1 ? "api-${var.environment}-${count.index + 1}" : "api-${var.environment}"
  image = docker_image.node.image_id

  command = [
    "node", "-e",
    "const http = require('http'); http.createServer((req, res) => res.end('Backend Hello World')).listen(3000);"
  ]

  networks_advanced {
    name = docker_network.front_back_net.name
  }
  networks_advanced {
    name = docker_network.back_db_net.name
  }

  ports {
    internal = 3000
    external = var.backend_base_port + (count.index * 10)
  }
}

resource "docker_container" "database" {
  name  = "bd-${var.environment}"
  image = docker_image.postgres.image_id

  networks_advanced {
    name = docker_network.back_db_net.name
  }

  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=postgrespassword",
    "POSTGRES_DB=app_${var.environment}"
  ]

  ports {
    internal = 5432
    external = var.db_port
  }
}