data "aws_ami""open_vpn"{
    owners = ["679593333241"]
    most_recent = true

    filter{
        name = "name"
        values = ["OpenVPN Access Server Community Image-8fbe3379-63b6-43e8-87bd-*"]
    }

    filter{
        name  = "root-device-type"
        values = ["ebs"]
    }

    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter""public_subnet_id"{
    name = "/${var.project}/${var.environment}/public_subnet_id"
}

data "aws_ssm_parameter" "vpn_sg"{
   name =  "/${var.project}/${var.environment}/vpn_sg_id"
}