resource "aws_instance""mongodb"{
    # count = length(local.database_subnet_ids)
    ami  = data.aws_ami.joindevops_ami.id
    instance_type = "t3.micro"
    vpc_security_group_ids= [data.aws_ssm_parameter.mongodb_sg.value]
    subnet_id =  local.database_subnet_ids[0]

    tags = merge(local.common-tags,{
        Name = "${var.project}-${var.environment}-mongodb"
    })
}

resource "terraform_data" "mongodb"{
    triggers_replace = [
        aws_instance.mongodb.id
    ]
     connection {
        type = "ssh"
        user =  "ec2-user"
        password = "DevOps321"
        host = aws_instance.mongodb.private_ip
      }
    provisioner "file" {
      source = "bootstrap.sh"
      destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
     

      inline =[
               "sudo chmod +x /tmp/bootstrap.sh",
               "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
      ]
    }
}

resource "aws_route53_record""mongodb"{
    zone_id = var.zone_id
    name = "mongodb-${var.environment}.${var.domain_name}"
    records =[aws_instance.mongodb.private_ip]
    type= "A"
    ttl = 1
}
