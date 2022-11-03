output "codebuild_project_name" {
    value = aws_codebuild_project.codebuild_terraform_codebuild.name
}

output "codebuild_project_arn" {
    value = aws_codebuild_project.codebuild_terraform_codebuild.arn
}