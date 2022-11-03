resource "aws_s3_bucket" "code_pipeline_artifacts_bucket" {
    bucket  = "${local.account_id}-${var.project_name}-${var.region}-artifacts-bucket"   
}

module "pipeline_codebuild_project" {
  source = "./modules/codebuild"
  repository_name = var.repository_name
  
  project_name = var.project_name
  codebuild_project_name = "pipeline-deploy"
  stage = "dev"
  buildspec_path = "workflows/buildspec.yml"
  environment_variables = {
    "STACK_DIRECTORY": "terraform/pipeline"
  }
}

module "dev_codebuild_project" {
  source = "./modules/codebuild"
  repository_name = var.repository_name
  
  project_name = var.project_name
  codebuild_project_name = "stack-deploy"
  stage = "dev"
  buildspec_path = "workflows/buildspec.yml"

  terraform_variables = {
    "stage": "dev"
  }
  environment_variables = {
    "STACK_DIRECTORY": "terraform/stack"
    "DEPLOY_SAGEMAKER": "true"
    "STAGE": "dev"
    "PROJECT_NAME": var.project_name
    "PIPELINE_SCRIPT_PATH": "src/mlsolution/sagemaker_pipeline.py"
  }
}

module "prd_codebuild_project" {
  source = "./modules/codebuild"
  repository_name = var.repository_name
  
  project_name = var.project_name
  codebuild_project_name = "stack-deploy"
  stage = "prd"
  buildspec_path = "workflows/buildspec.yml"

  terraform_variables = {
    "stage": "prd"
  }
  environment_variables = {
    "STACK_DIRECTORY": "terraform/stack"
    "DEPLOY_SAGEMAKER": "true"
    "STAGE": "prd"
    "PROJECT_NAME": var.project_name
    "PIPELINE_SCRIPT_PATH": "src/mlsolution/sagemaker_pipeline.py"
  }
}

resource "aws_codepipeline" "solution-deployment-pipeline" {
  name     = "solution-deployment-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.code_pipeline_artifacts_bucket.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
        # https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-CodeCommit.html
        name          = "Source"
        category      = "Source"
        configuration = {
            "BranchName"                = "main"
            "PollForSourceChanges"      = "true"
            "RepositoryName"            = var.repository_name
        }
        input_artifacts = []
        output_artifacts = [
            "SourceArtifact",
        ]
        owner     = "AWS"
        provider  = "CodeCommit"
        run_order = 1
        version   = "1"
    }
  }

  stage {
    name = "pipeline-update"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = module.pipeline_codebuild_project.codebuild_project_name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }

  stage {
    name = "dev-build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = module.dev_codebuild_project.codebuild_project_name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }

  stage {
    name = "prd-deployment-approval"

    action {
      name      = "prd-deployment-approval"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 1
    }
  }

  stage {
    name = "prd-build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = module.prd_codebuild_project.codebuild_project_name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }
}
