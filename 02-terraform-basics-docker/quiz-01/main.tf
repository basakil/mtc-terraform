terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}


provider "docker" {}

variable "int_port" {
  default = 3000
}

resource "docker_image" "container_image" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  count = 2
  image = docker_image.container_image.latest
  name = "grafana_container-${count.index}"
}

output "public_ip" {
  value = [for i in docker_container.grafana[*] : join(" - ", [i.name], [i.ip_address])]
  # value = join(" - ", [docker_container.grafana[*].name, docker_container.grafana[*].ip_address)
  description = ".."
}