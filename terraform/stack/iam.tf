resource "aws_iam_role" "data_generation_lambda_role" {
    name = "${var.stage}_data_generation_lambda_role"

    assume_role_policy = jsonencode(
        {
            Version     = "2012-10-17"
            Statement   = [
                {
                    Action      = "sts:AssumeRole"
                    Effect      = "Allow"
                    Sid         = ""
                    Principal   = {
                        Service = [
                            "lambda.amazonaws.com",
                            "sagemaker.amazonaws.com"
                        ]
                    }
                }
            ]
        }
    )

    inline_policy {
        name = "data_generation_lambda_role_policy"
        policy = jsonencode(
            {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Action": [
                            "s3:*"
                        ],
                        "Resource": [
                            "${aws_s3_bucket.model_data_bucket.arn}",
                            "${aws_s3_bucket.model_data_bucket.arn}/*"
                        ]
                    }
                ]
            }
        )
    }
}

resource "aws_iam_role" "sagemaker_execution_role" {
    name = "${var.stage}_sagemaker_execution_role"

    assume_role_policy = jsonencode(
        {
            Version     = "2012-10-17"
            Statement   = [
                {
                    Action      = "sts:AssumeRole"
                    Effect      = "Allow"
                    Sid         = ""
                    Principal   = {
                        Service = [
                            "sagemaker.amazonaws.com"
                        ]
                    }
                }
            ]
        }
    )

    inline_policy {
        name = "lambda_data_gen_access_role_policy"
        policy = jsonencode(
            {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Action": [
                            "s3:*"
                        ],
                        "Resource": [
                            "${aws_s3_bucket.model_data_bucket.arn}",
                            "${aws_s3_bucket.model_data_bucket.arn}/*"
                        ]
                    },
                    {
                        "Effect": "Allow",
                        "Action": [
                            "lambda:InvokeFunction",
                            "lambda:GetFunction"
                        ],
                        "Resource": [
                            "${aws_lambda_function.data_generation_lambda.arn}"
                        ]
                    }
                ]
            }
        )
    }
}

data "aws_iam_policy" "sagemaker_execution_policy" {
    arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"  
}

resource "aws_iam_role_policy_attachment" "sagemaker_execution_policy_attach" {
    role       = "${aws_iam_role.sagemaker_execution_role.name}"
    policy_arn = "${data.aws_iam_policy.sagemaker_execution_policy.arn}"
}
