module "{{cookiecutter.service_name}}" {
  source           = "./modules/helm_chart"
  env_name         = var.environment
  layer_name       = "{{cookiecutter.service_name}}"
  module_name      = "{{cookiecutter.service_name}}"
  chart            = "./{{cookiecutter.service_name}}"
  release_name     = "" # Add your release name here
  repository       = "" # Add your repository URL here
  namespace        = "service-{{cookiecutter.service_name}}"
  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  chart_version    = "" # Add your chart version here
  values_files     = [] # Add any values files if needed
  values_file      = "" # Add your values file path here
  values = {
    image = {
      tag = "{{cookiecutter.service_name}}-${var.tag}"
    }
    host = "api.${data.terraform_remote_state.parent.outputs.domain}"
  }
  timeout           = 200
  dependency_update = true
  wait              = true
  wait_for_jobs     = false
  max_history       = 25
}
