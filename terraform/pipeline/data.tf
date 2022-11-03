data "aws_dynamodb_table" "terraform_state_lock_table" {
  name = var.terraform_state_lock_table_name
}

data "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.terraform_state_bucket_name
}

data "aws_codecommit_repository" "pipeline_repo" {
  repository_name = var.repository_name
}

# SSM Parameters

data "aws_ssm_parameter" "region_parameter" {
  name = "/terraform/aws_region"
}

data "aws_ssm_parameter" "state_bucket_name_parameter" {
  name = "/terraform/state_bucket_name"
}

data "aws_ssm_parameter" "state_lock_table_name_parameter" {
  name = "/terraform/state_lock_table_name"
}

data "aws_ssm_parameter" "state_key_parameter" {
  name = "/terraform/state_key"
}