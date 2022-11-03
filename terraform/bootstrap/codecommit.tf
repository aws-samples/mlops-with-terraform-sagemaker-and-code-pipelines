resource "aws_codecommit_repository" "pipeline_repo" {
    repository_name = var.repository_name
}