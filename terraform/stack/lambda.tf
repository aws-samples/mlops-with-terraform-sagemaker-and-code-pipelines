data "archive_file" "mlsolution_code" {
    type            = "zip"
    excludes        = [
        "**/__pycache__/*",
        "**/*.egg-info/*"
    ]
    source_dir  = "${var.project_root_dir}/src"
    output_path = "${path.module}/build/solution_code.zip"
}

resource "aws_lambda_function" "data_generation_lambda" {
    filename        = "${path.module}/build/solution_code.zip"
    function_name   = "${var.stage}-data-generation-lambda"
    handler         = "mlsolution.get_data_lambda.lambda_handler"
    role            = aws_iam_role.data_generation_lambda_role.arn
    source_code_hash    = "${data.archive_file.mlsolution_code.output_base64sha256}"

    runtime = "python3.9"

    environment {
        variables = {
            BUCKET_NAME     = aws_s3_bucket.model_data_bucket.id
        }
    }
}