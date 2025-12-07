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

module "frontend_alb_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  project = "roboshop"
  environment = "dev"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  name = "${var.project}-${var.environment}-frontend-alb"
  description = "sg for frontend alb"
}

module "user_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project = "roboshop"
  environment = "dev"
  name = "${var.project}-${var.environment}-user"
  description = "sg for user"
}

module "cart_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project = var.project
  environment = var.environment
  name = "${var.project}-${var.environment}-cart_sg"
  description = "sg_for_cart"
}

module "shipping_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  name  = "${var.project}-${var.environment}-shipping"
  description = "sg-for-shipping"
  project = "${var.project}"
  environment = "${var.environment}"
}

module "payment_sg"{
  source = "git::https://github.com/L-V-Ramana/aws_sg_module.git?ref=main"
  name  = "${var.project}-${var.environment}-payment"
  description = "sg-for-payment"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project = "${var.project}"
  environment = "${var.environment}"
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
#catalogue
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


resource "aws_security_group_rule""frontend_alb_443"{
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = module.frontend_alb_sg.sg_id
    cidr_blocks = ["0.0.0.0/0"]
    
}
resource "aws_security_group_rule""frontend_alb_80"{
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.frontend_alb_sg.sg_id
    cidr_blocks = ["0.0.0.0/0"]
    
}
#user
resource "aws_security_group_rule" "user_http"{
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.backend_alb_sg.sg_id
    security_group_id = module.user_sg.sg_id
}

resource "aws_security_group_rule""user_vpn_ssh"{
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.user_sg.sg_id
    source_security_group_id = module.vpn_sg.sg_id
}
resource "aws_security_group_rule""user_vpn_http"{
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_group_id = module.user_sg.sg_id
    source_security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule""user_bastion"{
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.user_sg.sg_id
  source_security_group_id = module.bastion_sg.sg_id
}

resource "aws_security_group_rule""reddis_allowing_user"{
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  security_group_id = module.redis_sg.sg_id
  source_security_group_id = module.user_sg.sg_id
}

resource "aws_security_group_rule""mongodb_allowing_user"{
  type = "ingress"
  from_port = 27017
  to_port = 27017
  protocol = "tcp"
  security_group_id = module.mongodb_sg.sg_id
  source_security_group_id = module.user_sg.sg_id
}
#cart
resource "security_group_rule" "cart_vpn_http" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.vpn_sg.sg_id
    security_group_id = module.cart_sg.sg_id
}

resource "security_group_rule" "cart_bastion_http"{
  type ="ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = module.cart_sg.sg_id
  source_security_group_id = module.bastion_sg.sg_id
}
resource "security_group_rule" "cart_alb"{
  type ="ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = module.cart_sg.sg_id
  source_security_group_id = module.backend_alb_sg.sg_id
}
resource "security_group_rule" "cart_bastion_ssh"{
  type ="ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.cart_sg.sg_id
  source_security_group_id = module.bastion_sg.sg_id
}

resource "security_group_rule""cart_ssh_vpn"{
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.cart_sg.sg_id
  source_security_group_id = module.vpn_sg.sg_id
}

resource "security_group_rule" "reddis-allowing-cart" {
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  security_group_id = module.redis_sg.sg_id
  source_security_group_id = module.cart_sg.sg_id
}

