resource "aws_cloudwatch_log_group" "client_build" {
  name              = "${local.stack_name}-client-build"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "api_build" {
  name              = "${local.stack_name}-api-build"
  retention_in_days = 90
}