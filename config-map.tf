resource "kubernetes_config_map" "tech-challenge-config-map" {
  metadata {
    name = "postgres-config-map"
    namespace = kubernetes_namespace.tech-challenge.metadata.0.name
  }

  data = {
    postgres-server        = "tech-challenge-app-postgres"
    postgres-database-name = "tech-challenge-app-database"
    postgres-user-username = "tech-challenge-user"
    postgres-user-password = "tech-challenge-password"
  }


}