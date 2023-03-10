output "project_dir" {
  value = var.project_dir
}

output "project_name" {
  value = var.project_name
}

output "aws_region" {
  value = var.aws_region
}

output "kind_listen_address" {
  value = local.kind_listen_address
}

output "kind_localhost_port" {
  value = local.kind_localhost_port
}

output "github_repo_url_infra" {
  value = var.github_repo_url_infra
}

output "github_repo_url_vote" {
  value = var.github_repo_url_vote
}
