resource "kubernetes_config_map" "tech-challenge-config-map" {
  metadata {
    name = "postgres-config-map"
    namespace = kubernetes_namespace.tech-challenge-namespace.metadata.0.name

  }

  data = {
    postgres-server        = "tech-challenge.caxagz6v59r4.us-east-1.rds.amazonaws.com"
    postgres-database-name = "techchallengedb"
    postgres-user-username = "techchallengeuser"
    postgres-user-password = "techchallengepassword"
    postgres-port          = "5432"
  }


}