resource "aws_lb_target_group" "alb-catalogue" {
  name        = "${var.project}-${var.environment}-backend-catalogue"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 3
    interval = 15
    timeout = 2 
    path = "/health"
    port = 8080
    matcher = "200-299"
  }
}

resource "aws_instance" "catalogue" {
  ami = data.aws_ami.roboshop.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg.value]
  subnet_id = split(",",data.aws_ssm_parameter.private_subnet_ids.value)[0]

  tags = merge(local.tags,{
    Name = "${var.project}-${var.environment}-catalogue"
  })
}


resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]

  connection {
   user="ec2-user" 
   password = "DevOps321"
   type ="ssh"
   host = aws_instance.catalogue.id
  }

  provisioner "file" {
    source = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state""stop_catalogue"{
  instance_id = aws_instance.catalogue.id
  state = "stopped"
  depends_on = [terraform_data.catalogue]
}

resource "aws_ami_from_instance""catalogue"{
  name = "catalogue"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.stop_catalogue]
}

resource "terraform_data" "name" {
  triggers_replace = [aws_ami_from_instance.catalogue]

  provisioner "local-exec"{
       command = "aws ec2 terminate-instances --instance-ids aws_instance.catalogue.id"
}
depends_on = [ aws_instance.catalogue ]
}

resource "aws_launch_template" "catalogue" {
  name =  "${var.project}-${var.environment}-catalogue"
  image_id = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name =  "${var.project}-${var.environment}-catalogue"
    }
  }

    tag_specifications{
       resource_type = "volume"
    tags = {
      Name =  "${var.project}-${var.environment}-catalogue"
    }
  }   

  tags = merge(local.tags,{
    Name = "${var.project}-${var.environment}-"
  })
}

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${var.project}-${var.environment}-catalogue"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  target_group_arns         =  [aws_lb_target_group.alb-catalogue.arn]
  vpc_zone_identifier       =   split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }
  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }

   instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = [aws_launch_template.catalogue.id]
  }

    timeouts {
    delete = "15m"
  }

}

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_ami_from_instance.catalogue.name
  name                   = "${var.project}-${var.environment}-catalogue"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value =75
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = data.aws_ssm_parameter.backend_alb_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-catalogue.arn
  }



  condition {
    host_header {
      values = ["catalogue.backend-dev.ramana.site"]
    }
  }
}