# CLIENT CODEBUILD
resource "aws_codebuild_project" "build_client" {
  name          = "${local.stack_name}-client-build"
  description   = "${local.stack_name}-client-build"
  build_timeout = "60"
  service_role  = aws_iam_role.client_codebuild.arn

  artifacts {
    packaging = "NONE"
    type      = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    privileged_mode             = true
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ECR_CLIENT_URL"
      value = aws_ecr_repository.client.repository_url
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.client_build.name
    }

  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "codebuild/build-client.yml"
    git_clone_depth = 0
  }

}

# API CODEBUILD
resource "aws_codebuild_project" "build_api" {
  name          = "${local.stack_name}-api-build"
  description   = "${local.stack_name}-api-build"
  build_timeout = "60"
  service_role  = aws_iam_role.api_codebuild.arn

  artifacts {
    packaging = "NONE"
    type      = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    privileged_mode             = true
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ECR_API_URL"
      value = aws_ecr_repository.api.repository_url
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.api_build.name
    }

  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "codebuild/build-api.yml"
    git_clone_depth = 0
  }

}