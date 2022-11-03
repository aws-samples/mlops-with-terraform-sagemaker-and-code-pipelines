resource "aws_iam_role_policy_attachment" "codebuild_deploy" {
    role       = aws_iam_role.codebuild_role.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "codebuild_role" {
    name    = "${var.codebuild_project_name}-${var.stage}-codebuild-role"

    assume_role_policy = jsonencode(
        {
            Version     = "2012-10-17"
            Statement   = [
                {
                    Action      = "sts:AssumeRole"
                    Effect      = "Allow"
                    Sid         = ""
                    Principal   = {
                        Service = "codebuild.amazonaws.com"
                    }
                }
            ]
        }
    )
}