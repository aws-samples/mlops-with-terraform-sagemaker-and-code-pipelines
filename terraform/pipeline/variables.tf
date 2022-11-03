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

variable "terraform_state_bucket_name" {
    description = "Name of S3 bucket to store state"
    type        = string
}

variable "terraform_state_lock_table_name" {
    description = "Name of DynamodDB table to lock state"
    type        = string
}