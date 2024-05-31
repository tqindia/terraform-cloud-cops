resource "null_resource" "local-base" {

  provisioner "local-exec" {
    working_dir = path.module
    command     = "bash ./install_software.sh"
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
        echo "Uninstalling kind"
        rm -rf $HOME/.cops/local/kind
        echo "Stopping and removing local docker registry"
        docker stop cops-local-registry
        docker rm cops-local-registry
        echo "Removing ./cops/local directory"
        rm -rf $HOME/.cops/local
    EOT

    working_dir = path.module
  }
}

resource "null_resource" "k8s-installer" {
  depends_on = [
    null_resource.local-base
  ]
  provisioner "local-exec" {
    working_dir = path.module
    command     = "bash -c ./install-cluster.sh"
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
        echo "Removing kind cluster"
        $HOME/.cops/local/kind  delete cluster --name cops-local-cluster
    EOT

    working_dir = path.module
  }
}


resource "null_resource" "kind-installer" {
  depends_on = [
    null_resource.k8s-installer
  ]
  provisioner "local-exec" {
    working_dir = path.module
    command     = <<EOT
      kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
      kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
    EOT
  }
}
