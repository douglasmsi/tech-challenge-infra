
resource "kubernetes_namespace" "tech-challenge-namespace" {
  metadata {
    name = "tech-challenge-namespace"
  }

}

resource "kubernetes_secret" "tech-challenge-secret" {
  metadata {
    name = "ecr-registry"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (var.registry_server) = {
          "username" = var.registry_username
          "password" = var.registry_password
          "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }

}