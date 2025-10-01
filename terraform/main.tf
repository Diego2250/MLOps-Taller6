terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# ---------------------------
# Imagen para el pipeline ETL
# ---------------------------
resource "docker_image" "etl_image" {
  name = "etl_app:latest"
  build {
    context    = "../docker"
    dockerfile = "Dockerfile.pipeline"
  }
}

resource "docker_container" "etl_container" {
  name  = "etl-pipeline"
  image = docker_image.etl_image.image_id
  must_run = false
}

# ---------------------------
# Imagen para la API ML
# ---------------------------
resource "docker_image" "ml_image" {
  name = "ml_app:latest"
  build {
    context    = "../docker"
    dockerfile = "Dockerfile"
  }
}

 resource "docker_container" "ml_container" {
  name  = "ml-api"
  image = docker_image.ml_image.image_id
  must_run = true

  ports {
    internal = 5000
    external = 8080
  }


  volumes {
    host_path      = "${abspath("${path.module}/../docker/data/model.joblib")}"
    container_path = "/data/model.joblib"
  }
}