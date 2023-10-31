provider "aws" {
  region = var.region
}

resource kubernetes_namespace "tech-challenge-ns" {
  metadata {
    name = "tech-challenge-ns"
  }
}