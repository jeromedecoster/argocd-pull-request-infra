# https://github.com/argoproj/argo-helm
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  # 7 minutes
  timeout = 420

  values = [
    yamlencode({ server = {
      # /!\ default server.config.timeout.reconciliation = 180s
      # https://github.com/argoproj/argo-helm/blob/17e601148f0325d196e55a77a1b9577c8bbd926d/charts/argo-cd/values.yaml#L1568-L1570
      config = { "timeout.reconciliation" : "30s" },
      # /!\ default server.service.type = ClusterIP
      # https://github.com/argoproj/argo-helm/blob/17e601148f0325d196e55a77a1b9577c8bbd926d/charts/argo-cd/values.yaml#L1337-L1342
      service = { type = "NodePort" }
    } })
  ]

  depends_on = [
    kind_cluster.cluster
  ]
}
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret
data "kubernetes_secret" "argocd_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = helm_release.argocd.namespace
  }

  depends_on = [helm_release.argocd]
}

resource "argocd_repository" "repo_infra" {
  repo            = var.github_repo_url_infra
  ssh_private_key = data.local_file.key_file_pem.content
  insecure        = true
}

resource "argocd_repository" "repo_vote" {
  repo            = var.github_repo_url_vote
  ssh_private_key = data.local_file.key_file_pem.content
  insecure        = true
}
