locals{
    tags = {
        project = var.project
        environment = var.environment
        terraform = true
    }
    public_subnet_id = split(",",data.aws_ssm_parameter.public_subnet_ids.value)
}