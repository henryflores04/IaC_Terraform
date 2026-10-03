# Aprovisionamiento Multi-Entorno con Terraform y Docker

Este proyecto automatiza el despliegue de una arquitectura de 3 capas (Frontend, Backend y Base de Datos) sobre Docker utilizando Terraform Workspaces para los entornos `dev` y `qa`.

## Arquitectura y Redes

- **Imágenes:** Descargadas directamente de Docker Hub (`nginx:alpine`, `node:20-alpine`, `postgres:15-alpine`).
- **Aislamiento de Red:**
  - `net-front-back-<env>`: Comunicación exclusiva entre Frontend y Backend.
  - `net-back-db-<env>`: Comunicación exclusiva entre Backend y PostgreSQL.
  - El Frontend no tiene visibilidad de red hacia la Base de Datos.

## Mapeo de Puertos y Escalabilidad

| Entorno | Frontend (`nginx`) | Backend (`node`) | Base de Datos (`postgres`) |
| :--- | :--- | :--- | :--- |
| **DEV** | `4001:80` (réplica 2 en `4011`) | `4002:3000` (réplica 2 en `4012`) | `4003:5432` |
| **QA** | `5001:80` | `5002:3000` | `5003:5432` |

## Instrucciones de Uso

### 1. Clonar el repositorio
```bash
git clone <URL_REPOSITORIO>
cd docker-terraform-lab
```

### 2. Inicializar Terraform
```bash
terraform init
```

### 3. Despliegue en DEV
```bash
terraform workspace select -or-create dev
terraform apply -var-file="environments/dev.tfvars" -auto-approve
```

### 4. Despliegue en QA
```bash
terraform workspace select -or-create qa
terraform apply -var-file="environments/qa.tfvars" -auto-approve
```

### 5. Destrucción de Entornos
```bash
# Destruir DEV
terraform workspace select dev
terraform destroy -var-file="environments/dev.tfvars" -auto-approve

# Destruir QA
terraform workspace select qa
terraform destroy -var-file="environments/qa.tfvars" -auto-approve
```