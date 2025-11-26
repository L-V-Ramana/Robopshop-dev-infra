locals{
    public_subnet_ids = split(" , ",data.aws_ssm_parameter.public_subnet_ids.value)
    tags = {
        project = var.project
        environmet = var.environment
        terraform =true
    }
}
