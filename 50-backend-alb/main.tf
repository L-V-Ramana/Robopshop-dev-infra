module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${var.project}-${var.environment}-backend-alb"
  vpc_id  = data.aws_ssm_parameter.vpc_id.value
  version = "9.13.0"
  subnets = local.private_subnet_id
  create_security_group = false
  security_groups = [data.aws_ssm_parameter.backend_alb_sg_id.value]
  enable_deletion_protection = false
  internal = true
  tags = merge(local.tags,{
    Name = "${var.project}-${var.environment}-backend-alb"
  })
  
}


resource "aws_lb_listener" "fixed" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>hello,backed alb response</h1>"
      status_code  = "200"
    }
  }
  
}

resource "aws_route53_record""backend_alb"{
    name = "*.backend-${var.environment}.ramana.site"
    type = "A"
    zone_id = "Z09108151OJP740F79CO"


    
     alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id #here we need to give alb zone id, not our ramana.site zone id
    evaluate_target_health = true
  }

}