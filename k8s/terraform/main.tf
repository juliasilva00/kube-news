terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}



provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins"
  region   = var.region
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key
}


resource "digitalocean_kubernetes_cluster" "k8sjornada" {
  name    = "fk8sjornada"
  region  = var.region
  version = "1.25.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.k8sjornada.kube_config.0.raw_config
  filename = "kube_config.yaml"
}

variable "region" {
  default = ""
}

variable "do_token" {
  default = ""
}

variable "ssh_key" {
  default = ""
}

output "jenkins_ip" {
  value = digitalocean_droplet.jenkins.ipv4_address
}

