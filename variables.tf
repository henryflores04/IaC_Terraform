variable "environment" {
  description = "Entorno (dev o qa)"
  type        = string
}

variable "frontend_replicas" {
  description = "Cantidad de contenedores de Frontend"
  type        = number
  default     = 1
}

variable "backend_replicas" {
  description = "Cantidad de contenedores de Backend"
  type        = number
  default     = 1
}

variable "frontend_base_port" {
  description = "Puerto base del host para Frontend"
  type        = number
}

variable "backend_base_port" {
  description = "Puerto base del host para Backend"
  type        = number
}

variable "db_port" {
  description = "Puerto del host para PostgreSQL"
  type        = number
}