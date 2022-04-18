# S3 bucket for CodePipeline Artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${local.stack_name}-codepipeline-s3"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}