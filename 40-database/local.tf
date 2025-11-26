locals{
    database_subnet_ids = split(",",data.aws_ssm_parameter.database_subnet_id.value)
    common-tags ={
        project = var.project
        environment = var.environment
        terraform = true
    }
}