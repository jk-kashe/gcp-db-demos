resource "null_resource" "cymbal_air_env_client_id" {
  
  provisioner "local-exec" {
    command = <<-EOT
      gcloud compute ssh ${var.clientvm-name} --zone=${var.region}-a --tunnel-through-iap \
      --project ${google_project.demo-project.project_id} \
      --command='touch ~/.profile
      echo "export CLIENT_ID=${var.cymbail_air_web_app_client_id}" >> ~/.profile'
    EOT
  }
}

resource "local_file" "cymbal_air_start_script" {
  depends_on = [ null_resource.cymbal_air_env_client_id ]

  filename = "../cymbal-air-start.sh"
  content = <<-EOT
#!/bin/bash 
gcloud compute ssh ${var.clientvm-name} --zone=${var.region}-a --tunnel-through-iap \
--project ${google_project.demo-project.project_id} \
--command='
    (                                             # Create subshell
        source ~/.profile                         # Source bash profile as we have settings there!
        source .venv/bin/activate                 # Activate venv
        cd genai-databases-retrieval-app/llm_demo # Change directory
        python run_app.py &                       # Run in background
    ) || true          
    bash -i  
' -- -L 8081:localhost:8081
  EOT
}
  

resource "null_resource" "make_script_executable" {
  depends_on = [local_file.cymbal_air_start_script]

  provisioner "local-exec" {
    command = "chmod +x ../cymbal-air-start.sh"  
  }
}