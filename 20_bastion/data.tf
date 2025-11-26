# data "aws_ssm_parameter""roboshop_vpc"{
#     name = "/${var.project}/${var.environment}/vpc-id"
# }

data "aws_ami" "roboshop"{

    owners = ["973714476881"]
    most_recent = true

    filter{
        name= "name"
        values = ["RHEL-9-DevOps-Practice"]
    }
}

data "aws_ssm_parameter""bastion_sg_id"{
    name = "/${var.project}/${var.environment}/bastion_sg_id"
}

data "aws_ssm_parameter""public_subnet_ids"{
    
    name ="/${var.project}/${var.environment}/public_subnet_id"
}