variable "region" {
    description = "AWS region"
    type        = string
    default     = "ap-southeast-2"
}

variable "project_name" {
    description = "High level description of project"
    type        = string
    default     = "ml-pipeline"
}

variable "repository_name" {
    description = "Name for CodeCommit repository"
    type        = string
    default     = "ml-pipeline-repo"
}