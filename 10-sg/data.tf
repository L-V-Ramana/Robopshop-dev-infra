data "aws_ssm_parameter""vpc_id"{
    name = "/${var.project}/${var.environment}/vpc_id"
}

# data "aws_security_group""frontend"{
#     id = module.front_end_sg.id
# } 