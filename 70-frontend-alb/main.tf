module "frontend-alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "frontend-alb"
  vpc_id  = data.aws_ssm_parameter.vpc_id.value
  version = "9.13.0"
  subnets = local.public_subnet_id
  create_security_group = false
  security_groups = [data.aws_ssm_parameter.frontend_alb_sg.value]  
  enable_deletion_protection = false
  internal = false
  tags = merge(local.tags,
  {
    Name = "${var.project}-${var.environment}-frontend-alb"
  })
  
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = module.frontend-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_ssm_parameter.certificate_arn.value


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>hello from frontend alb<h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record""frontend"{
    zone_id = var.zone_id
    name  = "*.ramana.site"
    type = "A"
    
    
  alias {
    name                   = module.frontend-alb.dns_name
    zone_id                = module.frontend-alb.zone_id
    evaluate_target_health = true
  }
}
