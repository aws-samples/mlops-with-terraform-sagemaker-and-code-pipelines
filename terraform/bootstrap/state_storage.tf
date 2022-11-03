resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket  = "${local.account_id}-${var.project_name}-${var.region}-state-bucket"   
}

resource "aws_dynamodb_table" "terraform_state_lock" {
    name            = "${local.account_id}-${var.project_name}-${var.region}-state-lock-table"
    hash_key        = "LockID"
    read_capacity   = 2
    write_capacity  = 2

    server_side_encryption {
        enabled = true
    }    

    attribute {
        name    = "LockID"
        type    = "S"
    }
}
