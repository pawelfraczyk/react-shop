resource "aws_codestarconnections_connection" "github" {
  name          = "github"
  provider_type = "GitHub"
}

# CLIENT PIPELINE
resource "aws_codepipeline" "client_pipeline" {
  name     = "${local.stack_name}-client-pipeline"
  role_arn = aws_iam_role.client_codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      namespace        = "SourceVariables"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "pawelfraczyk/react-shop"
        BranchName           = "devops-project"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      namespace        = "BuildVariables"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_client.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      namespace       = "DeployVariables"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        BucketName = "react-shop-devops-codes"
        Extract    = "true"
      }
    }
  }
}

# API CODEPIPELINE
resource "aws_codepipeline" "api_pipeline" {
  name     = "${local.stack_name}-api-pipeline"
  role_arn = aws_iam_role.api_codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      namespace        = "SourceVariables"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "pawelfraczyk/react-shop"
        BranchName           = "devops-project"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      namespace        = "BuildVariables"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_api.name
      }
    }
  }

  # stage {
  #   name = "Deploy"

  #   action {
  #     name            = "Deploy"
  #     category        = "Deploy"
  #     namespace       = "DeployVariables"
  #     owner           = "AWS"
  #     provider        = "S3"
  #     input_artifacts = ["BuildArtifact"]
  #     version         = "1"

  #     configuration = {
  #       BucketName = "react-shop-devops-codes"
  #       Extract    = "true"
  #     }
  #   }
  # }
}
