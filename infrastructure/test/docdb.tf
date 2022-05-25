locals {
  aws_region_azs = formatlist("${var.region}%s", ["a", "b", "c"])
}

resource "random_password" "docdb_password" {
  length      = 13
  special     = false
  lower       = true
  upper       = true
  number      = true
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "docdb-cluster-demo-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier              = "${local.stack_name}-docdb"
  availability_zones              = local.aws_region_azs
  master_username                 = "sammy"
  master_password                 = random_password.docdb_password.result
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb_param_group.name
  db_subnet_group_name            = aws_docdb_subnet_group.docdb_subnet_group.name
  vpc_security_group_ids          = [aws_security_group.docdb.id]
  final_snapshot_identifier       = false
}

resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = "${local.stack_name}-docdb-gr"
  subnet_ids = data.terraform_remote_state.shared_remote_state.outputs.aws_vpc_private_subnets
}

resource "aws_docdb_cluster_parameter_group" "docdb_param_group" {
  family      = "docdb4.0"
  name        = "${local.stack_name}-cluster-param"
  description = "docdb cluster parameter group"

  parameter {
    name  = "tls"
    value = "enabled"
  }
}