resource "aws_instance""reddis"{
    ami = data.aws_ami.joindevops_ami.id
    instance_type = "t3.micro"
    subnet_id = local.database_subnet_ids[0]
    vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]

    tags = merge(local.common-tags,{
        Name = "${var.project}-${var.environment}-redis"
    })
}

resource "terraform_data" "redis" {

    triggers_replace = [
        aws_instance.reddis.id
    ]
    connection {
        
        type = "ssh"
        user= "ec2-user"
        password = "DevOps321"
        host = aws_instance.reddis.private_ip
    }
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }
    
    provisioner "remote-exec" {
      inline = [ 
        "sudo chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
       ]
    }
}

resource "aws_route53_record""redis"{
  zone_id = var.zone_id
  name = "redis-${var.environment}.${var.domain_name}"
  records = [aws_instance.reddis.private_ip]
  type = "A"
  ttl =1
}