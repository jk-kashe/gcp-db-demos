# AlloyDB Cluster
resource "google_alloydb_cluster" "alloydb_cluster" {
  cluster_id = var.alloydb_cluster_name
  location   = var.region  
  project    = google_project.alloydb-demo-project.project_id

  network_config {
    network = google_compute_network.alloydb_network.id
  }

  initial_user {
    user     = "postgres"
    password = var.alloydb_password
  }
}