resource "aws_ssm_parameter" "region_parameter" {
  name  = "/terraform/aws_region"
  type  = "String"
  value = var.region
}

resource "aws_ssm_parameter" "state_bucket_name_parameter" {
  name  = "/terraform/state_bucket_name"
  type  = "String"
  value = aws_s3_bucket.terraform_state_bucket.id
}

resource "aws_ssm_parameter" "state_lock_table_name_parameter" {
  name  = "/terraform/state_lock_table_name"
  type  = "String"
  value = aws_dynamodb_table.terraform_state_lock.id
}

resource "aws_ssm_parameter" "state_key_parameter" {
  name  = "/terraform/state_key"
  type  = "String"
  value = "${var.project_name}/terraform.tfstate"
}