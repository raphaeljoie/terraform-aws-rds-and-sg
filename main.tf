module "rds" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git"

  identifier = var.name
  allocated_storage = var.allocated_storage
  storage_type = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id = var.kms_key_id
  replicate_source_db = var.replicate_source_db
  cross_region_replica = var.cross_region_replica
  license_model = var.license_model
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  domain = var.domain
  domain_iam_role_name = var.domain_iam_role_name
  engine = var.enabled_cloudwatch_logs_exports
  engine_version = var.engine_version
  skip_final_snapshot = var.skip_final_snapshot
  snapshot_identifier = var.snapshot_identifier
  copy_tags_to_snapshot = var.copy_tags_to_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix
  instance_class = var.instance_class
  name = var.db_name
  username = var.username
  password = var.password
  port = var.port
  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone = var.availability_zone
  multi_az = var.multi_az
  iops = var.iops
  publicly_accessible =  var.publicly_accessible
  monitoring_interval =  var.monitoring_interval
  monitoring_role_arn =  var.monitoring_role_arn
  monitoring_role_name =  var.monitoring_role_name
  create_monitoring_role =  var.create_monitoring_role
  allow_major_version_upgrade =  var.allow_major_version_upgrade
  auto_minor_version_upgrade =  var.auto_minor_version_upgrade
  apply_immediately =  var.apply_immediately
  maintenance_window =  var.maintenance_window
  backup_retention_period =  var.backup_retention_period
  backup_window =  var.backup_window
  restore_to_point_in_time =  var.restore_to_point_in_time
  s3_import =  var.s3_import
  tags =  var.tags
  db_instance_tags =  var.db_instance_tags
  db_option_group_tags =  var.db_option_group_tags
  db_parameter_group_tags =  var.db_parameter_group_tags
  db_subnet_group_tags =  var.db_subnet_group_tags
  # DB subnet group
  create_db_subnet_group =  var.create_db_subnet_group
  db_subnet_group_name =  var.db_subnet_group_name
  db_subnet_group_use_name_prefix =  var.db_subnet_group_use_name_prefix
  db_subnet_group_description =  var.db_subnet_group_description
  subnet_ids = var.subnet_ids
  # DB parameter group
  create_db_parameter_group =  var.create_db_parameter_group
  parameter_group_name =  var.parameter_group_name
  parameter_group_use_name_prefix =  var.parameter_group_use_name_prefix
  parameter_group_description =  var.parameter_group_description
  family =  var.family
  parameters =  var.parameters
  # DB option group
  create_db_option_group =  var.create_db_option_group
  option_group_name =  var.option_group_name
  option_group_use_name_prefix =  var.option_group_use_name_prefix
  option_group_description =  var.option_group_description
  major_engine_version =  var.major_engine_version
  options =  var.options
  create_db_instance =  var.create_db_instance
  timezone =  var.timezone
  character_set_name =  var.character_set_name
  enabled_cloudwatch_logs_exports =  var.enabled_cloudwatch_logs_exports
  timeouts = var.timeouts
  option_group_timeouts = var.option_group_timeouts
  deletion_protection =  var.deletion_protection
  performance_insights_enabled =  var.performance_insights_enabled
  performance_insights_retention_period =  var.performance_insights_retention_period
  performance_insights_kms_key_id =  var.performance_insights_kms_key_id
  max_allocated_storage =  var.max_allocated_storage
  ca_cert_identifier = var.ca_cert_identifier
  delete_automated_backups = var.delete_automated_backups
  create_random_password = var.create_random_password
  random_password_length = var.random_password_length
}

module "security_group" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git"

  name        = "sg-rds-${var.name}"
  description = "security group for lambdas"
  vpc_id      = var.vpc_id
}

module "client_security_group" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git"

  name        = "sg-rds-${var.name}-client"
  description = "security group for lambdas"
  vpc_id      = var.vpc_id

  egress_with_source_security_group_id = [
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      source_security_group_id = module.security_group.security_group_id
    },
  ]

  tags = merge(
    var.tags,
    {
      Client = "True"
    }
  )
}

module "security_group_populate" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git"

  create_sg   = false
  name        = module.security_group.security_group_name
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "PostgreSQL access from within client security group"
      source_security_group_id = module.client_security_group.security_group_id
    },
  ]
}
