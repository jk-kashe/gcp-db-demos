#Provision Client VM
resource "google_compute_instance" "database-clientvm" {
  name         = var.clientvm-name
  machine_type = "e2-medium"
  zone         = "${var.region}-a" 
  project      = google_project.demo-project.project_id
 

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240617"
    }
  }

  network_interface {
    network = google_compute_network.demo_network.id
  }

  service_account {
    email  = "${google_project.demo-project.number}-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }

}

resource "time_sleep" "wait_for_database_clientvm_boot" {
  create_duration = "120s"  # Adjust the wait time based on your VM boot time

  depends_on = [google_compute_instance.database-clientvm]
}