module "front_end_sg" {
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main" 
  # source = "../../aws_sg_module"
  name = var.frontend_sg
  description = var.frontend_description
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project = var.project
  environment = var.environment
}

# output "sg_id" {
#   value = module.front_end_sg.id
# }

module "bastion_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  # source = "../../aws_sg_module"
  name = var.bastion_sg_name
  description = var.bastion_sg_description
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project = var.project
  environment = var.environment

}

module "backend_alb_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  # source = "../../aws_sg_module"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  name = "alb_sg"
  description = "Security_group_for_ALB"
  project = var.project
  environment = var.environment
}

module "vpn_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  name = "vpn_sg"
  description = "sg for vpn"
  project = "roboshop"
  environment = "dev"
  
}

module "mongodb_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  name = "${var.project}-${var.environment}-mongodb-sg"
  description = "sg_for_mongodb"
  project = "roboshop"
  environment = "dev"
}
module "redis_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  name = "redis_sg"
  description = "security-group_for_rsdis"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project = "roboshop"
  environment = "dev"
}
module "mysql_sg"{
  source=  "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  name = "mysql_sg"
  description = "security group for mysql"
  project = "roboshop"
  environment = "dev"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "rabbitmq_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  name = "rabbitma_sg"
  description = "security group for rabbitmq"
  project = "roboshop"
  environment = "dev"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "catalogue_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  name = "${var.project}-${var.environment}-catalogue"
  description = "sg for catalogue instances"
  project = "roboshop"
  environment = "dev"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}
#Ingress Rules for infra

resource "aws_security_group_rule" "bastion_laptop"{
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = module.bastion_sg.sg_id
}


resource "aws_security_group_rule" "backend_alb_sg" {
  type = "ingress"
  security_group_id = module.backend_alb_sg.sg_id
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  
}

resource "aws_security_group_rule" "alb_allowing_vpn" {
  type = "ingress"
  security_group_id = module.backend_alb_sg.sg_id
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  
}

resource "aws_security_group_rule" "vpn_https"{
  security_group_id = module.vpn_sg.sg_id
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule""vpn_ssh"{
  type = "ingress"
  security_group_id = module.vpn_sg.sg_id
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule""vpn_943"{
  type = "ingress"
  from_port = 943
  to_port = 943
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule""vpn_1194"{
  type = "ingress"
  from_port = 1194
  to_port = 1194
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule""mongodb_ssh"{
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

resource "aws_security_group_rule""mongobb_default"{
  type = "ingress"
  from_port = 27017
  to_port = 27017
  protocol = "tcp"
  security_group_id = module.mongodb_sg.sg_id
  source_security_group_id = module.vpn_sg.sg_id

}

resource "aws_security_group_rule""redis_ssh"{
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id =  module.vpn_sg.sg_id
  security_group_id = module.redis_sg.sg_id

}

resource "aws_security_group_rule" "redis_port"{
   type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  source_security_group_id =  module.vpn_sg.sg_id
  security_group_id = module.redis_sg.sg_id

}


resource "aws_security_group_rule""mysql_rules"{
  count = length(var.mysql_ports)
  type = "ingress"
  from_port = var.mysql_ports[count.index]
  to_port = var.mysql_ports[count.index]
  protocol = "tcp"
  security_group_id = module.mysql_sg.sg_id
  source_security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "rabbitmq_sg" {
  count = length(var.rabbitmq_port)
  type = "ingress"
  from_port = var.rabbitmq_port[count.index]
  protocol = "tcp"
  to_port = var.rabbitmq_port[count.index]
  security_group_id = module.rabbitmq_sg.sg_id
  source_security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule""catalogue_alb"{
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.backend_alb_sg.sg_id
    security_group_id = module.catalogue_sg.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id
}
resource "aws_security_group_rule" "catalogue_vpn_http" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id
}
resource "aws_security_group_rule" "catalogue_bastion" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
    type = "ingress"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    source_security_group_id = module.catalogue_sg.sg_id
    security_group_id = module.mongodb_sg.sg_id
}

