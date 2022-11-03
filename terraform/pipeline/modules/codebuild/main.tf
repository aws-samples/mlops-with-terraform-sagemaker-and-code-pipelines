resource "aws_codebuild_project" "codebuild_terraform_codebuild" {
    badge_enabled  = false
    build_timeout  = 60
    name           = "${var.stage}-${var.codebuild_project_name}"
    queued_timeout = 480
    service_role   = aws_iam_role.codebuild_role.arn

    artifacts {
        encryption_disabled    = false
        name                   = "${var.stage}-${var.codebuild_project_name}-artifacts"
        override_artifact_name = false
        packaging              = "NONE"
        type                   = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
        image_pull_credentials_type = "CODEBUILD"
        privileged_mode             = false
        type                        = "LINUX_CONTAINER"

        dynamic "environment_variable" {
            for_each = var.environment_variables
            content {
                name    = environment_variable.key
                value   = environment_variable.value
            }
        }

        # Terraform variables can be set via environment variables if they are prefixed with "TF_VAR_".
        dynamic "environment_variable" {
            for_each = var.terraform_variables
            content {
                name    = "TF_VAR_${environment_variable.key}"
                value   = environment_variable.value
            }
        }

        environment_variable{
            name  = "TF_VAR_terraform_state_key"
            value = "${var.stage}-${var.codebuild_project_name}/terraform.tfstate"
        }

    }

    logs_config {
        cloudwatch_logs {
            status = "ENABLED"
    }

    s3_logs {
            encryption_disabled = false
            status              = "DISABLED"
        }
    }

    source {
        buildspec           = var.buildspec_path
        git_clone_depth     = 0
        type                = "CODEPIPELINE"
    }
}