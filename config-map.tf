resource "kubernetes_config_map" "tech-challenge-config-map" {
  metadata {
    name = "postgres-config-map"
  }

  data = {
    postgres-server        = "tech-challenge-app-postgres"
    postgres-database-name = "techchallengedb"
    postgres-user-username = "techchallengeuser"
    postgres-user-password = "techchallengepassword"
  }


}