resource "security_group_rule" "catalogue-allowing-cart"{
  type = "ingress"
  from_port = 8080
  to_port =8080
  protocol ="tcp"
  security_group_id = module.catalogue_sg.sg_id
  source_security_group_id = module.cart_sg.sg_id

}
resource "security_group_rule" "catalogue-allowing-cart"{
  type = "ingress"
  from_port = 80
  to_port =80
  protocol ="tcp"
  source_security_group_id = module.cart_sg.sg_id
  security_group_id = module.backend_alb_sg.sg_id

}
#shipping
resource "security_group_rule" "shipping_vpn_http"{
  type = "ingress"
  from_port = 8080
  to_port =8080
  protocol ="tcp"
  security_group_id = module.shippping_sg.sg_id
  source_security_group_id = module.vpn_sg.sg_id

}
resource "security_group_rule" "shipping_bastion_http"{
  type = "ingress"
  from_port = 8080
  to_port =8080
  protocol ="tcp"
  security_group_id = module.shippping_sg.sg_id
  source_security_group_id = module.vpn_sg.sg_id
}
resource "security_group_rule" "shipping_vpn_ssh"{
  type = "ingress"
  from_port = 22
  to_port =22
  protocol ="tcp"
  security_group_id = module.shippping_sg.sg_id
  source_security_group_id = module.vpn_sg.sg_id
}
resource "security_group_rule" "shipping_bastion_ssh"{
  type = "ingress"
  from_port = 22
  to_port =22
  protocol ="tcp"
  security_group_id = module.shippping_sg.sg_id
  source_security_group_id = module.bastion_sg.sg_id
}
resource "security_group_rule" "shipping_alb"{
  type = "ingress"
  from_port = 8080
  to_port =8080
  protocol ="tcp"
  security_group_id = module.shippping_sg.sg_id
  source_security_group_id = module.backend_alb_sg.sg_id
}
resource "security_group_rule" "alb_allowing_shipping"{
  type = "ingress"
  from_port = 80
  to_port =80
  protocol ="tcp"
  security_group_id = module.backend_alb_sg.sg_id
  source_security_group_id = module.mysql_sg.sg_id
}
resource "security_group_rule" "sql_allowing_shipping"{
  type = "ingress"
  from_port = 3306
  to_port =3306
  protocol ="tcp"
  security_group_id = module.mysql_sg.sg_id
  source_security_group_id = module.shipping_sg.sg_id
}

#payment
resource "security_group_rule""payment_vpm_ssh"{
  type = "ingress"
  from_port = 22
  to_port= 22
  protocol = "tcp"
  security_group_id = module.payment_sg.sg_id
  source_security_group_id = module.vpn_sg.sg_id
}

resource "security_group_id""payment_ssh_bastion"{
  type = "ingress"
  from_port = 22
  to_port =22
  security_group_id = module.payment_sg.sg_id
  source_security_group_id = module.bastion_sg.sg_id
}
resource "security_group_id""payment_ssh_bastion"{
  type = "ingress"
  from_port = 8080
  to_port = 8080
  security_group_id = module.payment_sg.sg_id
  source_security_group_id = module.bastion_sg.sg_id
}

resource "security_group_rule" "payment_http_vpn" {
  type = "ingress"
  from_out = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.payment_sg.sg_id
}
resource "security_group_rule" "payment_allowing_alb" {
  type = "ingress"
  from_out = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backend_alb_sg.sg_id
  security_group_id = module.payment_sg.sg_id
}
resource "security_group_rule" "rabbitmq_allowing_payment" {
  type = "ingress"
  from_out = 5672
  to_port = 5672
  protocol = "tcp"
  source_security_group_id = module.payment_sg.sg_id
  security_group_id = module.rabbitma_sg.sg_id
}
resource "security_group_rule" "alb_allowing_user" {
  type = "ingress"
  from_out = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.user_sg.sg_id
  security_group_id = module.backend_alb_sg_sg.sg_id
}
resource "security_group_rule" "alb_allowing_cart" {
  type = "ingress"
  from_out = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.cart_sg.sg_id
  security_group_id = module.backend_alb_sg_sg.sg_id
}
resource "security_group_rule" "front_end_ssh_vpn" {
  type = "ingress"
  from_out = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.front_end_sg.sg_id
}
resource "security_group_rule" "front_end_ssh_vpn" {
  type = "ingress"
  from_out = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.front_end_sg.sg_id
}
resource "security_group_rule" "front_end_ssh_bastion" {
  type = "ingress"
  from_out = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.front_end_sg.sg_id
}
resource "security_group_rule" "front_end_ssh_bastion" {
  type = "ingress"
  from_out = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.front_end_sg.sg_id
}
resource "security_group_rule" "front_end_ssh_bastion" {
  type = "ingress"
  from_out = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.front_end_sg.sg_id
}
resource "security_group_rule" "front_end_alb_frontend" {
  type = "ingress"
  from_out = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.frontend_alb_sg.sg_id
  security_group_id = module.front_end_sg.sg_id
}


