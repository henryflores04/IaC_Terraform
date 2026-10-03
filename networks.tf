resource "docker_network" "front_back_net" {
  name = "net-front-back-${var.environment}"
}

resource "docker_network" "back_db_net" {
  name = "net-back-db-${var.environment}"
}