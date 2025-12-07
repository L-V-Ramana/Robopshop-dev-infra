data "aws_ami""joindevops_ami"{
    owners = ["973714476881"]
    most_recent = true

    filter{
        name = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }

}

data "aws_ssm_parameter""mongodb_sg"{
    name= "/${var.project}/${var.environment}/mongod_sg"
}

data "aws_ssm_parameter" "database_subnet_id"{
    name = "/${var.project}/${var.environment}/database-subnet_ids"
}

data "aws_ssm_parameter" "redis_sg_id"{
    name = "/${var.project}/${var.environment}/reddis_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id"{
    name = "/${var.project}/${var.environment}/mysql_sg_id"
}

data "aws_ssm_parameter""rabbitmq_sg_id"{
    name = "/${var.project}/${var.environment}/rabbitmq_sg_id"
}