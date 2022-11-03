variable "region" {
    description = "AWS region"
    type        = string
    default     = "ap-southeast-2"
}

variable "stage" {
    description = "Prefix for stage"
    type        = string
}

variable "repository_name" {
    description = "Name for CodeCommit repository"
    type        = string
    default     = "ml-pipeline-repo"
}

variable "project_name" {
    description = "High level description of project"
    type        = string
}

variable "buildspec_path" {
    description = "Path to buildspec file to use"
    type        = string
}

variable "codebuild_project_name" {
    description = "Suffix to use for CodeBuild project name"
    type        = string
}

variable "environment_variables" {
    description = "Environment variables to set for CodeBuild project"
    type        = map
    default     = {}
}

variable "terraform_variables" {
    description = "Terraform variables to be set for Terraform build"
    type        = map
    default     = {}
}