resource "google_sql_database_instance" "database" {
  name                = var.dbinstance_name
  database_version    = var.data_base_version
  region              = var.region
  root_password       = var.db_password
  deletion_protection = "false"
  project             = var.project_name



  settings {
    tier = "db-f1-micro"

ip_configuration {
      ipv4_enabled = "true"

      authorized_networks {
        value           = var.authorized_networks
        name            = var.db_username
        
      }
    
    # location_preference {
    #   zone = var.zone
    # }
    }
}
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.database.name
}

resource "google_sql_user" "users" {
  name     = var.db_username
  instance = google_sql_database_instance.database.name
  host     = var.db_host
  password = var.db_password
}