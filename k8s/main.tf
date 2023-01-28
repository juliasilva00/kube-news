terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}


# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}


resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins"
  region   = var.region
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key_name.id]

}

##vincular um elemento de infraestrutura que ja esta criado no meu cloud provider e vincular a um resource que ja esta sendo criado, para isso  usamos o block do tipo data source

data "digitalocean_ssh_key" "ssh_key_name" {
  name = var.ssh_key_name
}


resource "digitalocean_kubernetes_cluster" "k8sjornada" {
  name    = "k8sjornada"
  region  = var.region
  version = "1.25.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

variable "do_token" {
  default = ""
}

variable "region" {
  default = ""
}

variable "ssh_key_name" {
  default = ""
}