provider "aws" {
    region = "${var.region}"
}

terraform {
    backend "s3" {}
}

data "aws_caller_identity" "current" {}

locals {
    account_id  = data.aws_caller_identity.current.account_id
}