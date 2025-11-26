resource "aws_instance""rabbitmq"{
    ami = data.aws_ami.joindevops_ami.id
    instance_type = "t3.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
    subnet_id = split(",",data.aws_ssm_parameter.database_subnet_id.value)[0]

    tags = merge(local.common-tags,{
        Name = "${var.project}-${var.environment}-rabbitmq"

    })
}

resource "terraform_data""rabbitmq"{
    triggers_replace = [
        aws_instance.rabbitmq.id
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.rabbitmq.private_ip

    }

    provisioner "file" {
      source= "bootstrap.sh"
      destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
      ]
    }
}

resource "aws_route53_record""rabbitmq"{
  zone_id = var.zone_id
  name = "rabbbitmq-${var.environment}.${var.domain_name}"
  records = [aws_instance.rabbitmq.private_ip]
  type = "A"
  ttl =1
}