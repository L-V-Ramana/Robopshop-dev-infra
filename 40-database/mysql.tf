resource "aws_instance""mysql"{
    ami = data.aws_ami.joindevops_ami.id
    instance_type= "t3.micro"
    subnet_id = local.database_subnet_ids[0]
    vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
    iam_instance_profile = "ec2RoleToFetchSsmParameters"

    tags = merge(local.common-tags,{
        Name = "${var.project}-${var.environment}-mysql"
    })


}

resource "terraform_data""mysql"{
    triggers_replace = [
        aws_instance.mysql.id
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
      host = aws_instance.mysql.private_ip
    }

    provisioner "file" {
      source = "bootstrap.sh"
      destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec"{
            inline = [
                    "sudo chmod +x /tmp/bootstrap.sh",
                    "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
            ]
    }
}

resource "aws_route53_record""mysql"{
  zone_id = var.zone_id
  name = "catalogue-${var.environment}.${var.domain_name}"
  ttl =1
  type = "A"
  records = [aws_instance.mysql.private_ip]
}