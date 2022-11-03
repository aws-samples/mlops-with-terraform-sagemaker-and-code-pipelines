resource "aws_iam_role" "codepipeline_role" {
    name    = "${var.project_name}-codepipeline-role"

    assume_role_policy = jsonencode(
        {
            Version     = "2012-10-17"
            Statement   = [
                {
                    Action      = "sts:AssumeRole"
                    Effect      = "Allow"
                    Sid         = ""
                    Principal   = {
                        Service = "codepipeline.amazonaws.com"
                    }
                }
            ]
        }
    )

    inline_policy {
        name = "codepipeline-service-policy"

        policy = jsonencode(
            {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Action": [  
                            "codecommit:GetBranch",
                            "codecommit:GetCommit",
                            "codecommit:UploadArchive",
                            "codecommit:GetUploadArchiveStatus",      
                            "codecommit:CancelUploadArchive"
                        ],
                        "Resource": data.aws_codecommit_repository.pipeline_repo.arn
                    },
                    {
                        "Effect": "Allow",
                        "Action": [
                            "codebuild:BatchGetBuilds",
                            "codebuild:StartBuild",
                            "codebuild:BatchGetBuildBatches",
                            "codebuild:StartBuildBatch",
                        ],
                        "Resource": [
                            module.pipeline_codebuild_project.codebuild_project_arn,
                            module.dev_codebuild_project.codebuild_project_arn,
                            module.prd_codebuild_project.codebuild_project_arn
                        ]
                    },
                    {
                        "Effect": "Allow",
                        "Action": [
                            "s3:*"
                        ],
                        "Resource": [
                            "${aws_s3_bucket.code_pipeline_artifacts_bucket.arn}",
                            "${aws_s3_bucket.code_pipeline_artifacts_bucket.arn}/*"
                        ]
                    }
                ],
            },
        )
    }
}