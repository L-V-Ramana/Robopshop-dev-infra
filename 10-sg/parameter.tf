resource "aws_ssm_parameter" "front_end" {
    name = "/${var.project}/${var.environment}/frontend"
    type = "String"
    value = module.front_end_sg.sg_id
}

resource "aws_ssm_parameter""bastion_sg_id"{
    name = "/${var.project}/${var.environment}/bastion_sg_id"
    value = module.bastion_sg.sg_id
    type ="String"
}

resource "aws_ssm_parameter""backend_alb_sg_id"{
    name = "/${var.project}/${var.environment}/backend_alb_sg_id"
    type = "String"
    value = module.backend_alb_sg.sg_id
}

resource "aws_ssm_parameter" "vpn_sg_id"{
    name = "/${var.project}/${var.environment}/vpn_sg_id"
    type = "String"
    value = module.vpn_sg.sg_id
}

resource "aws_ssm_parameter""mongodb_sg_id"{
    name = "/${var.project}/${var.environment}/mongod_sg"
    type = "String"
    value = module.mongodb_sg.sg_id
}

resource "aws_ssm_parameter""reddis_sg_id"{
    name ="/${var.project}/${var.environment}/reddis_sg_id"
    type = "String"
    value = module.redis_sg.sg_id
}

resource "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql_sg_id"
  type = "String"
  value = module.mysql_sg.sg_id
}

resource "aws_ssm_parameter" "rabbitmq_sg_ids"{
    name = "/${var.project}/${var.environment}/rabbitmq_sg_ids"
    type = "String"
    value = module.rabbitmq_sg.sg_id
}

resource "aws_ssm_parameter""catalogue_sg_id"{
    name = "/${var.project}/${var.environment}/catalogue_sg_id"
    type = "String"
    value= module.catalogue_sg.sg_id
}