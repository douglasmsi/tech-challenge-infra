resource "kubernetes_config_map" "tech-challenge-config-map" {
  metadata {
    name = "postgres-config-map"
    namespace = kubernetes_namespace.tech-challenge-namespace.metadata.0.name

  }

  data = {
    postgres-server        = "tech-challenge-app-postgres"
    postgres-database-name = "techchallengedb"
    postgres-user-username = "techchallengeuser"
    postgres-user-password = "techchallengepassword"
  }


}