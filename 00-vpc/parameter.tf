resource "aws_ssm_parameter""vpc_id"{
    name = "/${var.project}/${var.environment}/vpc_id"
    type  = "String"
    value = module.vpc_dev.vpc_id
    overwrite = true

}

resource "aws_ssm_parameter""public-subnet_id"{
    name = "/${var.project}/${var.environment}/public_subnet_id"
    type  = "StringList"
    value = join(",",module.vpc_dev.public_subnet_id)
    overwrite = true
}

resource "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
  type = "StringList"
  value = join(",",module.vpc_dev.private_subnet_id)
}

resource "aws_ssm_parameter" "database_subnet_id" {
  name = "/${var.project}/${var.environment}/database-subnet_ids"
  type = "StringList"
  value = join(",",module.vpc_dev.database_subnet_id)
}